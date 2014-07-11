#include "Noise.fxh"
#include "FieldStruct.fxh"

float Attack = 0.5f;
float Decay = 0.1f;

float3 mirror(int3 position, int3 Size) {
	//mirror on low values
	position = (position < 0 ? -position : position);
	
	//mirror on high values
	position = (position >= Size ? 2 * Size - position - 1: position);
	
	return position;
}
float GetPressure(int3 position) {
	position = mirror(position, TextureSize);
	return Field[getElementIndex(position)].Pressure;
}
[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	float adjacentPressure = 0.0f;
	adjacentPressure += GetPressure(threadID + int3(-1,0,0));
	adjacentPressure += GetPressure(threadID + int3(1,0,0));
	adjacentPressure += GetPressure(threadID + int3(0,-1,0));
	adjacentPressure += GetPressure(threadID + int3(0,1,0));
	adjacentPressure += GetPressure(threadID + int3(0,0,-1));
	adjacentPressure += GetPressure(threadID + int3(0,0,1));
	adjacentPressure /= 6.0f;
	
	float pressure = Field[getElementIndex(threadID)].Pressure;
	float previousPressure = Field[getElementIndex(threadID)].PreviousPressure;
	
	Field[getElementIndex(threadID)].NextPressure = pressure + Decay * (pressure - previousPressure) + Attack * (adjacentPressure - pressure);
}

[numthreads(4, 4, 4)]
void mainSwap(uint3 threadID : SV_DispatchThreadID )
{
	FieldElement element = Field[getElementIndex(threadID)];
	element.PreviousPressure = element.Pressure;
	element.Pressure = element.NextPressure;
	Field[getElementIndex(threadID)] = element;
}
 
technique11 WaveRun
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}

technique11 WaveSwap
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainSwap() ) );
	}
}