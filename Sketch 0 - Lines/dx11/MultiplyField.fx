#include "Noise.fxh"
#include "FieldStruct.fxh"

float Factor = 1.0f;

[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	Field[getElementIndex(threadID)].Pressure = Field[getElementIndex(threadID)].Pressure * Factor;
}
 
technique11 Wave
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}