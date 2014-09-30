//
//  hubViewController.m
//  AVPlayer_2
//
//  Created by karthikeyan on 8/8/14.
//  Copyright (c) 2014 hubino. All rights reserved.
//

#import "hubViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface hubViewController ()

@property AVPlayer *avPlayer;
@property AVPlayerLayer *layer;
//@property AVPlayer *avPlayer1;
//@property AVPlayerLayer *layer1;
@property NSURL *fileURL1;
@property NSURL *fileURL2;
@property AVURLAsset *asset1;
@property AVURLAsset *asset2;
@property AVURLAsset *asset3;
@property AVURLAsset *asset4;
@property AVPlayerItem* mPlayerItem1;
@property AVPlayerItem* mPlayerItem2;
@property AVPlayerItem* mPlayerItem3;
@property AVPlayerItem* rampPlayerItem;
@property NSURL * renderedURL;

@end

AVAsset *asset;

@implementation hubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAVplayer];
    
    NSString *filepath1 = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"mp4"];
    _fileURL1 = [NSURL fileURLWithPath:filepath1];
    _asset1 = [[AVURLAsset alloc] initWithURL:_fileURL1
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil]];
    self.mPlayerItem1 = [AVPlayerItem playerItemWithAsset:_asset1];
    
    NSString *filepath2 = [[NSBundle mainBundle] pathForResource:@"Movie_Baby" ofType:@"mp4"];
    _fileURL2 = [NSURL fileURLWithPath:filepath2];
    _asset2 = [[AVURLAsset alloc] initWithURL:_fileURL2
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil]];
    self.mPlayerItem2 = [AVPlayerItem playerItemWithAsset:_asset2];
    
    
    NSString *filepath3 = [[NSBundle mainBundle] pathForResource:@"Evian-Roller-Babies-international-version" ofType:@"mp4"];
    NSURL *fileURL3 = [NSURL fileURLWithPath:filepath3];
    _asset3 = [[AVURLAsset alloc] initWithURL:fileURL3
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil]];
   // self.mPlayerItem4 = [AVPlayerItem playerItemWithAsset:_asset3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Di spose of any resources that can be recreated.
}

-(IBAction)butt1
{
    
    if (self.avPlayer.currentItem != self.mPlayerItem1)
    {
        [self.avPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem1];
        
    }
    [_avPlayer play];
}

-(IBAction)butt2:(id)sender{
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.avPlayer.currentItem != self.mPlayerItem2)
    {

        [self.avPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem2];
        
    }
    
    [_avPlayer play];
    
}

-(IBAction)butt3:(id)sender{
    
    [self ramp];

                    //self.mPlayerItem3 = [AVPlayerItem playerItemWithAsset:_asset3];
    
    
}
-(void)finalOutput
{
    _asset3 = [[AVURLAsset alloc] initWithURL:_renderedURL
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil]];
    
    self.mPlayerItem3 = [AVPlayerItem playerItemWithAsset:_asset3];
    
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.avPlayer.currentItem != self.mPlayerItem3)
    {

        [self.avPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem3];
        
    }
    
    [_avPlayer play];

}

-(void)PlayRenderedOutput{
    

    
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.avPlayer.currentItem != self.rampPlayerItem)
    {

        [self.avPlayer replaceCurrentItemWithPlayerItem:self.rampPlayerItem];
        
    }
    
    [_avPlayer play];
}

-(void)setupAVplayer{
    
    AVPlayerItem * emptyitem= Nil;
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:(emptyitem)];
    
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.layer.frame = CGRectMake(4, 200, 312, 300);
    [self.view.layer addSublayer: self.layer];
}


-(void)ramp{
    
    CMTime insertionPoint = kCMTimeZero;
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVAssetTrack *sourceAudioTrack = [[self.asset3 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    AVAssetTrack *sourceVideoTrack = [[self.asset3 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
  
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    double wholeDurationVideo = CMTimeGetSeconds([self.asset3 duration]);
    CMTime trimmedDurationVideo = CMTimeMakeWithSeconds(wholeDurationVideo, 600.0);
    
    NSError *videoInsertError = nil;
    NSError *audioInsertError = nil;
    // Insert video and audio tracks from AVAsset
    if(self.asset3 != nil) {
        
        
        BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDurationVideo) ofTrack:[[self.asset3 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertionPoint error:&videoInsertError];
        
        BOOL audioInsertResult = [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, trimmedDurationVideo) ofTrack:[[self.asset3 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:insertionPoint error:&audioInsertError];
        
        [compositionVideoTrack setPreferredTransform:sourceVideoTrack.preferredTransform];
        
        [compositionAudioTrack setPreferredTransform:sourceAudioTrack.preferredTransform];
        
        
        double scaling = 6.0; // scale value to determind the time stretch depth
        double totalDuration = 11.0*1000; // for how many seconds the video has to be slow mo'ed from the below starttime.
        double stTime = 1.0 *1000; // start time of the video
        double fragment = (totalDuration/1000) * 30; // actually, here 30 is nothing but the fps.
        
        for (int i=0; i<fragment; i++) {
            
            double tInterval = (totalDuration/fragment);
            double t = (1/fragment)*i;
            //                    double scale = scaling - (t*t*(scaling-1));
            double scale = 1+(scaling-1)*(0.5-0.5*cos(2*M_PI*t));
            
            [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(CMTimeMake(stTime, 1000), CMTimeMake((tInterval), 1000)) toDuration:CMTimeMake((tInterval*scale), 1000)];
            
            [compositionAudioTrack scaleTimeRange:CMTimeRangeMake(CMTimeMake(stTime, 1000), CMTimeMake((tInterval), 1000)) toDuration:CMTimeMake((tInterval*scale), 1000)];
            
            stTime = (stTime + (tInterval * scale));
        }
        
        if (!videoInsertResult || nil != videoInsertError) {
            //handle error
            NSLog(@"Video Error : %@",videoInsertError);
            return;
        }
        if (!audioInsertResult || nil != audioInsertError) {
            //handle error
            NSLog(@"Audio Error : %@",audioInsertError);
            return;
        }
    }
    
    AVComposition *Copy_of_MutableComposition = [composition copy];
    
    self.rampPlayerItem = [AVPlayerItem playerItemWithAsset:Copy_of_MutableComposition];
    

    
    [self PlayRenderedOutput];



    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"outputfinal.MOV"];
    //Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPreset1280x720];
    
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL]; // output path;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    NSURL *finalVideoUrl = [NSURL fileURLWithPath:outputURL];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            
            [[NSUserDefaults standardUserDefaults] setObject:outputURL forKey:@"finalVideoURL"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(exportSession.status == AVAssetExportSessionStatusCompleted){


   //               [self writeFinalVideo:finalVideoUrl];
                    
                    
                }
            });
        } else {
            NSLog(@"error: %@", [exportSession error]);
        }
    }];
    
}






@end
