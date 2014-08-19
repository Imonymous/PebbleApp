//
//  SharedLibraryViewController.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SharedLibraryInterface.h"

@interface SharedLibraryViewController : UIViewController
{
    SharedLibraryInterface*     backEndInterface;
    
    bool m_bAudioToggleStatus;
    bool m_bTempEffectStatusToggle;
    
    int m_iPlayRecordStatus;
}



@property (retain, nonatomic) IBOutlet UIButton *toggleAudioButton;
- (IBAction)toggleAudioButtonClicked:(UIButton *)sender;


- (IBAction)addEffectButtonClicked:(UIButton *)sender;


- (IBAction)playRecordButtonClicked:(UIButton *)sender;

@end
