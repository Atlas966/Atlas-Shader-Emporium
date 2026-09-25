float4 GaussianBlurASE_float(Texture2D Texture, float2 UV, float Blur, float Quality, float Directions, SamplerState Sampler, out float TextureAlpha)
{
	const float Pi = 6.28318530718;
	
	// 1. Grab the initial base pixel sample
	float4 tex = Texture.Sample(Sampler, UV);
	float4 col = tex;
	
	// 2. Track how many total samples are added to the loop
	float sampleCount = 1.0; 

	float x; float y;
	Texture.GetDimensions(x, y);
	float2 texels = float2(x, y);
	
	// 3. Fix Texel Size Mapping: Blur should scale inversely to the texture resolution
	float2 radius = Blur / texels;

	// Loop through angles
	for(float d = 0.0; d < Pi; d += Pi / Directions)
	{
		// Loop through quality steps
		for(float i = 1.0 / Quality; i <= 1.0; i += 1.0 / Quality)
		{
			col += Texture.Sample(Sampler, UV + float2(cos(d), sin(d)) * radius * i);		
			sampleCount += 1.0; // Increment for every loop sample taken
		}
	}
	
	// 4. Clean Normalization: Divide by the exact number of accumulated pixels
	col /= sampleCount;
	
	TextureAlpha = tex.a;
	return col;
}
