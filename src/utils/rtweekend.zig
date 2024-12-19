const std = @import("std");

pub const infinity: f64 = std.math.infinity(f64);
pub const pi: f64 = 3.1415926535897932385;

pub fn degreesToRadians(degrees: f64) f64 {
    return degrees * pi / 180.0;
}
