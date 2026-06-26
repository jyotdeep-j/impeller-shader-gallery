#version 460 core
#include <flutter/runtime_effect.glsl>

// Retro analog "plasma" effect built from summed sine waves.

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 p = uv * 6.0 - 3.0;
    float t = uTime;

    float v = 0.0;
    v += sin(p.x + t);
    v += sin((p.y + t) * 0.5);
    v += sin((p.x + p.y + t) * 0.5);

    // A moving radial source keeps the field from looking too regular.
    vec2 c = p + 3.0 * vec2(sin(t * 0.31), cos(t * 0.22));
    v += sin(sqrt(c.x * c.x + c.y * c.y + 1.0) + t);
    v *= 0.5;

    vec3 col = vec3(
        sin(v * 3.14159),
        sin(v * 3.14159 + 2.094),
        sin(v * 3.14159 + 4.188)
    );

    fragColor = vec4(col * 0.5 + 0.5, 1.0);
}
