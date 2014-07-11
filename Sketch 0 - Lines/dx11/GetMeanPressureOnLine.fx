#include "Noise.fxh"
RWStructuredBuffer<float> Output : BACKBUFFER;
float4x4 tWorldInverse : WORLDINVERSE;

struct Line {
	float3 Start;
	float3 End;
};

StructuredBuffer<Line> Lines <String uiname="Line StartEnd";>;
#define FIELD_BUFFER_READONLY
#include "FieldStruct.fxh"

[numthreads(4, 1, 1)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	int threadIndex = threadID.x;
	Line thisLine = Lines[threadIndex];
	
	int iterations = 10;
	
	float4 start;
	start.xyz = thisLine.Start;
	start.w = 1.0f;
	start = mul(start, tWorldInverse);
	
	Output[threadIndex] = getPressureAtObject(start.xyz);
	return;
	
	float4 end;
	end.xyz = thisLine.End;
	end.w = 1.0f;
	end = mul(end, tWorldInverse);
	
	float3 lineStep = (end.xyz - start.xyz) / iterations;
	float3 xyz = start.xyz;
	
	float maxPressure = 0.0f;
	
	for(int i=0; i<iterations; i++) {
		maxPressure = max(maxPressure, getElementAtObject(xyz).Pressure);
		xyz += lineStep;
		Output[threadIndex] = xyz.x;
	}
	Output[threadIndex] = maxPressure; //totalPressure / (float) iterations;
}
 
technique11 Main
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}