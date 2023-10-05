varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_vVSPosition;

#define GBUFF_DIFFUSE 0
#define GBUFF_VS_POSITION 1
#define GBUFF_MATERIAL 2
#define GBUFF_NORMAL 3

uniform float u_MaterialType;

vec3 ToNormalColor(vec3 normal) {
    return normal * 0.5 + 0.5;
}

void main() {
    vec3 dx = dFdx(v_vVSPosition);
    vec3 dy = dFdy(v_vVSPosition);
    vec3 world_normal = normalize(cross(dx, dy));
    
    gl_FragData[GBUFF_DIFFUSE] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[GBUFF_VS_POSITION] = vec4(v_vVSPosition, 1);
    gl_FragData[GBUFF_MATERIAL] = vec4(u_MaterialType, 0, 0, 1);
    gl_FragData[GBUFF_NORMAL] = vec4(ToNormalColor(world_normal), 1);
}
