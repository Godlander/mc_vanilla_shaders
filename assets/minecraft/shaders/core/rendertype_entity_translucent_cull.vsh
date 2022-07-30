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
uniform mat3 IViewRotMat;
uniform float GameTime;

uniform float FogStart;
uniform int FogShape;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 baseColor;
out vec2 texCoord2;
out vec4 glpos;

out vec2 texCoord;
out vec3 Pos;
out float transition;
out vec4 overlayColor;
flat out int isCustom;
flat out int igui;
flat out int ihand;
flat out int noshadow;

#moj_import <objmc.tools>

void main() {
    Pos = Position;
    texCoord = UV0;
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);

    //objmc
    #define ENTITY
    #moj_import <objmc.main>

    baseColor = vec4(1);
    if (isGUI(ProjMat)) {
        if (isCustom == 0) baseColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0);
    }
    else {
        if (isCustom == 0) baseColor = Color;
        vertexColor = minecraft_sample_lightmap(Sampler2, UV2);
    }

    gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
    texCoord2 = UV2 / 255.0;
    texCoord2.x *= 1.0 - getSun(Sampler2);
    glpos = gl_Position;
}
