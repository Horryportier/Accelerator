package accelerator

Texture :: u32

Material :: u32

Color :: [4]f32

Vec2 :: [2]f32
Vec3 :: [3]f32
Vec4 :: [4]f32

Vec2i :: [2]i32
Vec3i :: [3]i32
Vec4i :: [4]i32

DEFAULT_MATERIAL: Material : 0

WHITE: Color : {1, 1, 1, 1}
BLACK: Color : {0, 0, 0, 1}
RED: Color : {1, 0, 0, 1}
GREEN: Color : {0, 1, 0, 1}
BLUE: Color : {0, 0, 1, 1}
GRAY: Color : {0.5, 0.5, 0.5, 1}
