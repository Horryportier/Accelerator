package accelerator


import "base:runtime"
import "core:c"

import gl "vendor:OpenGL"
import "vendor:glfw"

GL_MAJOR_VERSION: c.int : 4
GL_MINOR_VERSION :: 6

AcceleratorError :: enum {
	OK,
	FailedToCreateWindow,
	WindowHandleArledyExists,
}

AccelResult :: union($T: typeid) {
	T,
	AcceleratorError,
}

Window :: struct {
	width, hegiht: c.int,
	title:         cstring,
}

VAO :: u32
VBO :: u32

ShaderProgram :: u32

RenderData :: struct {
	vertices: [dynamic]f32,
	vao:      VAO,
	vbo:      VBO,
	shader:   ShaderProgram,
}


CustomKeyCallback :: proc(key, scancode, action, mods: c.int)
custom_key_callback: CustomKeyCallback = proc(key, scancode, action, mods: c.int) {}

window: glfw.WindowHandle
running: bool = true

render_data: RenderData


init_window :: proc(using window_settings: Window) -> AcceleratorError {
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	if glfw.Init() != true {
		log("failed to initialize glfw")
		return .FailedToCreateWindow
	}
	window = glfw.CreateWindow(width, hegiht, title, nil, nil)
	if window == nil {
		destroy_window()
		return .FailedToCreateWindow
	}
	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)
	glfw.SetKeyCallback(window, key_callback)
	glfw.SetErrorCallback(error_callback)
	glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)
	gl.load_up_to(int(GL_MAJOR_VERSION), int(GL_MINOR_VERSION), glfw.gl_set_proc_address)
	render_data = {}
	return .OK
}

add_vertice :: proc(v: Vec3) {
	append(&render_data.vertices, v.x)
	append(&render_data.vertices, v.y)
	append(&render_data.vertices, v.z)
}


setup_vertex_data :: proc(vertices_data: []Vec3) {
	gl.GenBuffers(1, &render_data.vbo)
	gl.BindBuffer(gl.ARRAY_BUFFER, render_data.vbo)
	for v in vertices_data {
		add_vertice(v)
	}
	gl.BufferData(
		gl.ARRAY_BUFFER,
		len(render_data.vertices),
		&render_data.vertices,
		gl.STATIC_DRAW,
	)

	vertext_shader_data := cstring(#load("shaders/vertex.glsl"))
	vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
	gl.ShaderSource(vertex_shader, 1, &vertext_shader_data, nil)
	gl.CompileShader(vertex_shader)
}

clear_screen :: proc(color: Color) {
	gl.ClearColor(color.r, color.g, color.b, color.a)
	gl.Clear(gl.COLOR_BUFFER_BIT)
}

framebuffer_size_callback :: proc "c" (handle: glfw.WindowHandle, width, height: c.int) {
	gl.Viewport(0, 0, width, height)
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: c.int) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}
	context = runtime.default_context()
	custom_key_callback(key, scancode, action, mods)
}

error_callback :: proc "c" (error: c.int, msg: cstring) {
	context = runtime.default_context()
	logf("opcode: %s, msg: %s", error, msg)
}

destroy_window :: proc() {
	glfw.DestroyWindow(window)
}


poll_events :: proc() {
	glfw.PollEvents()
}

swap_buffres :: proc() {
	glfw.SwapBuffers(window)
}


should_close :: proc() -> bool {
	return !cast(bool)glfw.WindowShouldClose(window) && !running
}

exit :: proc() {
	glfw.Terminate()
}
