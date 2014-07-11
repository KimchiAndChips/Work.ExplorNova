#include "Noise.fxh"
#include "FieldStruct.fxh"

float3 Position;
float Radius;

float Pressure;
bool Set;

[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	if (Set && all(length(getObjectCoord(threadID).xyz - Position) < Radius)) {
		FieldElement element = Field[getElementIndex(threadID)];
		element.Pressure = Pressure;
		Field[getElementIndex(threadID)] = element;
	}
}
 
technique11 SetSubVolume
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}