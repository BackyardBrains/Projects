//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "PlaybackView.h"

#define kNumPointsInPlaybackVertexBuffer 32768

@implementation PlaybackView

@synthesize apm;

// You must implement this method

- (id)initWithCoder:(NSCoder*)coder {
    
	NSLog(@"init'd with coder");
	
	self = [super initWithCoder:coder];
	[self layoutSubviews];
	return self;
}

- (void)drawView {
	
	[self prepareOpenGLView];
	
	[self.apm fillVertexBufferWithAudioData];	// Grab the audio data
	
    
    
	if (self.showGrid)
		[self drawGridLines];
	
	[self drawWave]; // Push those pixels, alright
	
	[self drawEverythingToScreen]; // now push it all to the screen
 	
}


- (void)drawWave {
		
	// Feed the data into the OpenGL context
	
	struct wave_s *vb = self.apm.vertexBuffer;
		
    glVertexPointer(2, GL_FLOAT, 0, vb);

	// Set the line width to whatever we've chosen in waveLineWidth
//	glLineWidth(self.waveLineWidth);
	glLineWidth(1.0f);
	// Let's color the line
//	glColor4f(self.lineColor.R, self.lineColor.G, self.lineColor.B, self.lineColor.A);	
	glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
	
	glDrawArrays(GL_LINE_STRIP, 0, kNumPointsInPlaybackVertexBuffer);
}


- (void)dealloc {
    [super dealloc];
}


@end
