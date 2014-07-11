#include "Noise.fxh"
#include "FieldStruct.fxh"

cbuffer cColor : register(b0)
{
	float3 size : TARGETSIZE;
}

float Time = 0.0f;

[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	Field[getElementIndex(threadID)] = makeBlankElement();
}

[numthreads(4, 4, 4)]
void mainSine(uint3 threadID : SV_DispatchThreadID )
{
	FieldElement element = makeBlankElement();
	element.Pressure = (sin(length(getObjectCoord(threadID).xyz)) + 1.0f) / 2.0f;
	Field[getElementIndex(threadID)] = element;
}

[numthreads(4, 4, 4)]
void mainNoise( uint3 threadID : SV_DispatchThreadID )
{
	FieldElement element = makeBlankElement();
	
	float4 spaceTime;
	spaceTime.xyz = getObjectCoord(threadID).xyz;
	spaceTime.w = Time;
	
	float noiseValue = snoise(spaceTime);
	noiseValue += 1.0f;
	noiseValue /= 2.0f;
	
	element.Pressure = noiseValue;
	Field[getElementIndex(threadID)] = element;
}

[numthreads(4, 4, 4)]
void mainOnes(uint3 threadID : SV_DispatchThreadID )
{
	FieldElement element = makeBlankElement();
	element.Pressure = 1.0;
	Field[getElementIndex(threadID)] = element;
}

 
technique11 Blank
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}

technique11 SineField
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainSine() ) );
	}
}

technique11 Noise
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainNoise() ) );
	}
}

technique11 Ones
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainOnes() ) );
	}
}