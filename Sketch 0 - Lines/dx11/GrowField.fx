cbuffer cColor : register(b0)
{
	float3 size : TARGETSIZE;
}

RWTexture3D<float> Field : BACKBUFFER;

float Attack = 0.1f;

[numthreads(4, 4, 4)]
void main(uint3 threadID : SV_DispatchThreadID )
{
	int windowRadius = 1;
	for(int i=-windowRadius; i<=windowRadius; i++) {
		for(int j=-windowRadius; j<=windowRadius; j++) {
			for(int k=-windowRadius; k<=windowRadius; k++) {
				if (i == 0 && j == 0 && k == 0) {
					continue;
				}
				uint3 otherIndex = threadID + uint3(i, j, k);
				if (any(otherIndex < 0) || any(otherIndex >= (uint3) size)) {
					continue;
				}
				Field[threadID] += Field[otherIndex] * Attack;
			}
		}
	}
	Field[threadID] = saturate(Field[threadID]);
}

technique11 GrowField
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, main() ) );
	}
}
