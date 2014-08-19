//
//  SharedLibraryInterface.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "SharedLibraryInterface.h"


SharedLibraryInterface::SharedLibraryInterface()
{
    audioEngine     =   new AudioEngine();
}


SharedLibraryInterface::~SharedLibraryInterface()
{
    delete audioEngine;
}


void SharedLibraryInterface::toggleAudioButtonClicked(bool toggleStatus)
{
    if (toggleStatus)
    {
        audioEngine->startAudioStreaming();
    }
    
    else
    {
        audioEngine->stopAudioStreaming();
    }
}


void SharedLibraryInterface::setParameter(int sampleID, int effectID, int parameterID, float value)
{
    
}


void SharedLibraryInterface::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    audioEngine->addAudioEffect(sampleID, effectPosition, effectID);
}


void SharedLibraryInterface::removeAudioEffect(int sampleID, int effectPosition)
{
    audioEngine->removeAudioEffect(sampleID, effectPosition);
}


void SharedLibraryInterface::setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState)
{
    
}



void SharedLibraryInterface::playRecordButtonClicked(int playRecordStatus)
{
    audioEngine->playRecordStop(playRecordStatus);
}