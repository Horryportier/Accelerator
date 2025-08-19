#version 330 core

layout(location = 0) in vec2 xyPos;
layout(location = 1) in vec2 aTexCoords;
out vec2 TexCoords;

uniform mat4 transform;

void main() {
    vec4 xy_copy = transform * vec4(xyPos, 1, 1);
    //xy_copy.z = 1.0;
    gl_Position = xy_copy;
    TexCoords = aTexCoords;
}
