varying vec2 v_vTexcoord;

uniform sampler2D samp_Depth;

vec3 GetVSNormal(vec3 vs_position) {
    vec3 dx = dFdx(vs_position);
    vec3 dy = dFdy(vs_position);
    return normalize(cross(dx, dy));
}

void CommonLightAndFog(inout vec4 baseColor, in vec3 frag_normal, in vec3 frag_position);

void main() {
    vec4 col_diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 col_position = texture2D(samp_Depth, v_vTexcoord);
    
    vec4 final_color = col_diffuse;
    
    vec3 fragment_normal = GetVSNormal(col_position.xyz);
    
    CommonLightAndFog(final_color, fragment_normal, col_position.xyz);
    
    gl_FragColor = final_color;
}






#define MAX_LIGHTS 16
#define LIGHT_DIRECTIONAL 1.0
#define LIGHT_POINT 2.0
#define LIGHT_SPOT 3.0
#define LIGHT_TYPES 16.0
#define PI 3.141592653

uniform int u_LightCount;
uniform vec3 u_LightAmbientColor;
uniform vec4 u_LightDataPrimary[MAX_LIGHTS];
uniform vec4 u_LightDataSecondary[MAX_LIGHTS];
uniform vec4 u_LightDataTertiary[MAX_LIGHTS];
uniform float u_FogStrength;
uniform float u_FogStart;
uniform float u_FogEnd;
uniform vec3 u_FogColor;

void CommonLightAndFog(inout vec4 baseColor, in vec3 frag_normal, in vec3 frag_position) {
    vec3 finalColor = u_LightAmbientColor;
    
    for (int i = 0; i < MAX_LIGHTS; i++) {
        vec3 lightPosition = u_LightDataPrimary[i].xyz;
        float type = mod(u_LightDataPrimary[i].w, LIGHT_TYPES);
        vec4 lightExt = u_LightDataSecondary[i];
        vec4 lightColor = u_LightDataTertiary[i];
        
        if (type == LIGHT_DIRECTIONAL) {
            // directional light: [dx, dy, dz, type], [0, 0, 0, 0], [r, g, b, 0]
            float NdotL = clamp(dot(frag_normal, lightPosition), 0.0, 1.0);
            finalColor += lightColor.rgb * NdotL;
        } else if (type == LIGHT_POINT) {
            // point light: [x, y, z, type], [0, 0, range_inner, range_outer], [r, g, b, 0]
            float rangeInner = lightExt.z;
            float rangeOuter = lightExt.w;
            vec3 lightIncoming = frag_position - lightPosition;
            float dist = length(lightIncoming);
            lightIncoming = normalize(-lightIncoming);
            float att = (rangeOuter - dist) / max(rangeOuter - rangeInner, 0.000001);
            
            float NdotL = clamp(dot(frag_normal, lightIncoming), 0.0, 1.0);
            
            finalColor += clamp(att * lightColor.rgb * NdotL, 0.0, 1.0);
        } else if (type == LIGHT_SPOT) {
            // spot light: [x, y, z, type | cutoff_inner], [dx, dy, dz, range], [r, g, b, cutoff_outer]
            vec3 sourceDir = lightExt.xyz;
            float range = lightExt.w;
            float cutoff = lightColor.w;
            float innerCutoff = ((u_LightDataPrimary[i].w - type) / LIGHT_TYPES) / 128.0;
            
            vec3 lightIncoming = frag_position - lightPosition;
            float dist = length(lightIncoming);
            lightIncoming = -normalize(lightIncoming);
            float NdotL = max(dot(frag_normal, lightIncoming), 0.0);
            float lightAngleDifference = max(dot(lightIncoming, sourceDir), 0.0);
            
            float f = clamp((lightAngleDifference - cutoff) / max(innerCutoff - cutoff, 0.000001), 0.0, 1.0);
            float att = f * max((range - dist) / range, 0.0);
            
            finalColor += clamp(att * lightColor.rgb * NdotL, 0.0, 1.0);
        }
    }
    
    baseColor.rgb *= clamp(finalColor, vec3(0), vec3(1));
    
    float f = clamp((frag_position.z - u_FogStart) / (u_FogEnd - u_FogStart), 0., 1.);
    baseColor.rgb = mix(baseColor.rgb, u_FogColor, f * u_FogStrength);
}