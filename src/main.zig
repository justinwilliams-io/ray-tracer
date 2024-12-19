const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const vec3 = @import("model/vec3.zig");
const unitVector = @import("model/vec3.zig").unitVector;
const dot = vec3.dot;
const Vec3 = vec3.Vec3;
const Point3 = vec3.Point3;
const color = @import("model/color.zig");
const Color = color.Color;
const Ray = @import("model/ray.zig").Ray;
const writeColor = color.writeColor;
const HittableList = @import("model/hittableList.zig").HittableList;
const hittable = @import("model/hittable.zig");
const Hittable = hittable.Hittable;
const HitRecord = hittable.HitRecord;
const utils = @import("utils/rtweekend.zig");
const Sphere = @import("model/sphere.zig").Sphere;

fn rayColor(r: *const Ray, world: *const HittableList) Color {
    const rec: HitRecord = undefined;
    if (world.hit(r, 0, utils.infinity, rec)) {
        return 0.5 * (rec.normal + Color.initWith(1, 1, 1));
    }

    var unitDirection = unitVector(r.getDirection());
    const a = 0.5 * (unitDirection.y() + 1.0);
    return vec3.add(vec3.mulScalar((1.0 - a), Color.initWith(1.0, 1.0, 1.0)), vec3.mulScalar(a, Color.initWith(0.5, 0.7, 1.0)));
}

pub fn main() !void {
    const aspectRatio: f64 = 16.0 / 9.0;
    const imageWidth: i32 = 400;

    var imageHeight: i32 = @intFromFloat(@as(f64, imageWidth) / aspectRatio);
    if (imageHeight < 1) {
        imageHeight = 1;
    }

    const world = HittableList.init();

    world.add(Sphere.init(Point3.initWith(0, 0, -1), 0.5));
    world.add(Sphere.init(Point3.initWith(0, -100.5, -1), 100));

    const focalLength = 1.0;
    const viewportHeight = 2.0;
    const viewportWidth: f64 = @as(f64, viewportHeight) * (@as(f64, imageWidth) / @as(f64, @floatFromInt(imageHeight)));
    const cameraCenter = Point3.init();

    const viewportU = Vec3.initWith(viewportWidth, 0, 0);
    const viewportV = Vec3.initWith(0, -viewportHeight, 0);

    const pixelDeltaU = viewportU.divScalar(imageWidth);
    const pixelDeltaV = viewportV.divScalar(@floatFromInt(imageHeight));

    const viewportUpperLeft = cameraCenter.sub(Vec3.initWith(0, 0, focalLength)).sub(viewportU.divScalar(2)).sub(viewportV.divScalar(2));
    const pixel00Loc = vec3.add(viewportUpperLeft, vec3.mulScalar(0.5, (vec3.add(pixelDeltaU, pixelDeltaV))));

    try stdout.print("P3\n{} {}\n255\n", .{ imageWidth, imageHeight });

    for (0..@intCast(imageHeight)) |j| {
        try stderr.print("\rScanlines remaining: {d} ", .{@as(usize, @intCast(imageHeight)) - j});
        for (0..imageWidth) |i| {
            const pixelCenter = pixel00Loc.add(pixelDeltaU.mulScalar(@floatFromInt(i))).add(pixelDeltaV.mulScalar(@floatFromInt(j)));
            const rayDirection = pixelCenter.sub(cameraCenter);
            var r = Ray{ .orig = cameraCenter, .dir = rayDirection };

            var pixelColor = rayColor(&r);
            try writeColor(&stdout, &pixelColor);
        }
    }

    try stderr.print("\rDone.                     \n", .{});
}
