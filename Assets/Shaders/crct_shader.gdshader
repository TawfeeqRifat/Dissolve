//---CRT Shader---
shader_type canvas_item;

uniform float scanline_count : hint_range(0, 1800) = 200.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.5;
	
	//You can modify the numbers and try different values
	uv.x *= 1.0 + pow(abs(uv.y) / 3.0, 5.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 3.0, 5.0);
	
	//The scale part (you can delete it when you want)
	uv /= 1.2;
	
	uv = (uv/2.0) + 0.5;
	return uv;
}


void fragment()
{	
	//float PI = 3.14159;
	
	//You can modify the *3.0, *-3.0 for a bigger or smaller 
	
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) ).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) ).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) ).b;
	
	
	//If you dont want scanlines you can just delete this part
	float s = sin(uv_curve(SCREEN_UV).y * scanline_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	
	
	COLOR = vec4(r, g, b, 1.0) * scan_line;
}
