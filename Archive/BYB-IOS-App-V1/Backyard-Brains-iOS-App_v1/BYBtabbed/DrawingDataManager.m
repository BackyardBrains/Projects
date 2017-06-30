//
//  DrawingDataManager.m
//  Backyard Brains
//
//  Created by Zachary King on 8/1/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "DrawingDataManager.h"



@implementation DrawingDataManager

@synthesize paused;
@synthesize nWaitFrames;
@synthesize vertexBuffer;

@synthesize samplingRate;
@synthesize gain;

@synthesize delegate;


- (void)fillVertexBufferWithAudioData
{
    
}

- (void)pause
{
    
}

- (void)play
{
    
}



#pragma mark - XRange handling

- (void)setVertexBufferXRangeFrom:(GLfloat)xBegin to:(GLfloat)xEnd {
	for (int i=0; i < kNumPointsInVertexBuffer; ++i) {
		vertexBuffer[i].x = xBegin + i*(xEnd - xBegin)/kNumPointsInVertexBuffer;
	}
}

/*- (void)setVertexBufferXRangeInLog10From:(GLfloat)xBegin to:(GLfloat)xEnd fromSample:(UInt32)startSample toSample:(UInt32)endSample {
    
	float startVal = xBegin;
	float endVal = xEnd;
	
	UInt32 numSamples = endSample - startSample;
	float endLogVal = log10f(endVal);
	float beginLogVal = log10f(startVal);
	
	float logRange = endLogVal - beginLogVal;
	float scaleFactor = (xEnd - xBegin) / logRange;
	float shiftValue = beginLogVal*scaleFactor - xBegin;
	
	float incr = 0.0;
	for (int i=startSample; i < endSample; ++i) {
		vertexBuffer[i].x = scaleFactor*log10f(startVal + (endVal - startVal)*(incr/numSamples)) - shiftValue;
		incr += 1.0;
	}
}

- (UInt32)findXIndexOfValueNearest:(float)thisVal between:(UInt32)startSample and:(UInt32)endSample {
	// NOTE: Assumes vertexBuffer[:].x contains constantly increasing increments.
    
	// Set our first guess to the first sample
	float lastDiff = fabs(thisVal - vertexBuffer[startSample].x);
	UInt32 closestIndex = startSample;
	
	// Now start lookin' ferreal.
	float thisDiff;
	for ( int i=startSample+1; i < endSample; ++i ) {
		thisDiff = fabs( thisVal - vertexBuffer[startSample].x );
		if ( thisDiff < lastDiff ) {
			closestIndex = i;
			lastDiff = thisDiff;
		}
	}
	
	return closestIndex;
}*/



@end
