#version 330
#define VSH

#moj_import <light.glsl>
#moj_import <utils.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform float GameTime;

out vec4 vertexColor;
out vec4 baseColor;
out vec2 texCoord;
out vec2 texCoord2;
out vec3 normal;
out vec4 glpos;

out vec3 Pos;
out float transition;

flat out int isCustom;
flat out int noshadow;

#moj_import <objmc.tools>

void main() {
    vec3 Pos = Position + ChunkOffset;
    texCoord = UV0;

    int alpha255 = int(textureLod(Sampler0, UV0, -4).a * 255.0);
    if (alpha255 == WAVINGS || alpha255 == WAVINGT) {
        Pos.x += 0.05 * sin(sin(GameTime * 100 * PI) * 8.0 + mod(Position.x, 16.0) + Position.y);
        Pos.z += 0.05 * sin(sin(GameTime * 60 * PI) * 6.0 + 978.0 + mod(Position.z, 16.0) + Position.y);
    }

    //objmc
    #define BLOCK
    #moj_import <objmc.main>

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);

    vec4 col = Color;
    float up = 255.0;
    float down = 127.0;
    if (getDim(Sampler2) == DIM_NETHER) {
        up = 229.0;
        down = 229.0;
    }
    if (dot(Normal, vec3(0.0, -1.0, 0.0)) > 0.999) {
        col *= 255.0 / down;
    }
    else if (dot(Normal, vec3(0.0, 1.0, 0.0)) > 0.999) {
        col *= 255.0 / up;
    }
    else if (abs(dot(Normal, vec3(1.0, 0.0, 0.0))) > 0.999) {
        col *= 255.0 / 153.0;
    }
    else if (abs(dot(Normal, vec3(0.0, 0.0, 1.0))) > 0.999) {
        col *= 255.0 / 204.0;
    }
    else if (col.r == col.g && col.g == col.b){
        col = vec4(1.0);
    }
    col = min(col, 1.0);

    baseColor = col;
    vertexColor = minecraft_sample_lightmap(Sampler2, UV2);
    texCoord2 = UV2 / 255.0;
    texCoord2.x *= 1.0 - getSun(Sampler2);
    normal = Normal;
    glpos = gl_Position;
}
