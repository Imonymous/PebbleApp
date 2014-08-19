//
//  ViewController.m
//  Taalkeeper
//
//  Created by Iman Mukherjee on 8/5/14.
//  Copyright (c) 2014 home. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkForJerk:)
                                   userInfo:nil
                                    repeats:NO];
    
    self.tempo = 150;
    self.tempoSlider.minimumValue = 0.0;
    self.tempoSlider.maximumValue = 300.0;
    
    NSString *taalFilePath = [[NSBundle mainBundle]
                            pathForResource:@"Kaharwa-Beats-2" ofType:@"wav"];
    NSURL *taalFileURL = [NSURL fileURLWithPath:taalFilePath];
    
    NSError *err;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:taalFileURL error:&err];
    self.player.volume = 0.4f;
    self.player.enableRate=YES;
    [self.player prepareToPlay];
    [self.player setNumberOfLoops:0];
    [self.player setEnableRate:YES];
    self.player.rate=1.0f;
    [self.player play];
    
    
}

- (BOOL)checkForJerk:(NSTimer *)timer
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate.myWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        NSLog(@"Received message: %@", update);
        
        self.tempo += 5;
        
        self.tempoSlider.value = self.tempo;
        
        self.player.rate=self.tempo/150;
        
        return YES;
    }];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked:(id)sender
{
    NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:42]};
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate.myWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (void)viewDidUnload
{
    [self.pollTimer invalidate];
    self.pollTimer = nil;
}

@end
