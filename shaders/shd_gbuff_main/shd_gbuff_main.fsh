varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_vVSPosition;

uniform float u_CameraZFar;

vec3 GetVSNormal(vec3 vs_position) {
    vec3 dx = dFdx(vs_position);
    vec3 dy = dFdy(vs_position);
    return normalize(cross(dx, dy));
}

float GetVSDepth(vec3 vs_position) {
    return vs_position.z;
}

vec3 GetNormalAsColor(vec3 norm) {
    return norm * 0.5 + 0.5;
}

const float DEPTH_SCALE_FACTOR = 16777215.0;
vec3 GetDepthAsColor(float depth) {
    float normalized_depth = abs(depth / u_CameraZFar);
    float long_depth = normalized_depth * DEPTH_SCALE_FACTOR;
    vec3 depth_as_color = vec3(mod(long_depth, 256.0), mod(long_depth / 256.0, 256.0), long_depth / 65536.0);
    depth_as_color = floor(depth_as_color);
    depth_as_color /= 255.0;
    return depth_as_color;
}

void main() {
    gl_FragData[0] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[1] = vec4(GetNormalAsColor(GetVSNormal(v_vVSPosition)), 1);
    gl_FragData[2] = vec4(GetDepthAsColor(GetVSDepth(v_vVSPosition)), 1);
}
