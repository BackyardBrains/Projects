//
//  DrawingDataManager.h
//  Backyard Brains
//
//  Created by Zachary King on 8/1/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//
//  Superclass with subclasses AudioSignalManager, AudioPlaybackManager
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "Constants.h"
#import "BBFile.h"


struct wave_s {
	GLfloat x;
	GLfloat y;
};




@protocol DrawingDataManagerDelegate
@required
    - (void)shouldAutoSetFrame;

@optional

@property (nonatomic, retain) BBFile *file;
@property (nonatomic, retain) IBOutlet UISlider *scrubBar;
@property (nonatomic, retain) IBOutlet UILabel  *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel  *remainingTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@end


@interface DrawingDataManager : NSObject {
    
	BOOL paused; 
    int nWaitFrames;
	struct wave_s *vertexBuffer; // this buffer is for actual display
	Float64 samplingRate;
	float gain;
    
}


@property BOOL paused;
@property int nWaitFrames;
@property struct wave_s *vertexBuffer;
@property Float64 samplingRate;
@property float gain;

@property (nonatomic, assign) id <DrawingDataManagerDelegate> delegate;

- (void)fillVertexBufferWithAudioData;
- (void)pause;
- (void)play;

- (void)setVertexBufferXRangeFrom:(GLfloat)xBegin to:(GLfloat)xEnd;

@end
