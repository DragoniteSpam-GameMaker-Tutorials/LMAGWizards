/*/
	This is a shader made for use with the sPart system.
	
	Sindre Hauge Larsen, 2019
	www.TheSnidr.com
/*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_vVSPosition;

uniform float u_PtAlphaTestRef;

uniform float u_MaterialType;

void main()
{
	vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
	if (baseCol.a < u_PtAlphaTestRef){discard;}
    gl_FragData[0] = v_vColour * baseCol;
    gl_FragData[1] = vec4(v_vVSPosition, 1);
    gl_FragData[2] = vec4(u_MaterialType, 0, 0, 1);
}