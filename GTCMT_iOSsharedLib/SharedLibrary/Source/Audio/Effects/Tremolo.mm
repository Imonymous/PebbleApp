#include "Tremolo.h"

CTremolo::CTremolo(int numChannels)
{
	m_iNumChannels = numChannels;
	initDefaults();
}

void CTremolo::prepareToPlay(float sampleRate)
{
	m_fSampleRate	= sampleRate;
	LFO = new CLFO(sampleRate);	
}

void CTremolo::initDefaults()
{
	m_fDepth	= 1.0;
	m_fRate		= 5.0;
}

void CTremolo::setType(CLFO::LFO_Type type)
{
	LFO->setLFOType(type);
}
 
void CTremolo::setParam(/*hFile::enumType type*/ int type, float value)
{
	switch(type)
	{
		case 0:
			m_fDepth = value;
		break;
		case 1:
			m_fRate = value;
		break;
		default: 
			break;
	};
}

void CTremolo::process(float **inputBuffer, int numFrames, bool bypass)
{
	// generate the LFO:
	LFO->generate(numFrames);

	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < m_iNumChannels; c++)
		{	
			inputBuffer[c][i] = (1 + m_fDepth*LFO->getLFOSampleData(i))*(inputBuffer[c][i]);
		};
	};

}

CTremolo::~CTremolo()
{
	delete [] LFO;
}