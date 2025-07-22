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

window: glfw.WindowHandle

running: bool = true

init_window :: proc(using window_settings: Window) -> AcceleratorError {

	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	if glfw.Init() != true {
		log("failed to initialize glfw")
		return .FailedToCreateWindow
	}
	window := glfw.CreateWindow(width, hegiht, title, nil, nil)
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
	return .OK
}

framebuffer_size_callback :: proc "c" (handle: glfw.WindowHandle, width, height: c.int) {
	gl.Viewport(0, 0, width, height)
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: c.int) {
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

error_callback :: proc "c" (error: c.int, msg: cstring) {
	context = runtime.default_context()
	logf("opcode: %s, msg: %s", error, msg)
}

destroy_window :: proc() {
	glfw.DestroyWindow(window)
}


update :: proc() {
	glfw.SwapBuffers(window)
	glfw.PollEvents()
}

should_close :: proc() -> bool {
	return cast(bool)glfw.WindowShouldClose(window) && !running
}

exit :: proc() {
	glfw.Terminate()
}
