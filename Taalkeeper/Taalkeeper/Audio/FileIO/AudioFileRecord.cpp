/*
  ==============================================================================

    AudioFileRecord.cpp
    Created: 8 Mar 2014 5:49:28pm
    Author:  Govinda Ram Pingali

  ==============================================================================
*/

#include "AudioFileRecord.h"


AudioFileRecord::AudioFileRecord()  :   backgroundThread ("Audio Recorder Thread"),
sampleRate (0), nextSampleNum (0), activeWriter (nullptr)
{
    backgroundThread.startThread();
}


AudioFileRecord::~AudioFileRecord()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    stopRecording();
}


void AudioFileRecord::startRecording(String filePath)
{
    m_sCurrentFilePath  =   filePath;
    
    
    stopRecording();
    File file(m_sCurrentFilePath);
    
    
    sharedAudioDeviceManager->addAudioCallback(this);
    
    if (sampleRate > 0)
    {
        // Create an OutputStream to write to our destination file...
        file.deleteFile();
        ScopedPointer<FileOutputStream> fileStream (file.createOutputStream());
        
        if (fileStream != nullptr)
        {
            // Now create a WAV writer object that writes to our output stream...
            WavAudioFormat wavFormat;
            AudioFormatWriter* writer = wavFormat.createWriterFor (fileStream, sampleRate, 1, 16, StringPairArray(), 0);
            
            if (writer != nullptr)
            {
                fileStream.release(); // (passes responsibility for deleting the stream to the writer object that is now using it)
                
                // Now we'll create one of these helper objects which will act as a FIFO buffer, and will
                // write the data to disk on our background thread.
                threadedWriter = new AudioFormatWriter::ThreadedWriter (writer, backgroundThread, 32768);
                
                // Reset our recording thumbnail
                nextSampleNum = 0;
                
                // And now, swap over our active writer pointer so that the audio callback will start using it..
                const ScopedLock sl (writerLock);
                activeWriter = threadedWriter;
            }
        }
    }
    
    
    
    
    
}




void AudioFileRecord::stopRecording()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    
    // First, clear this pointer to stop the audio callback from using our writer object..
    {
        const ScopedLock sl (writerLock);
        activeWriter = nullptr;
    }
    
    // Now we can delete the writer object. It's done in this order because the deletion could
    // take a little time while remaining data gets flushed to disk, so it's best to avoid blocking
    // the audio callback while this happens.
    threadedWriter = nullptr;
    
}





void AudioFileRecord::audioDeviceAboutToStart (AudioIODevice* device)
{
    sampleRate = device->getCurrentSampleRate();
}


void AudioFileRecord::audioDeviceStopped()
{
    sampleRate = 0;
}

void AudioFileRecord::audioDeviceIOCallback (const float** inputChannelData, int numInputChannels,
                            float** outputChannelData, int numOutputChannels,
                            int numSamples)
{
    const ScopedLock sl (writerLock);
    
    if (activeWriter != nullptr)
    {
        activeWriter->write (inputChannelData, numSamples);
        
        // Create an AudioSampleBuffer to wrap our incomming data, note that this does no allocations or copies, it simply references our input data
//        const AudioSampleBuffer buffer (const_cast<float**> (inputChannelData), thumbnail.getNumChannels(), numSamples);
        
//        nextSampleNum += numSamples;
    }
    
    // We need to clear the output buffers, in case they're full of junk..
    for (int i = 0; i < numOutputChannels; ++i)
        if (outputChannelData[i] != nullptr)
            FloatVectorOperations::clear (outputChannelData[i], numSamples);
}



bool AudioFileRecord::isRecording()
{
    return activeWriter != nullptr;
}