//
//  AudioEngine.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioEngine.h"

ScopedPointer<AudioDeviceManager> sharedAudioDeviceManager;


AudioEngine::AudioEngine()
{
    sharedAudioDeviceManager = new AudioDeviceManager();
    sharedAudioDeviceManager->initialise(2, 2, 0, true, String::empty, 0);
    
    liveAudioStream     =   new AudioStream();
    m_bAudioThreadRunning   =   false;
    
    audioFileRecorder   =   new AudioFileRecord();
    audioFilePlayer     =   new AudioFilePlayback();
    
    currentFilePath = File::getSpecialLocation(File::userDocumentsDirectory).getFullPathName() + "/Kaharwa-Beats-1.wav";
}



AudioEngine::~AudioEngine()
{
    liveAudioStream             =   nullptr;
    
    audioFileRecorder           =   nullptr;
    audioFilePlayer             =   nullptr;
    
    sharedAudioDeviceManager    =   nullptr;
}



void AudioEngine::startAudioStreaming()
{
    m_bAudioThreadRunning   =   true;
    sharedAudioDeviceManager->addAudioCallback(liveAudioStream);
}


void AudioEngine::stopAudioStreaming()
{
    m_bAudioThreadRunning   =   false;
    sharedAudioDeviceManager->removeAudioCallback(liveAudioStream);
}



void AudioEngine::addAudioEffect(int sampleID, int effectPosition, int effectID)
{
    sharedAudioDeviceManager->removeAudioCallback(liveAudioStream);
    liveAudioStream->addAudioEffect(sampleID, effectPosition, effectID);
    
    
    // If audio was previously on, switch it on again
    if (m_bAudioThreadRunning)
    {
        sharedAudioDeviceManager->addAudioCallback(liveAudioStream);
    }
    
}



void AudioEngine::removeAudioEffect(int sampleID, int effectPosition)
{
    sharedAudioDeviceManager->removeAudioCallback(liveAudioStream);
    liveAudioStream->removeAudioEffect(sampleID, effectPosition);
    
    
    // If audio was previously on, switch it on again
    if (m_bAudioThreadRunning)
    {
        sharedAudioDeviceManager->addAudioCallback(liveAudioStream);
    }
    
}



void AudioEngine::setAudioEffectBypassState(int sampleID, int effectPosition, bool bypassState)
{
    liveAudioStream->setAudioEffectBypassState(sampleID, effectPosition, bypassState);
}


bool AudioEngine::isAudioRunning()
{
    return m_bAudioThreadRunning;
}

void AudioEngine::changePlaybackRate(double ratio)
{
    audioFilePlayer->setPlayBackRate(ratio);
}

void AudioEngine::playRecordStop(int value)
{
    if (value == 0)
    {
        audioFileRecorder->stopRecording();
        audioFilePlayer->stopPlaying();
    }
    
    
    else if (value == 1)
    {
        audioFilePlayer->stopPlaying();
        audioFileRecorder->startRecording(currentFilePath);
    }
    
    
    else if (value == 2)
    {
        audioFileRecorder->stopRecording();
        audioFilePlayer->loadFileIntoTransport(currentFilePath);
        audioFilePlayer->startPlaying();
    }
}

void AudioEngine::play()
{
    audioFilePlayer->loadFileIntoTransport(currentFilePath);
    audioFilePlayer->startPlaying();
}