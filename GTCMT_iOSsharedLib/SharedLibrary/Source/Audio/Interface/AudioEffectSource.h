//
//  AudioEffectSource.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioEffectSource__
#define __SharedLibrary__AudioEffectSource__

#include "SharedLibraryHeader.h"
//#include "Delay.h"
// Add Effect Header Here


class AudioEffectSource
{
public:
    
    AudioEffectSource(int effectID, int numChannels, float sampleRate);
    ~AudioEffectSource();
    
    void setParameter(int parameterID, float value);
    
    void process(float** audioBuffer, int blockSize, bool bypassState);
    
    
private:
    
//    ScopedPointer<CDelay>   delayEffect;
    //Declare Effect Object Here
    
    int m_iEffectID;
};

#endif /* defined(__SharedLibrary__AudioEffectSource__) */
