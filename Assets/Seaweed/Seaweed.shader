shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;


uniform sampler2D albedo_sampler : hint_albedo;
uniform sampler2D roughness_sampler : hint_white;
uniform sampler2D normal_sampler : hint_normal;

uniform float	scale			= 1.0;

uniform float	wind_speed		= 0.5;
uniform float	wind_strength	= 0.3;
uniform vec2	wind_direction	= vec2(0.6 , 0.0);


void vertex()
{
	vec4	vertex			 = vec4(VERTEX * scale, 1.0);
	vec3	vertex_world	 = (WORLD_MATRIX * vertex).xyz;
	
	vec2	wind_flow		 = wind_direction * TIME * wind_speed;
	
	float	wind 		 	 = ((cos(vertex.x + wind_flow.x)+cos(vertex.z + wind_flow.y)) * 0.25) * wind_strength;

	float 	f 				 = dot(wind_direction, vertex.xz);

			vertex.x 		 += wind_direction.x * wind * (vertex.y) * cos(f);
			vertex.z 		 += wind_direction.y * wind * (vertex.y) * cos(f);

			VERTEX			 = vertex.xyz;
}


void fragment()
{
	vec2 	base_uv			 = UV;
	vec4 	albedo_tex		 = texture(albedo_sampler, base_uv);

	if (albedo_tex.a < 0.6) { discard;}
	
	ALBEDO = albedo_tex.rgb;
	METALLIC = 0.2;
	ROUGHNESS = 0.5+texture(roughness_sampler, base_uv).r*0.4;
	SPECULAR = 0.5;
	NORMALMAP = texture(normal_sampler, base_uv).rgb;
	NORMALMAP_DEPTH = 0.75;
	TRANSMISSION = vec3(0.8);
}
