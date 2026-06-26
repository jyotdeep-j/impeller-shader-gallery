#version 460 core
#include <flutter/runtime_effect.glsl>

// Interactive ripple — concentric waves emanate from the touch / pointer
// position passed in from Dart via the uPointer uniform.

uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uPointer;

out vec4 fragColor;

vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (vec3(1.0) * t + vec3(0.0, 0.33, 0.67)));
}

void main() {
    vec2 uv = (FlutterFragCoord().xy * 2.0 - uResolution) / uResolution.y;
    vec2 ptr = (uPointer * 2.0 - uResolution) / uResolution.y;

    float d = length(uv - ptr);

    // Decaying sine ring that travels outward from the pointer.
    float ripple = sin(d * 18.0 - uTime * 4.0) * exp(-d * 2.2);

    vec3 col = palette(d * 0.5 + uTime * 0.08);
    col *= 0.55 + 0.7 * ripple;

    fragColor = vec4(col, 1.0);
}
