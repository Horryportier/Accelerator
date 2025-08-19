package accelerator

import sokol_app "sokol-odin/sokol/app"
import sokol_gfx "sokol-odin/sokol/gfx"
import sokol_log "sokol-odin/sokol/log"

import "base:intrinsics"
import "core:c"
import "core:fmt"

import "base:runtime"

Backend :: enum {
	Dummy,
	Sokol,
}

BACKEND: Backend : .Sokol

app :: proc(
	width, height: c.int,
	title: cstring,
	$INIT: proc(),
	$FRAME: proc(),
	$CLEANUP: proc(),
	$EVENT: proc(),
) {
	context = runtime.default_context()
	_init := proc "c" () {
		context = runtime.default_context()
		INIT()
	}
	_frame := proc "c" () {
		context = runtime.default_context()
		FRAME()
	}
	_cleanup := proc "c" () {
		context = runtime.default_context()
		CLEANUP()
	}
	fmt.printfln("\033[33mEvent loop not implemented\033[0m")
	_event := proc "c" (a0: ^sokol_app.Event) {
		context = runtime.default_context()
		EVENT()
	}
	sokol_app.run(
		{
			width = width,
			height = height,
			window_title = title,
			init_cb = _init,
			frame_cb = _frame,
			cleanup_cb = _cleanup,
			event_cb = _event,
			icon = {sokol_default = true},
			logger = {func = sokol_log.func},
		},
	)
}
