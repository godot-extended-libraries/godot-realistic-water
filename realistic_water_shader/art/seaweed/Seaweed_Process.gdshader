shader_type particles;

uniform float 	map_size = 128.0;

uniform sampler2D height_sampler : hint_default_black;
uniform float 	height_scale	 = 1.0;
uniform float 	height_offset	 = 0.0;

uniform sampler2D noise_sampler_A;
uniform sampler2D noise_sampler_B;

uniform float 	rows			 = 4;
uniform float 	spacing			 = 1.5;


float height(vec2 position)
{
	position /= map_size;
	position += 0.5;
	
	return texture(height_sampler, position).r * height_scale + height_offset * 0.5;
}


void process()
{	

	vec3 pos = vec3(0.0);
	
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	pos *= spacing;
	
	pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], spacing);
	pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], spacing);
	
	vec3 noise_A = texture(noise_sampler_A, pos.xz * 0.01).rgb;
	
	pos.x += noise_A.x * spacing;
	pos.z += noise_A.y * spacing;
	
	
	pos.y = height(pos.xz);
	if (pos.y > -1.8) { pos.y = -10000.0; }

	float noise_B = texture(noise_sampler_B, pos.xz * 0.01).r;
	if (noise_B < 0.5) { pos.y = -10000.0; }
	
	
	TRANSFORM[0][0] = cos(noise_A.z * 3.0);
	TRANSFORM[0][2] = -sin(noise_A.z * 3.0);
	TRANSFORM[2][0] = sin(noise_A.z * 3.0);
	TRANSFORM[2][2] = cos(noise_A.z * 3.0);
	
	TRANSFORM[3][0] = pos.x;
	TRANSFORM[3][1] = pos.y;
	TRANSFORM[3][2] = pos.z;

}