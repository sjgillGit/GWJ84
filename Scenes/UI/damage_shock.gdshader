shader_type canvas_item;

/**
Color to use for the shock.
*/
/**
Initial amplitude of the shock. This will start at this amplitude and
gradually attenuate.
*/
uniform float amplitude = 30.0;
/**
How fast shold it move side to side, more frequency means it'll move more quickly
side to side.
*/
uniform float frequecy = 10.0;

void vertex() {
	float exponent = mod(TIME, 1.0);
	VERTEX.x += amplitude * exp(-1.0*exponent) * sin(frequecy*exponent);
}

void fragment() {
	float exponent = mod(TIME, 1);
	vec3 normal_color = texture(TEXTURE, UV).rgb;
}