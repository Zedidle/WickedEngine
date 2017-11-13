#include "globals.hlsli"
#include "emittedparticleHF.hlsli"
#include "depthConvertHF.hlsli"

float4 main(VertextoPixel input) : SV_TARGET
{
	float4 color = texture_0.Sample(sampler_linear_clamp,input.tex);
	clip(color.a - 1.0f / 255.0f);

	float2 pTex = input.pos2D.xy / input.pos2D.w * float2(0.5f, -0.5f) + 0.5f;
	float4 depthScene = (texture_lineardepth.GatherRed(sampler_linear_clamp, pTex));
	float depthFragment = input.pos2D.w;
	float fade = saturate(1.0 / input.size*(max(max(depthScene.x, depthScene.y), max(depthScene.z, depthScene.w)) - depthFragment));

	float4 inputColor;
	inputColor.r = ((input.color >> 0)  & 0x000000FF) / 255.0f;
	inputColor.g = ((input.color >> 8)  & 0x000000FF) / 255.0f;
	inputColor.b = ((input.color >> 16) & 0x000000FF) / 255.0f;
	inputColor.a = ((input.color >> 24) & 0x000000FF) / 255.0f;

	color.rgb *= inputColor.rgb;
	color.a = saturate(color.a * inputColor.a * fade);

	return max(color, 0);
}
