#include "Noise.fxh"

cbuffer cColor : register(b0)
{
	float3 size : TARGETSIZE;
}

RWTexture3D<float4> Output : BACKBUFFER;
float4x4 Transform : WORLDINVERSE;
float4x4 tTextureToWorld <String uiname="Transform Texture To World";>;
float Time = 0.0f;
float IsoSurface = 0.5f;

float4 getObjectCoord(uint3 threadID) {
	uint3 outputCoordinate = uint3(threadID.x, threadID.y, threadID.z);
	float4 textureCoord;
	textureCoord.xyz = (float3) outputCoordinate / size;
	textureCoord.w = 1.0f;
	
	float4 objectCoord = mul(textureCoord, mul(tTextureToWorld, Transform));
	objectCoord /= objectCoord.w;
	
	return objectCoord;	
}
[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	Output[threadID] = getObjectCoord(threadID);
}

[numthreads(4, 4, 4)]
void mainSine(uint3 threadID : SV_DispatchThreadID )
{
	Output[threadID] = sin(length(getObjectCoord(threadID).xyz));
}

[numthreads(4, 4, 4)]
void mainNoise( uint3 threadID : SV_DispatchThreadID )
{
	float4 spaceTime;
	spaceTime.xyz = getObjectCoord(threadID).xyz;
	spaceTime.w = Time;
	
	float noiseValue = snoise(spaceTime);
	noiseValue += 1.0f;
	noiseValue /= 2.0f;
	
	Output[threadID] = noiseValue;
}
 
technique11 PassThrough
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