cbuffer cColor : register(b0)
{
	float3 size : TARGETSIZE;
}

RWTexture3D<float> Field : BACKBUFFER;
float Threshold = 0.5f;

[numthreads(4, 4, 4)]
void mainGreaterThan(uint3 threadID : SV_DispatchThreadID )
{
	Field[threadID] = Field[threadID] > Threshold;
}

[numthreads(4, 4, 4)]
void mainLessThan(uint3 threadID : SV_DispatchThreadID )
{
	Field[threadID] = Field[threadID] < Threshold;
}

technique11 GreaterThan
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainGreaterThan() ) );
	}
}

technique11 LessThan
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, mainLessThan() ) );
	}
}