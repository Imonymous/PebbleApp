//
//  ViewController.h
//  Taalkeeper
//
//  Created by Iman Mukherjee on 8/5/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioEngine.h"

@interface ViewController : UIViewController
{
    AudioEngine *audioEngine;
}

@property (strong, nonatomic) NSTimer* pollTimer;
@property (strong, nonatomic) IBOutlet UISlider* tempoSlider;
@property (nonatomic) NSInteger tempo;



- (IBAction)clicked:(id)sender;
- (BOOL)checkForJerk:(NSTimer* )timer;

@end
