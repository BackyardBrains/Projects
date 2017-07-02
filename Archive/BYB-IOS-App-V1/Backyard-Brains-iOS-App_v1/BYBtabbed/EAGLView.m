//
//  EAGLView.m
//  TESTAGAIN
//
//  Created by Alex Wiltschko on 9/20/09.
//  Modified 7/1/2011 by Zachary King.
//  Copyright Backyard Brains 2009. All rights reserved.
//



#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0
#define PI 3.1415926536

// A class extension to declare private methods





@implementation EAGLView
const int numdashes = 100;

@synthesize viewFramebuffer;
@synthesize backingWidth;
@synthesize backingHeight;
@synthesize viewRenderbuffer;
@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;

@synthesize xBegin, xEnd, yBegin, yEnd;
@synthesize xMin, xMax, yMin, yMax;

@synthesize numPointsInWave;

@synthesize waveLineWidth;
@synthesize lineColor;

@synthesize gridColor;
@synthesize numHorizontalGridLines;
@synthesize numVerticalGridLines;
@synthesize showGrid;
@synthesize gridVertexBuffer;
@synthesize minorGridVertexBuffer;


@synthesize startIndex;
@synthesize numPointsToDraw;





- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
	
	[context release];
    [super dealloc];
}


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
		
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], 
										kEAGLDrawablePropertyRetainedBacking, 
										kEAGLColorFormatRGBA8, 
										kEAGLDrawablePropertyColorFormat, 
										nil];
        
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        self.animationInterval = 1.0 / 60.0;
		self.animationTimer = nil;
		
    }
	
    return self;
	
}


- (void)prepareOpenGLView {
	// Preliminaries that we need to do in order to draw anything
	// on the screen in an EAGLView
	[EAGLContext setCurrentContext:context];
	
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
    glViewport(0, 0, backingWidth, backingHeight);
	
    glMatrixMode(GL_PROJECTION);
	
    glLoadIdentity();

	glOrthof(self.xBegin, self.xEnd, self.yBegin, self.yEnd, -1.0f, 1.0f);
	
	glRotatef(0.0, 0.0, 0.0, 1.0);
	
    glMatrixMode(GL_MODELVIEW);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);	
    glEnableClientState(GL_VERTEX_ARRAY);
	
	// Make sure startIndex and numPointsToDraw are set
}


- (void)drawGridLines {
	
	for (int i=0; i < self.numHorizontalGridLines; ++i) {
		// Fill in the horizontal grid lines
		GLfloat horzval = self.yBegin + (i+1.0)*(self.yEnd - self.yBegin)/(numHorizontalGridLines+1.0);
		self.gridVertexBuffer[i*2].x		= self.xBegin;
		self.gridVertexBuffer[i*2].y		= horzval;
		self.gridVertexBuffer[i*2 + 1].x	= self.xEnd;
		self.gridVertexBuffer[i*2 + 1].y	= horzval;
	}
	
	int idx;
	for (int i=0; i < self.numVerticalGridLines; ++i) {
		// Now the vertical lines
		GLfloat vertval = self.xBegin + (i+1.0)*(self.xEnd - self.xBegin)/(numVerticalGridLines+1.0);
		idx = numHorizontalGridLines*2;
		self.gridVertexBuffer[idx + i*2].x		= vertval;
		self.gridVertexBuffer[idx + i*2].y		= self.yBegin;
		self.gridVertexBuffer[idx + i*2 + 1].x	= vertval;
		self.gridVertexBuffer[idx + i*2 + 1].y	= self.yEnd;
	}		
	glColor4f(gridColor.R, gridColor.G, gridColor.B, gridColor.A);
	glLineWidth(0.3);
	
	glVertexPointer(2, GL_FLOAT, 0, self.gridVertexBuffer);
	
	glDrawArrays(GL_LINES, 0, 2*(numHorizontalGridLines+numVerticalGridLines));
	
}


- (void)drawEverythingToScreen {
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];	
}



 
- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];

//	[self drawView];

}


- (BOOL)createFramebuffer {
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)startAnimation {
	[self.animationTimer invalidate];

	NSLog(@"Starting new animation with interval %f...", animationInterval);
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    [self.animationTimer invalidate];
}


- (void)autoSetFrame
{
    
}


- (void)hideAllSubviews {
	
	for(UIView *subview in self.subviews) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[subview setAlpha:0.0];
		[UIView commitAnimations];
	}
}

- (void)toggleVisibilityOfGridAndLabels {
	for(UIView *subview in self.subviews) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[subview setAlpha: (1.0 - subview.alpha)];
		[UIView commitAnimations];
	}

	self.showGrid = !self.showGrid;
	
}



@end
