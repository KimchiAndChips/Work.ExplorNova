float4x4 Transform : WORLDINVERSE;
float4x4 tTextureToObject <String uiname="Transform Texture To Object";>;
float4x4 tObjectToTexture <String uiname="Transform Object To Texture";>;

class FieldElement {
	void clear() {
		this.NextPressure = 0.0f;
		this.Pressure = 0.0f;
		this.PreviousPressure = 0.0f;
		this.Velocity = (float3) 0.0f;
	}

	float NextPressure;
	float Pressure;
	float PreviousPressure;
	float3 Velocity;
};

FieldElement makeBlankElement() {
	FieldElement element;
	element.clear();
	return element;
}

#ifdef FIELD_BUFFER_READONLY
StructuredBuffer<FieldElement> Field;
#else
RWStructuredBuffer<FieldElement> Field : BACKBUFFER;
#endif
int3 TextureSize <String uiname="Texture Size";>;

uint getElementIndex(uint3 textureIndex) {
	return textureIndex.x + 
	textureIndex.y * TextureSize.x + 
	textureIndex.z * TextureSize.x * TextureSize.y;
}

FieldElement getElement(uint3 textureIndex) {
	return Field[getElementIndex(textureIndex)];
}

float4 getObjectCoord(uint3 threadIndex) {
	uint3 outputCoordinate = uint3(threadIndex.x, threadIndex.y, threadIndex.z);
	float4 textureCoord;
	textureCoord.xyz = (float3) outputCoordinate / (float3) TextureSize;
	textureCoord.w = 1.0f;
	
	float4 objectCoord = mul(textureCoord, mul(tTextureToObject, Transform));
	objectCoord /= objectCoord.w;
	
	return objectCoord;	
}

FieldElement getElementAtObject(float3 objectCoord) {
	float4 xyzw;
	xyzw.xyz = objectCoord;
	xyzw.w = 1.0f;
	
	float4 textureCoord = mul(xyzw, tObjectToTexture);
	textureCoord /= textureCoord.w;
	
	return Field[getElementIndex(textureCoord.xyz)];
}

float getPressureAtObject(float3 objectCoord) {
	float4 object;
	object.xyz = objectCoord;
	object.w = 1.0f;
	
	float4 textureCoords = mul(object, tObjectToTexture);
	textureCoords /= textureCoords.w;
	
	uint3 fieldCoords = textureCoords.xyz * (float3) TextureSize;
	return getElement(fieldCoords).Pressure;
}