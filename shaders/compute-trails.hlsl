Texture2D<float4> trailMap : register(t0);
RWTexture2D<float4> diffusedTrailMap : register(u0);

[numthreads(32,32,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x < 0 || tid.x >= !WIDTH || tid.y < 0 || tid.y >= !HEIGHT) return;

	float4 sum = 0;

	for (int x = -1; x <= 1; x++)
		for (int y = -1; y <= 1; y++)
			sum += trailMap[uint2(min(!WIDTH-1, max(0, tid.x + x)), min(!HEIGHT-1, max(0, tid.y + y))).xy];

	float4 blurredCol = trailMap[tid.xy] * (1 - !BLUR_RATE) + (sum / 9) * (!BLUR_RATE);
	diffusedTrailMap[tid.xy] = max(0, blurredCol - !DECAY_RATE);
}