varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_vVSPosition;

#define GBUFF_DIFFUSE 0
#define GBUFF_VS_POSITION 1
#define GBUFF_MATERIAL 2

uniform float u_MaterialType;

uniform sampler2D samp_DisplacementMap;
uniform vec2 u_Time;

void main() {
    vec4 displace = texture2D(samp_DisplacementMap, v_vTexcoord + u_Time);
    vec2 offset = (displace.rg - 0.5) / 10.0;
    
    gl_FragData[GBUFF_DIFFUSE] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + offset);
    gl_FragData[GBUFF_VS_POSITION] = vec4(v_vVSPosition, 1);
    gl_FragData[GBUFF_MATERIAL] = vec4(u_MaterialType, 0, 0, 1);
    
    if (gl_FragData[GBUFF_DIFFUSE].a < 0.9) {
        discard;
    }
}