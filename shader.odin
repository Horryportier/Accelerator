package accelerator

import gl "vendor:OpenGL"

import "core:os"

ShaderError :: enum {
	INVALID_FILE_PATHS,
	SHADER_FAILED_COMPILATION,
	FAILED_TO_READ_FILE,
}

Shader :: distinct u32

load_shader :: proc(vertex, fragment: string) -> AccelResult(Shader, ShaderError) {
	if !os.exists(vertex) || !os.exists(fragment) {
		return .INVALID_FILE_PATHS
	}
	ok: bool
	v_file, f_file: []byte
	v_file, ok = os.read_entire_file_from_filename(vertex)
	if !ok {
		return .FAILED_TO_READ_FILE
	}
	f_file, ok = os.read_entire_file_from_filename(vertex)
	if !ok {
		return .FAILED_TO_READ_FILE
	}
	if program, ok := gl.load_shaders_source(string(v_file), string(f_file)); ok {
		return cast(Shader)program
	}
	return .SHADER_FAILED_COMPILATION
}
