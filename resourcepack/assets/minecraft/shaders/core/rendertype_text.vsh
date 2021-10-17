#version 150

#moj_import <light.glsl>
#moj_import <utils_vsh.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 glpos;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    if (isGUI(ProjMat)) {
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    } else {
        vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    }
    texCoord0 = UV0;
    glpos = gl_Position;
}
