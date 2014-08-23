//
//  AudioFileInput.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioFileInput__
#define __SharedLibrary__AudioFileInput__

#include "SharedLibraryHeader.h"


class AudioFileInput        :   public AudioSource
{
    
public:
    
    AudioFileInput(int sampleID);
    ~AudioFileInput();
    
    void setAudioFile(String audioFilePath);
    
    void prepareToPlay(int samplesPerBlockExpected, double sampleRate);
    void getNextAudioBlock	(const AudioSourceChannelInfo& bufferToFill);
    void releaseResources();
    
private:
    
    AudioDeviceManager::AudioDeviceSetup    deviceSetup;
    AudioFormatManager  formatManager;
    ScopedPointer<AudioFormatReader> reader;
    ScopedPointer<AudioFormatReaderSource>  formatReaderSource;
    
};

#endif /* defined(__SharedLibrary__AudioFileInput__) */
