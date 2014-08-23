//
//  AudioStream.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioStream__
#define __SharedLibrary__AudioStream__

#include "SharedLibraryHeader.h"
#include "AudioEffectSource.h"

class AudioStream   :   public AudioIODeviceCallback
{
    
public:
    
    
    AudioStream();
    ~AudioStream();
    
    
    void audioDeviceIOCallback(const float** inputChannelData,
							   int totalNumInputChannels,
							   float** outputChannelData,
							   int totalNumOutputChannels,
							   int blockSize) override;
	
	void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    
    void addAudioEffect(int sampleID, int effectPosition, int effectID);
    void removeAudioEffect(int sampleID, int effectPosition);
    void setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState);
    
    void setParameter(int sampleID, int effectID, int parameterID, float value);
    
private:
    
    AudioDeviceManager::AudioDeviceSetup        deviceSetup;
    
    OwnedArray<AudioEffectSource>   audioEffectSource;
    Array<bool>                     m_pbBypassStateArray;
    

};

#endif /* defined(__SharedLibrary__AudioStream__) */
