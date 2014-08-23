/*
  ==============================================================================

    AudioFileRecord.h
    Created: 8 Mar 2014 5:49:28pm
    Author:  Govinda Ram Pingali

  ==============================================================================
*/

#ifndef AUDIOFILERECORD_H_INCLUDED
#define AUDIOFILERECORD_H_INCLUDED

#include "SharedLibraryHeader.h"

class AudioFileRecord   :   public AudioIODeviceCallback
{
    
public:
    
    AudioFileRecord();
    ~AudioFileRecord();
    
    void startRecording(String filePath);
    void stopRecording();
    
    
    
    void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    void audioDeviceIOCallback (const float** inputChannelData, int numInputChannels,
                                float** outputChannelData, int numOutputChannels,
                                int numSamples) override;
    
    
    bool isRecording();
    
    
private:

    TimeSliceThread backgroundThread;
    
    String m_sCurrentFilePath;
    double  sampleRate;
    
    ScopedPointer<AudioFormatWriter::ThreadedWriter> threadedWriter;
    int64 nextSampleNum;
    
    CriticalSection writerLock;
    AudioFormatWriter::ThreadedWriter* volatile activeWriter;
};




#endif  // AUDIOFILERECORD_H_INCLUDED
