//
//  AudioFileInput.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioFileInput.h"


AudioFileInput::AudioFileInput(int sampleID)
{
    sharedAudioDeviceManager->getAudioDeviceSetup(deviceSetup);
    
    formatManager.registerBasicFormats();
    
    
}


AudioFileInput::~AudioFileInput()
{
    reader = nullptr;
}



void AudioFileInput::setAudioFile(String audioFilePath)
{
    File audioFile(audioFilePath);
    
    reader = formatManager.createReaderFor(audioFile);
    
}


void AudioFileInput::prepareToPlay(int samplesPerBlockExpected, double sampleRate)
{
    
}


void AudioFileInput::getNextAudioBlock(const juce::AudioSourceChannelInfo &bufferToFill)
{
    
}


void AudioFileInput::releaseResources()
{
    
}