package main


import gl "vendor:OpenGL"

import "core:math/linalg"


ShaderID :: u32

Material :: struct {
	shader_id: ShaderID,
	uniforms:  gl.Uniforms,
}


ShaderUniformType :: union {
	int,
	f32,
	bool,
}

new_material :: proc(shader: ShaderID) -> Material {
	new := Material {
		shader_id = shader,
	}
	new.uniforms = gl.get_uniforms_from_program(shader)
	return new
}

delete_material :: proc(mat: ^Material) {
	gl.destroy_uniforms(mat^.uniforms)
}

set_uniform :: proc(mat: Material, uniform: string, value: ShaderUniformType) {
	if u_data, ok := mat.uniforms[uniform]; ok {
	}
}

load_shader :: proc(vertex, fragment: string) -> Maybe(ShaderID) {
	if program, ok := gl.load_shaders_file(vertex, fragment); ok {
		return program
	}
	return nil
}
