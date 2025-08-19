package dolly

import accel "../"


main :: proc() {
	accel.app(640, 360, "DOLLY", init, frame, cleanup, event)
}

init :: proc() {

}

frame :: proc() {
}

cleanup :: proc() {
}

event :: proc() {
}
