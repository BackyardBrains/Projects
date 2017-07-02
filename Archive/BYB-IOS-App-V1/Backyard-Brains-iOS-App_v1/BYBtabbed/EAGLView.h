//
//  EAGLView.h
//
//  Created by Alex Wiltschko on 9/20/09.
//  Modified 7/1/2011 by Zachary King.
//  Copyright Backyard Brains 2009. All rights reserved.
//
//  Superclass with subclasses ContinuousWaveView, TriggerView, PlaybackView



#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "AudioSignalManager.h"

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/

typedef struct {
	GLfloat R;
	GLfloat G;
	GLfloat B;
	GLfloat A;
} linecolor_s;


@interface EAGLView : UIView {

	struct wave_s wave[kNumPointsInWave];
	
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	GLfloat xBegin, xEnd, yBegin, yEnd;
	GLfloat xMin, xMax, yMin, yMax;
	GLfloat waveLineWidth;
	int numPointsInWave;
	
	linecolor_s lineColor;
	
	int numHorizontalGridLines;
	int numVerticalGridLines;
	struct wave_s *gridVertexBuffer;
	struct wave_s *minorGridVertexBuffer;
	linecolor_s gridColor;
	BOOL showGrid;
	
	UInt32 startIndex;
	UInt32 numPointsToDraw;
	
	
	// TODO: hacky modular add-on
	
}


@property GLint backingHeight;
@property GLint backingWidth;
@property GLuint viewFramebuffer;
@property GLuint viewRenderbuffer;
@property (nonatomic, retain) NSTimer *animationTimer;
@property (readonly, retain) EAGLContext *context;

@property NSTimeInterval animationInterval;

@property GLfloat xBegin, xEnd, yBegin, yEnd;
@property GLfloat xMin, xMax, yMin, yMax;
@property GLfloat waveLineWidth;
@property int numPointsInWave;
@property linecolor_s lineColor;

@property int numHorizontalGridLines;
@property int numVerticalGridLines;
@property struct wave_s *gridVertexBuffer;
@property struct wave_s *minorGridVertexBuffer;
@property linecolor_s gridColor;
@property BOOL showGrid;

@property UInt32 startIndex;
@property UInt32 numPointsToDraw;

- (void)prepareOpenGLView;
- (void)drawEverythingToScreen;
- (void)startAnimation;
- (void)stopAnimation;
- (void)autoSetFrame;
- (void)drawGridLines;
- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;
- (void)toggleVisibilityOfGridAndLabels;

/*
- (void)drawView;*/

@end
