//
//  BBFile.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SQLitePersistentObject.h"

typedef struct _stimulationLog {
	SInt16 stimVals[1][1];
	UInt32 stimTimes[1][1];    
    BOOL hasStim;
} stimulationLog;


@interface BBFile : SQLitePersistentObject {
	NSString *filename;
	NSString *shortname;
	NSString *subname;
	NSString *comment;
	NSDate *date;
	float samplingrate;
	float gain;
	float filelength;
    BOOL hasStim;
    int stimLog;
	//struct stimulationLog *stimLog; //NEW
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *shortname;
@property (nonatomic, retain) NSString *subname;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSDate *date;
@property float samplingrate;
@property float gain;
@property float filelength;
@property BOOL hasStim;
@property int stimLog;

- (id)initWithRecordingFile;
- (id)initWithFilepath:(NSString *)path;
- (void)updateMetadata;


@end
