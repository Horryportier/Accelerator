package dolly

import accel "../"


window_setup: accel.Window = {640, 360, "Dolly"}


MAX_VERTICES :: 3

World :: struct {
	clear_color: accel.Color,
	vertices:    [MAX_VERTICES]accel.Vec3,
}

world: World

main :: proc() {
	accel.log("init")
	if err := accel.init_window(window_setup); err != .OK {
		accel.log(err)
		return
	}
	init()
	for {
		if accel.should_close() {
			break
		}
		accel.poll_events()
		update()
		draw()
		accel.swap_buffres()
	}
	exit()
	defer accel.exit()
	defer accel.destroy_window()
}

init :: proc() {
	world = World {
		clear_color = accel.color(65, 69, 255, 255),
		vertices    = [MAX_VERTICES]accel.Vec3 {
			{-0.5, -0.5, 0.0},
			{0.5, -0.5, 0.0},
			{0.0, -0.5, 0.0},
		},
	}
}

update :: proc() {
}

draw :: proc() {
	accel.clear_screen(world.clear_color)
}

exit :: proc() {
}
