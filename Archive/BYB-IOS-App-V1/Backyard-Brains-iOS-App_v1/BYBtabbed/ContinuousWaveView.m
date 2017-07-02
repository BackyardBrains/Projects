//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveView.h"


@implementation ContinuousWaveView

@synthesize audioSignalManager  = _audioSignalManager;

#pragma mark - view lifecycle

- (void)dealloc {
    [super dealloc];
    
    [_audioSignalManager release];
}


- (id)initWithCoder:(NSCoder*)coder {
    
	NSLog(@"init'd with coder");
	
	self = [super initWithCoder:coder];
	[self layoutSubviews];
	return self;
}

- (void)drawView {
	
	[self prepareOpenGLView];
	
	[self.audioSignalManager fillVertexBufferWithAudioData];	// Grab the audio data
	
    
    
	if (self.showGrid)
		[self drawGridLines];
	
	[self drawWave]; // Push those pixels, alright
	
	[self drawEverythingToScreen]; // now push it all to the screen
 	
}


- (void)drawWave {
		
	// Feed the data into the OpenGL context
	
	struct wave_s *vb = self.audioSignalManager.vertexBuffer;
		
    glVertexPointer(2, GL_FLOAT, 0, vb);

	// Set the line width to whatever we've chosen in waveLineWidth
//	glLineWidth(self.waveLineWidth);
	glLineWidth(1.0f);
	// Let's color the line
//	glColor4f(self.lineColor.R, self.lineColor.G, self.lineColor.B, self.lineColor.A);	
	glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
	
	glDrawArrays(GL_LINE_STRIP, 0, kNumPointsInVertexBuffer);
}

- (void)drawGridLines {
	[super drawGridLines];
	return; 
	
	glColor4f(gridColor.R/1.5f, gridColor.G/1.5f, gridColor.B/1.5f, gridColor.A);
	glLineWidth(0.3);
	
	glVertexPointer(2, GL_FLOAT, 0, self.minorGridVertexBuffer);

	int minorNumHrzLines = self.numHorizontalGridLines*4;
	int minorNumVertLines = self.numVerticalGridLines*4;
	glDrawArrays(GL_LINES, 0, 2*(minorNumHrzLines+minorNumVertLines));
	
}

- (void)updateMinorGridLines {
	int minorNumHrzLines = self.numHorizontalGridLines*4 - 1;
	int minorNumVertLines = self.numVerticalGridLines*4 - 1;
	
	for (int i=0; i < minorNumHrzLines; ++i) {
		// Fill in the horizontal grid lines
		GLfloat horzval = self.yBegin + (i+1.0)*(self.yEnd - self.yBegin)/(minorNumHrzLines+1.0);
		self.minorGridVertexBuffer[i*2].x		= self.xBegin;
		self.minorGridVertexBuffer[i*2].y		= horzval;
		self.minorGridVertexBuffer[i*2 + 1].x	= self.xEnd;
		self.minorGridVertexBuffer[i*2 + 1].y	= horzval;
	}
	
	int idx;
	for (int i=0; i < minorNumVertLines; ++i) {
		// Now the vertical lines
		GLfloat vertval = self.xBegin + (i+1.0)*(self.xEnd - self.xBegin)/(minorNumVertLines+1.0);
		idx = minorNumHrzLines*2;
		self.minorGridVertexBuffer[idx + i*2].x		= vertval;
		self.minorGridVertexBuffer[idx + i*2].y		= self.yBegin;
		self.minorGridVertexBuffer[idx + i*2 + 1].x	= vertval;
		self.minorGridVertexBuffer[idx + i*2 + 1].y	= self.yEnd;
	}		
	
}


@end
