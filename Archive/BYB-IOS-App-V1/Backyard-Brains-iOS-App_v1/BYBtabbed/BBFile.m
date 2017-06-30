//
//  BBFile.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFile.h"

#define  kDataID 1633969266

@implementation BBFile

@synthesize filename;
@synthesize shortname;
@synthesize subname;
@synthesize comment;
@synthesize date;
@synthesize samplingrate;
@synthesize gain;
@synthesize filelength;
@synthesize hasStim, stimLog;

- (void)dealloc {
	[filename release];
	[shortname release];
	[subname release];
	[comment release];
	[date release];
	
	[super dealloc];

}

- (id)initWithRecordingFile {
	if ((self = [super init])) {
		
		
		self.date = [NSDate date];		

		//Format date into the filename
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

		[dateFormatter setDateFormat:@"h'-'mm'-'ss'-'S a', 'M'-'d'-'yyyy'.aif'"];
		self.filename = [dateFormatter stringFromDate:self.date];
		
		[dateFormatter setDateFormat:@"h':'mm a"];
		self.shortname = [dateFormatter stringFromDate:self.date];
		
		[dateFormatter setDateFormat:@"M'/'d'/'yyyy',' h':'mm a"];
		self.subname = [dateFormatter stringFromDate:self.date];
				
		[dateFormatter release];
		
		self.comment = @"";

		self.hasStim = NO;
		
		// Grab the sampling rate from NSUserDefaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		self.samplingrate   = [[defaults valueForKey:@"samplerate"] floatValue];
		self.gain           = [[defaults valueForKey:@"gain"] floatValue];
		
	}
	
	return self;
}

- (id)initWithFilepath:(NSString *)path
{
    if ((self = [super init]))
    {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //in case of renaming, use the name of the file (NSString path)
        self.filename = [path stringByReplacingOccurrencesOfString:
                                  [docPath stringByAppendingString:@"/"]
                                                        withString:@""];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
        
        //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:self.filename]);
        // Open the audio file, type = AIFF
        AudioFileID id;
        OSStatus s = AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id); //inFileTypeHint?? just gonna pass 0
        if (s !=noErr)
            NSLog(@"bad times acomin'");

        

        //Load up the metadata
        AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id);     
        
        UInt32 dataID = kDataID;
        UInt32 propertySize;
        AudioFileGetUserDataSize(id, dataID, 0, &propertySize);
        void *buffer = malloc(propertySize);
        OSStatus t = AudioFileGetUserData(id, dataID, 0, &propertySize, &buffer);
        //UInt32 newTest = (UInt32)buffer;
        //if ([(NSDictionary *)buffer respondsToSelector:@selector(objectForKey:)])
        //{
            NSDictionary *theDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)buffer];
            if (t!=noErr)
                NSLog(@"get property stop");
            else
                NSLog(@"get property go");
            
            //[theDict retain];
            self.shortname    = [theDict objectForKey:@"shortname"];
            self.subname      = [theDict objectForKey:@"subname"];
            self.comment      = [theDict objectForKey:@"comment"];
            self.date         = [theDict objectForKey:@"date"];		
            self.samplingrate = [[theDict objectForKey:@"samplingrate"] floatValue];
            self.gain         = [[theDict objectForKey:@"gain"] floatValue];
            self.filelength   = [[theDict objectForKey:@"filelength"] floatValue];
            self.hasStim      = [[theDict objectForKey:@"hasStim"] boolValue];
            self.stimLog      = [[theDict objectForKey:@"stimLog"] intValue];

            //if the filename has changed, update the metadata
            if (self.filename != [theDict objectForKey:@"filename"])
            {
                NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:theDict];
                [mutDict setObject:self.filename forKey:@"filename"];
                theDict = [NSDictionary dictionaryWithDictionary:mutDict];
                [mutDict release];
                
                UInt32 propertySize = sizeof(theDict);
                void *inBuffer = (void *)theDict;
                OSStatus s = AudioFileSetUserData(id, dataID, 0, propertySize, &inBuffer);
                if (s!=noErr)
                    NSLog(@"Set property error. Kahhhn!!!");
                else
                    NSLog(@"All systems go");
            }
            
        //}
        //else
        //{
            //make up some metadata here
        //    NSLog(@"File has no metadata");
       // }
        
        free(buffer);
        AudioFileClose(id);
    }
    
    return self;
}


- (void)deleteObject {
	[super deleteObject];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSError *error = nil;
	if (!	[fileManager removeItemAtPath:[docPath stringByAppendingPathComponent:self.filename] error:&error]) {
		NSLog(@"Error deleting file: %@", error);
	}
	
}

- (void)updateMetadata
{   

    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.filename]];
    
    
    
    NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:self.filename]);
    // Open the audio file, type = AIFF
    AudioFileID id;
    AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id); 
    
    UInt32 dataID = kDataID;
    UInt32 numItems = 0;
    OSStatus r = AudioFileCountUserData ( id, dataID, &numItems );
    if (r==noErr)
        NSLog(@"num items:%lu",numItems);
    if (numItems>0)
        NSLog(@"METADATA self destruct (bad index)");

    
    NSDictionary *theDict = [NSDictionary dictionaryWithObjectsAndKeys:self.filename, @"filename",
                             self.shortname, @"shortname",
                             self.subname, @"subname",
                             self.comment, @"comment",
                             self.date, @"data",
                             self.samplingrate, @"samplingrate",
                             self.gain, @"gain",
                             self.filelength, @"filelength",
                             self.hasStim, @"hasStim",
                             self.stimLog, @"stimLog", nil]; 
    //CFDictionaryRef theDictRef = (CFDictionaryRef)theDict;
    //UInt32 test = 1000000000;
    UInt32 propertySize = sizeof(theDict);
    void *inBuffer = (void *)theDict;
    //NSDictionary *testCasting = (NSDictionary *)inBuffer;
    //OSStatus s = AudioFileSetProperty(id, kAudioFilePropertyInfoDictionary, propertySize, theDictRef);
    OSStatus s = AudioFileSetUserData(id, dataID, 0, propertySize, &inBuffer);
    if (s!=noErr)
        NSLog(@"Set property error. Kahhhn!!!");
    else
        NSLog(@"All systems go");

    AudioFileClose(id);
    
        
    [self save];
}

@end
