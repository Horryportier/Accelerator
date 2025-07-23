package accelerator

import "core:math"

Color :: [4]f32

color :: proc {
	color_from_u8,
}

color_from_u8 :: proc(r, g, b, a: u8) -> Color {
	return Color {
		math.remap(cast(f32)r, 0, 255, 0, 1),
		math.remap(cast(f32)g, 0, 255, 0, 1),
		math.remap(cast(f32)b, 0, 255, 0, 1),
		math.remap(cast(f32)a, 0, 255, 0, 1),
	}
}

Vec3 :: [3]f32
Vec2 :: [2]f32
Vec4 :: [4]f32
