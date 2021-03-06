#include "Delay.h"

CDelay::CDelay(int numChannels)
{
	feedBack = 0;
	wetDry = 0;

	ringBuffer = new CRingBuffer<float> *[numChannels];

	for (int n = 0; n < numChannels; n++)
	{
		ringBuffer[n]	= new CRingBuffer<float>(2*(int)(MAX_DELAY));	
		// set indices and buffer contents to zero:
		ringBuffer[n]->resetInstance();
	};

	delayTime = 0;

	initDefaults();
};

void CDelay::initDefaults()
{
	setFeedback(0.5);
	setDelayTime(0.5);
	setWetDry(0.5);
}

void CDelay::setSampleRate(int smplRate)
{
	if (smplRate >0)
		sampleRate = smplRate;
}

void CDelay::setChanNum(int numChan)
{
	if (numChan >= 1)
		numChannels = numChan;
}

void CDelay::setDelayTime(float delay)
{
	if (delay >= 0)
	{
		if (delay <= getMaxDelay())
		{
			delayTime = delay;
			// set the read index of each ring buffer to the correct index:
			for (int n = 0; n < numChannels; n++)
				ringBuffer[n]->setReadIdx(-(int)((delay/getMaxDelay())*getSampleRate()));
		};
	};
}

void CDelay::setWetDry(float mix)
{
	if (abs(mix) <= 1)
		wetDry = mix;
}

void CDelay::setFeedback(float fdBack)
{
	if (fdBack >= 0 && fdBack <= 1)
		feedBack = fdBack;
}

void CDelay::setMaxDelay(float delayTimeInS)
{
	if (delayTimeInS > 0)
		maxDelayTimeInS = delayTimeInS;
}

void CDelay::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case 0:
			// delayTime_target	= value;
			if (value > 0)
				delayTime = value;
		break;
		case 1:
			// feedBack_target		= value;
			if (value >= 0 && value <= 1)
				feedBack = value;
		break;
		case 2:
			// wetDry_target		= value;
			if (abs(value) <= 1)
				wetDry = value;
		break;
		default: break;
	};
}

void CDelay::process(float **inputBuffer, int numFrames, bool bypass)
{
	
	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < numChannels; c++)
		{	
			// ugly looking equation for fractional delay:
			inputBuffer[c][i] =	(1-getWetDry())*(inputBuffer[c][i]) 
								+ getFeedback()*getWetDry()*((ringBuffer[c]->getPostInc())*(getDelay()*getSampleRate()-(int)(getDelay()*getSampleRate()))
								+ (ringBuffer[c]->get())*(1-getDelay()*getSampleRate()+(int)(getDelay()*getSampleRate())));

			// outputBuffer[c][i] =	(1-getWetDry())*(inputBuffer[c][i])
			//						 + 0.5*getWetDry()*(ringBuffer[c]->getPostInc());

			// add the output value to the ring buffer:
			ringBuffer[c]->putPostInc(inputBuffer[c][i]);
		};
	};
}
	
float CDelay::getParam(/*hFile::enumType type*/ int type)
{
	switch(type)
	{
		case 0:
			return delayTime_target;
		break;
		case 1:
			return feedBack_target;
		break;
		case 2:
			return wetDry_target;
		break;
	};
    
    return 0.0;
}

int CDelay::getSampleRate()
{
	return sampleRate;
}

float CDelay::getWetDry()
{
	return wetDry;
}

float CDelay::getDelay()
{
	return delayTime;
}

float CDelay::getFeedback()
{
	return feedBack;
}

float CDelay::getMaxDelay()
{
	return maxDelayTimeInS;
}

void CDelay::reset()
{
		for (int c = 0; c < numChannels; c++)
		{	
			ringBuffer[c]->resetInstance();
		};
}