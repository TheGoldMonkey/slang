//TEST:SIMPLE:-target wgsl

// Regression test for issue #8184
// Test that accessing static const interface fields through generic type parameters
// does not crash the compiler.

interface Transformation
{
    float3 apply(float3 coord);
    static const uint32_t kParamCount;
}

struct T1 : Transformation {
    float3 apply(float3 coord) { return float3(0, 0, 0); }
    static const uint32_t kParamCount = 2;
};

[shader("compute")]
[numthreads(1, 1, 1)]
void XYPass<T>()
where T : Transformation
{
    // This used to crash with "Generic type/value shouldn't be handled here!"
    static const uint32_t kParamCount = T::kParamCount;
}