#version 120

uniform sampler2D DiffuseSampler;
uniform sampler2D ExposureSampler;

varying vec2 texCoord;

float luminance(vec3 rgb) {
    return max(max(rgb.r, rgb.g), rgb.b);
}

void main() {
    vec3 color = texture2D(DiffuseSampler, texCoord).rgb;
    float elast = texture2D(ExposureSampler, texCoord).r;
    float enew = luminance(color);

    gl_FragColor = vec4(vec3(mix(elast, enew, 0.01)), 1.0);
}
