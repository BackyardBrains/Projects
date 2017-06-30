//
//  iPodStimViewController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/16/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "iPodStimViewController.h"

@implementation iPodStimViewController

@synthesize delegate        = _delegate;
@synthesize ljController    = _ljController;
@synthesize theTableView    = _theTableView;
@synthesize songNames       = _songNames;
@synthesize songArtists     = _songArtists;

#pragma mark - view lifecycle

- (void)dealloc
{
    [super dealloc];
    
    [_theTableView release];
    [_songNames release];
    [_songArtists release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.theTableView setBackgroundView:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.delegate.pulse.songSelected = YES;
    [self updateTableWithCollection:self.delegate.pulse.playlist];
    
    
}



#pragma mark - Actions

- (IBAction)presentTheMediaPicker:(id)sender
{
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc]
     initWithMediaTypes: MPMediaTypeAnyAudio];                   
    
    [picker setDelegate: self];                                        
    [picker setAllowsPickingMultipleItems: YES];                       
    picker.prompt =
    NSLocalizedString (@"Add songs to play",
                       "");
    
    //[picker setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.ljController presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)updateTableWithCollection:(MPMediaItemCollection *)collection 
{
    if (collection.count == 0) {
        self.theTableView.hidden = YES;
        return;
    }
    else
    {
        self.delegate.pulse.playlist = collection;
        self.delegate.pulse.songNowPlaying = 0;
        
        NSArray *songs = [NSArray arrayWithArray:collection.items];
        self.songNames = [NSArray array];
        self.songArtists = [NSArray array];
        for (int i =0; i < songs.count; ++i)
        {
            self.songNames = 
                [self.songNames arrayByAddingObject:[[songs objectAtIndex:i]
                                                     valueForKey:MPMediaItemPropertyTitle]];
            self.songArtists =
                [self.songArtists arrayByAddingObject:[[songs objectAtIndex:i]
                                                     valueForKey:MPMediaItemPropertyArtist]];
        }
        
        self.theTableView.hidden = NO;
        [self.theTableView reloadData];
    }
}

#pragma mark - Implementation of UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.songNames.count > 0 && indexPath.row < self.songNames.count)
    {
        NSString *thisSong = [self.songNames objectAtIndex:indexPath.row];
        UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:thisSong];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:thisSong] autorelease];
            cell.textLabel.text = thisSong;
            cell.detailTextLabel.text = [self.songArtists objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return self.songNames.count;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.delegate.pulse.songSelected = YES;
    
    if (self.delegate.pulse.playing 
            && self.delegate.pulse.songNowPlaying == indexPath.row)
    {
        [self.delegate.pulse stopPulse];
    }
    else if (!self.delegate.pulse.playing 
             && self.delegate.pulse.songNowPlaying == indexPath.row)
    {
        [self.delegate.pulse playPulse];
    }
    else if (self.delegate.pulse.playing 
             && self.delegate.pulse.songNowPlaying != indexPath.row)
    {
        [self.delegate.pulse stopPulse];
        self.delegate.pulse.songNowPlaying = indexPath.row;
        [self.delegate.pulse playPulse];
    }
    else if (!self.delegate.pulse.playing 
             && self.delegate.pulse.songNowPlaying != indexPath.row)
    {
        self.delegate.pulse.songNowPlaying = indexPath.row;
        [self.delegate.pulse playPulse];
    }

    
}

#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{
    
    UITableViewCell *playingCell = [self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.delegate.pulse.songNowPlaying inSection:0]];
    playingCell.selected = YES;
}
- (void)pulseIsStopped
{
    UITableViewCell *playingCell = [self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.delegate.pulse.songNowPlaying inSection:0]];
    playingCell.selected = NO;
}

#pragma mark - Implementation of MPMediaPickerControllerDelegate

- (void) mediaPicker:(MPMediaPickerController *)mediaPicker
   didPickMediaItems:(MPMediaItemCollection *)collection {
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    [self updateTableWithCollection:collection];
}

- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    self.theTableView.hidden = YES;
    self.delegate.pulse.playlist = nil;
}


@end
