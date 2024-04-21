shader_type spatial;

uniform vec4 zone_color : source_color;

void fragment( )
{
	ALBEDO = zone_color.rgb;
	ALPHA = sin(TIME) + VERTEX.y;
}