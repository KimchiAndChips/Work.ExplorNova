//@author: elliotwoods
//@help: lookup lines in volume
//@tags: Lines
//@credits: 

Texture3D volumeTexture <string uiname="Texture";>;

SamplerState linearSampler : IMMUTABLE
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};
 
cbuffer cbPerDraw : register( b0 )
{
	float4x4 tVP : VIEWPROJECTION;
	float4x4 tWorldToTexture <String uiname="Transform World To Texture";>;
};

cbuffer cbPerObj : register( b1 )
{
	float4x4 tW : WORLD;
};

struct VS_IN
{
	float4 PosO : POSITION;
	float4 TexCd : TEXCOORD0;

};

struct vs2ps
{
    float4 PosWVP: SV_POSITION;
    float4 TexCd: TEXCOORD0;
	float4 PosTexture : TEXCOORD1;
};

vs2ps VS(VS_IN input)
{
    vs2ps output;
    output.PosWVP  = mul(input.PosO,mul(tW,tVP));
    output.TexCd = input.TexCd;
	output.PosTexture = mul(input.PosO,mul(tW, tWorldToTexture));
    return output;
}




float4 PS(vs2ps input): SV_Target
{
    float4 col = volumeTexture.Sample(linearSampler, input.PosTexture.xyz);
    return col;
}





technique10 Constant
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}




