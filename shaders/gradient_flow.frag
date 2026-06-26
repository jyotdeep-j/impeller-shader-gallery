#version 460 core
#include <flutter/runtime_effect.glsl>

// Flowing fractal mesh-gradient.
// Inspired by the classic "palette + domain repeat" technique.

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

// Cosine palette (Inigo Quilez). Cheap, smooth, infinite gradients.
vec3 palette(float t) {
    vec3 a = vec3(0.5);
    vec3 b = vec3(0.5);
    vec3 c = vec3(1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    // Centre the coordinate space and keep the aspect ratio square.
    vec2 uv = (FlutterFragCoord().xy * 2.0 - uResolution) / uResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5) - 0.5;

        float d = length(uv) * exp(-length(uv0));
        vec3 col = palette(length(uv0) + i * 0.4 + uTime * 0.4);

        d = sin(d * 8.0 + uTime) / 8.0;
        d = abs(d);
        d = pow(0.012 / d, 1.3);

        finalColor += col * d;
    }

    fragColor = vec4(finalColor, 1.0);
}
