package dolly_test


import "core:c"
import "core:fmt"

import "core:os"
import gl "vendor:OpenGL"
import "vendor:glfw"


PROGRAMNAME :: "Program"

GL_MAJOR_VERSION: c.int : 3
GL_MINOR_VERSION :: 3

running: b32 = true

VBO :: u32
VAO :: u32
EBO :: u32

ShaderProgram :: u32

program_shader: ShaderProgram

gloabal_vao: VAO

main :: proc() {
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	if (glfw.Init() != true) {

		fmt.println("Failed to initialize GLFW")

		return
	}

	defer glfw.Terminate()

	window := glfw.CreateWindow(512, 512, PROGRAMNAME, nil, nil)


	defer glfw.DestroyWindow(window)

	if window == nil {
		fmt.println("Unable to create window")
		return
	}

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)
	glfw.SetKeyCallback(window, key_callback)
	glfw.SetFramebufferSizeCallback(window, size_callback)
	gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address)

	vertex_shader_source := string(#load("../../shaders/vertex.glsl"))
	fragment_shader_source := string(#load("../../shaders/fragment.glsl"))
	progarm_ok: bool
	program_shader, progarm_ok = gl.load_shaders_source(
		vertex_shader_source,
		fragment_shader_source,
	)
	if !progarm_ok {
		fmt.println("failde to load shader program");os.exit(1)
	}
	vertices1 := [?]f32 {
		0.5,
		0.5,
		0.0, // top right
		0.5,
		-0.5,
		0.0, // bottom right
		-0.5,
		-0.5,
		0.0, // bottom let
		-0.5,
		0.5,
		0.0, // top let 
	}
	vertices2 := [?]f32 {
		0.5,
		0.5,
		0.0, // 0 top right
		0.5,
		-0.5,
		0.0, // 1 bottom right
		-0.5,
		0.5,
		0.0,
		0.5,
		-0.5,
		0.0,
		-0.5,
		-0.5,
		0.0, // 2 bottom let
		-0.5,
		0.5,
		0.0, // 3 top let 
	}

	indices := [6]i32{0, 1, 3, 1, 2, 3}

	vbo: VBO
	ebo: EBO
	gl.GenVertexArrays(1, &gloabal_vao)
	gl.BindVertexArray(gloabal_vao)

	gl.GenBuffers(1, &vbo)
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(
		gl.ARRAY_BUFFER,
		size_of(vertices1[0]) * len(vertices1),
		&vertices1,
		gl.STATIC_DRAW,
	)

	gl.GenBuffers(1, &ebo)
	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(
		gl.ELEMENT_ARRAY_BUFFER,
		size_of(indices[0]) * len(indices),
		&indices,
		gl.STATIC_DRAW,
	)


	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)

	//gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
	for (!glfw.WindowShouldClose(window) && running) {
		gl.ClearColor(0.1, 0.1, 0.1, 1)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		gl.UseProgram(program_shader)
		gl.BindVertexArray(gloabal_vao)
		//gl.DrawArrays(gl.TRIANGLES, 0, 6)
		gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, rawptr(uintptr(0)))

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}
}


key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}
