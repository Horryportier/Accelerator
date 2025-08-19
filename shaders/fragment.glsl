#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoord;
uniform float brighteness = 1.0;
uniform sampler2D ourTexture;

void main() {
    //(vec4(ourColor, 1.0) * brighteness) *
    FragColor = texture(ourTexture, TexCoord);
}
