shader_type canvas_item;

uniform vec4 inside_color: source_color;
uniform vec4 back_color: source_color;
uniform float width: hint_range(0.0, 1.0);

void fragment() {
	//if(UV.x > width && UV.y > width && UV.x < (1.0 - width) && UV.y < (1.0 - width)){
		//COLOR = inside_color;
	//}
	//else{
		//COLOR = back_color;
	//}
}