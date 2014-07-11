#include "Noise.fxh"
#include "FieldStruct.fxh"

float Threshold = 0.5f;

[numthreads(4, 4, 4)]
void mainGreaterThan(uint3 threadID : SV_DispatchThreadID )
{
	FieldElement element = Field[getElementIndex(threadID)];
	element.Pressure = element.Pressure > Threshold;
	Field[getElementIndex(threadID)] = element;
}
 
technique11 GreaterThan
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainGreaterThan() ) );
	}
}