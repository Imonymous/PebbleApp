/*
  ==============================================================================

    AudioFilePlayback.cpp
    Created: 8 Mar 2014 5:49:39pm
    Author:  Govinda Ram Pingali

  ==============================================================================
*/

#include "AudioFilePlayback.h"


AudioFilePlayback::AudioFilePlayback()  :   thread ("audio file playback")
{
    formatManager.registerBasicFormats();
    
    resamplingAudioSource   = new ResamplingAudioSource(&transportSource, true);
    
    mixerSource.addInputSource (resamplingAudioSource, false);
	
	masterResamplingSource = new ResamplingAudioSource(&mixerSource, true); //now resample the mixer output
	
	// ..and connect the mixer to our source player.
	audioSourcePlayer.setSource (masterResamplingSource);
    
    sharedAudioDeviceManager->addAudioCallback (&audioSourcePlayer);
    
    thread.startThread (3);
}


AudioFilePlayback::~AudioFilePlayback()
{
    transportSource.setSource (nullptr);
    audioSourcePlayer.setSource (nullptr);
    
    sharedAudioDeviceManager->removeAudioCallback(&audioSourcePlayer);
}




void AudioFilePlayback::startPlaying()
{
    transportSource.setPosition (0);
    transportSource.start();
}


void AudioFilePlayback::stopPlaying()
{
    transportSource.stop();
}



void AudioFilePlayback::loadFileIntoTransport(String filePath)
{
    File audioFile(filePath);
    
    transportSource.stop();
    transportSource.setSource (nullptr);
    currentAudioFileSource = nullptr;
    
    AudioFormatReader* reader = formatManager.createReaderFor (audioFile);
    
    if (reader != nullptr)
    {
        currentAudioFileSource = new AudioFormatReaderSource (reader, true);
        
        // ..and plug it into our transport source
        transportSource.setSource (currentAudioFileSource,
                                   32768,                   // tells it to buffer this many samples ahead
                                   &thread,                 // this is the background thread to use for reading-ahead
                                   reader->sampleRate);     // allows for sample rate correction
        
        currentAudioFileSource->setLooping(true);
        
        transportSource.setGain(0.75);
    }
}

void AudioFilePlayback::setPlayBackRate(double ratio)
{
    resamplingAudioSource->setResamplingRatio(ratio);
}
