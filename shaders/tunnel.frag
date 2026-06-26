#version 460 core
#include <flutter/runtime_effect.glsl>

// Infinite polar tunnel — angle drives stripes, inverse-radius drives depth.

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (vec3(1.0) * t + vec3(0.0, 0.10, 0.20)));
}

void main() {
    vec2 uv = (FlutterFragCoord().xy * 2.0 - uResolution) / uResolution.y;

    float a = atan(uv.y, uv.x);
    float r = length(uv);

    // 1/r maps the centre to "infinitely far away" -> classic tunnel depth.
    float v = 0.3 / r + uTime * 0.6;

    float stripes = sin(a * 8.0 + v * 4.0);
    float rings = sin(v * 8.0);

    vec3 col = palette(v * 0.1 + a / 6.28318);
    col *= 0.5 + 0.5 * stripes * rings;
    col *= smoothstep(0.0, 0.45, r); // fade the singularity at the centre

    fragColor = vec4(col, 1.0);
}
