const std = @import("std");
const vec3 = @import("vec3.zig");

pub const Color = vec3.Vec3;

pub fn writeColor(out: anytype, pixelColor: *Color) !void {
    const r = pixelColor.x();
    const g = pixelColor.y();
    const b = pixelColor.z();

    const rbyte = @as(u8, @intFromFloat(@as(f64, 255.999 * r)));
    const gbyte = @as(u8, @intFromFloat(@as(f64, 255.999 * g)));
    const bbyte = @as(u8, @intFromFloat(@as(f64, 255.999 * b)));

    try out.print("{} {} {}\n", .{ rbyte, gbyte, bbyte });
}
