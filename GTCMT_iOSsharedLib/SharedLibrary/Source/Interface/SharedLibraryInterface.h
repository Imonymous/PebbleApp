//
//  SharedLibraryInterface.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__SharedLibraryInterface__
#define __SharedLibrary__SharedLibraryInterface__

#include "AudioEngine.h"

class SharedLibraryInterface
{
public:
    
    SharedLibraryInterface();
    ~SharedLibraryInterface();
    
    void toggleAudioButtonClicked(bool toggleStatus);
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    
    void setParameter(int sampleID, int effectID, int parameterID, float value);
    
    void setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState);
    
    void playRecordButtonClicked(int playRecordStatus);
    
private:
    
    AudioEngine*    audioEngine;
};

#endif /* defined(__SharedLibrary__SharedLibraryInterface__) */
