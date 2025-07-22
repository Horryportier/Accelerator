package dolly

import accel "../"


window_setup: accel.Window = {640, 360, "Dolly"}

main :: proc() {
	accel.log("init")
	if err := accel.init_window(window_setup); err != .OK {
		accel.log(err)
		return
	}
	for {
		accel.log("loop")
		if accel.should_close() {
			break
		}
		accel.update()
	}
	accel.destroy_window()
	accel.exit()
}
