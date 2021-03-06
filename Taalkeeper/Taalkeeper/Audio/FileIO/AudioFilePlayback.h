/*
  ==============================================================================

    AudioFilePlayback.h
    Created: 8 Mar 2014 5:49:39pm
    Author:  Govinda Ram Pingali

  ==============================================================================
*/

#ifndef AUDIOFILEPLAYBACK_H_INCLUDED
#define AUDIOFILEPLAYBACK_H_INCLUDED


#include "SharedLibraryHeader.h"

class AudioFilePlayback
{
    
public:
    
    AudioFilePlayback();
    ~AudioFilePlayback();
    
    void startPlaying();
    void stopPlaying();
    
    void loadFileIntoTransport(String filePath);
    void setPlayBackRate(double ratio);
    
private:
    
    String m_sCurrentFilePath;
    
    AudioFormatManager formatManager;
    TimeSliceThread thread;
    
    AudioSourcePlayer audioSourcePlayer;
    AudioTransportSource transportSource;
    ScopedPointer<AudioFormatReaderSource> currentAudioFileSource;
    
    MixerAudioSource mixerSource;
    ScopedPointer<ResamplingAudioSource> resamplingAudioSource;
    ScopedPointer<ResamplingAudioSource> masterResamplingSource;
    
};


#endif  // AUDIOFILEPLAYBACK_H_INCLUDED
