package accelerator

import sokol_app "sokol-odin/sokol/app"
import sokol_gfx "sokol-odin/sokol/gfx"
import sokol_glue "sokol-odin/sokol/glue"
import sokol_log "sokol-odin/sokol/log"

import "base:intrinsics"
import "core:c"
import "core:fmt"

import "base:runtime"

SokolBackend :: enum {
	GLCORE,
	GLES3,
	D3D11,
	METAL_IOS,
	METAL_MACOS,
	METAL_SIMULATOR,
	WGPU,
	DUMMY,
}


Backend :: enum {
	Dummy,
	Sokol,
}

BACKEND: Backend : .Sokol

@(private)
RenderPipline :: struct {
	action: sokol_gfx.Pass_Action,
}

@(private)
SOKOL_FN :: proc "c" ()
@(private)
SOKOL_EVENT_FN :: proc "c" (a0: ^sokol_app.Event)

DUMMY_LOG :: #force_inline proc() {fmt.println(#line, "not inplemented Dummy backend selected")}
TODO :: #force_inline proc(msg: string = "") {fmt.println(#line, "not inplemented reason:", msg)}

@(private)
render_pipline: RenderPipline

app :: proc(
	width, height: c.int,
	title: cstring,
	$INIT: proc(),
	$FRAME: proc(),
	$CLEANUP: proc(),
	$EVENT: proc(),
) {
	when BACKEND == .Sokol {
		sokol_app.run(
			{
				width = width,
				height = height,
				window_title = title,
				init_cb = _make_init_fn(INIT),
				frame_cb = _make_frame_fn(FRAME),
				cleanup_cb = _make_cleanup_fn(CLEANUP),
				event_cb = _make_event_fn(EVENT),
				icon = {sokol_default = true},
				logger = {func = sokol_log.func},
			},
		)
	}
	when BACKEND == .Dummy {
		DUMMY_LOG()
	}

}


initialize_render_pipline :: proc() {
	render_pipline = RenderPipline{}
}

@(private)
_make_init_fn :: proc($INIT: proc()) -> SOKOL_FN {

	return proc "c" () {
			context = runtime.default_context()
			sokol_gfx.setup(
				{environment = sokol_glue.environment(), logger = {func = sokol_log.func}},
			)
			render_pipline.action.colors[0] = {
				load_action = .CLEAR,
				clear_value = _to_sokol_color(GRAY),
			}
			context = runtime.default_context()
			INIT()
		}
}

@(private)
_to_sokol_color :: #force_inline proc(c: Color) -> sokol_gfx.Color {
	return {c.r, c.g, c.b, c.a}
}

@(private)
_make_frame_fn :: proc($FRAME: proc()) -> SOKOL_FN {
	return proc "c" () {
			context = runtime.default_context()
			FRAME()
			sokol_gfx.begin_pass(
				{action = render_pipline.action, swapchain = sokol_glue.swapchain()},
			)
			sokol_gfx.end_pass()
			sokol_gfx.commit()
		}
}

@(private)
_make_cleanup_fn :: proc($CLEANUP: proc()) -> SOKOL_FN {
	return proc "c" () {
			context = runtime.default_context()
			CLEANUP()
			sokol_gfx.shutdown()
		}
}

@(private)
_make_event_fn :: proc($EVENT: proc()) -> SOKOL_EVENT_FN {
	return proc "c" (a0: ^sokol_app.Event) {
			context = runtime.default_context()
			EVENT()
		}
}


which_sokol_backend :: proc() -> SokolBackend {
	return cast(SokolBackend)sokol_gfx.query_backend()
}


clear :: proc(color: Color) {
}

draw_texture :: proc(texture: Texture, position, scale, sqew: Vec2, rotation: f32, tint: Color) {
}

draw_texture_with_custom_material :: proc(
	texture: Texture,
	position, scale, sqew: Vec2,
	rotation: f32,
	material: Material = DEFAULT_MATERIAL,
) {
	TODO()
}

draw_quad :: proc(position, size, offset, sqew: Vec2, rotation: f32, tint: Color = WHITE) {
	TODO()
}

draw_circle :: proc(postion: Vec2, radius: f32, tint: Color = WHITE) {
	TODO()
}

draw_line :: proc(a, b: Vec2, width: f32 = 1, tint: Color = WHITE) {
	TODO()
}

draw_mesh :: proc() {
	TODO("have to figure out how to store meshesh first")
}
