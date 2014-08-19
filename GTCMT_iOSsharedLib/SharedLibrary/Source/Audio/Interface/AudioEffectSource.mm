//
//  AudioEffectSource.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioEffectSource.h"


AudioEffectSource::AudioEffectSource(int effectID, int numChannels, float sampleRate)
{
    switch (effectID)
    {
        
        // Delay
        case 0:
        {
//            delayEffect     =   new CDelay(numChannels, sampleRate);
            break;
        }
            
        
        default:
            break;
    }
    
    m_iEffectID  = effectID;
}


AudioEffectSource::~AudioEffectSource()
{
//    delayEffect =   nullptr;
    // Null the effects
}


void AudioEffectSource::setParameter(int parameterID, float value)
{
    
}



void AudioEffectSource::process(float **audioBuffer, int blockSize, bool bypassState)
{
    switch (m_iEffectID)
    {
        // Delay
        case 0:
        {
//            delayEffect->process(audioBuffer, blockSize, bypassState);
            break;
        }
            
            
        default:
            break;
    }
}