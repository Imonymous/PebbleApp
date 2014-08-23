//
//  AudioStream.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioStream.h"


AudioStream::AudioStream()
{
    //--- Audio Device Settings ---//
    sharedAudioDeviceManager->getAudioDeviceSetup(deviceSetup);
    
    audioEffectSource.clear();
    m_pbBypassStateArray.clear();
}



AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    audioEffectSource.clear();
}




void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    
}



void AudioStream::audioDeviceStopped()
{
    
}




//==============================================================================
// Process Block
// !!! Running on Audio Thread
//==============================================================================

void AudioStream::audioDeviceIOCallback( const float** inputChannelData,
                                        int totalNumInputChannels,
                                        float** outputChannelData,
                                        int totalNumOutputChannels,
                                        int blockSize)
{
    
    
    // Copy Input Buffer to Output
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumInputChannels; channel++)
        {
            outputChannelData[channel][sample] = inputChannelData[channel][sample];
        }
    }
    
    
    // Iterate through effects and process
    if (audioEffectSource.size() > 0)
    {
        for (int effectNo = 0; effectNo < audioEffectSource.size(); effectNo++)
        {
            audioEffectSource.getUnchecked(effectNo)->process(outputChannelData, blockSize, m_pbBypassStateArray[effectNo]);
        }
        
    }
    
}


//==============================================================================
// Set Audio Effect Parameter
// !!! Called on Audio Thread
//==============================================================================

void AudioStream::setParameter(int sampleID, int effectID, int parameterID, float value)
{
    
}





//==============================================================================
// Add and Remove Audio Effect
// Will pause playback for an instant and restart
//==============================================================================

void AudioStream::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEffectSource.add(new AudioEffectSource(effectID, 2, float(deviceSetup.sampleRate)));
    m_pbBypassStateArray.add(true);
}


void AudioStream::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEffectSource.remove(effectPosition, true);
    m_pbBypassStateArray.remove(effectPosition);
}

void AudioStream::setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState)
{
    m_pbBypassStateArray.set(effectPosition, bypassState);
}
