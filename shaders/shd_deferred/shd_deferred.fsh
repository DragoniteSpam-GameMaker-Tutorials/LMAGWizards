varying vec2 v_vTexcoord;

uniform sampler2D samp_Normal;
uniform sampler2D samp_Depth;

uniform float u_CameraZFar;

vec3 GetNormalFromColor(vec3 color) {
    return (color - 0.5) * 2.0;
}

const vec3 UNDO = vec3(1.0, 256.0, 65536.0) / 16777215.0 * 255.0;
float GetDepthFromColorLinear(vec3 color) {
    return dot(color, UNDO) * u_CameraZFar;
}

uniform vec2 u_FOVScale;

vec3 GetPositionFromDepthVS(float depth) {
    vec2 ndc_position = 2.0 * (0.5 - v_vTexcoord);
    vec3 view_space_position = vec3(ndc_position * depth * u_FOVScale, depth);
    return view_space_position;
}

void main() {
    vec4 col_diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 col_normal = texture2D(samp_Normal, v_vTexcoord);
    vec4 col_depth = texture2D(samp_Depth, v_vTexcoord);
    
    vec4 final_color = col_diffuse;
    
    vec3 fragment_normal = GetNormalFromColor(col_normal.rgb);
    float fragment_depth = GetDepthFromColorLinear(col_depth.rgb);
    vec3 fragment_position = GetPositionFromDepthVS(fragment_depth);
    
    gl_FragColor = mix(final_color
}
