const std = @import("std");
const vec3 = @import("model/vec3.zig");
const Point3 = vec3.Point3;
const Ray = @import("model/ray.zig").Ray;
const HittableList = @import("model/hittableList.zig").HittableList;
const Sphere = @import("model/sphere.zig").Sphere;
const Camera = @import("model/camera.zig").Camera;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var world = HittableList.init(allocator);

    try world.add(.{ .sphere = Sphere.init(Point3.initWith(0, 0, -1), 0.5) });
    try world.add(.{ .sphere = Sphere.init(Point3.initWith(0, -100.5, -1), 100) });

    var camera = Camera.init();

    camera.aspectRatio = 16.0 / 9.0;
    camera.imageWidth = 400;

    try camera.render(world);
}
