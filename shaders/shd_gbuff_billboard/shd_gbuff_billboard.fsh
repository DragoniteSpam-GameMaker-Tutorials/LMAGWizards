varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_vVSPosition;

#define GBUFF_DIFFUSE 0
#define GBUFF_VS_POSITION 1
#define GBUFF_MATERIAL 2

uniform float u_MaterialType;

void main() {
    gl_FragData[GBUFF_DIFFUSE] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[GBUFF_VS_POSITION] = vec4(v_vVSPosition, 1);
    gl_FragData[GBUFF_MATERIAL] = vec4(u_MaterialType, 0, 0, 1);
    
    if (gl_FragData[GBUFF_DIFFUSE].a < 0.9) {
        discard;
    }
}
