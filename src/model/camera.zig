const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const Color = @import("color.zig").Color;
const HittableList = @import("hittableList.zig").HittableList;
const HitRecord = @import("hittable.zig").HitRecord;
const Interval = @import("interval.zig").Interval;
const Ray = @import("ray.zig").Ray;
const Vec3 = @import("vec3.zig").Vec3;
const Point3 = @import("vec3.zig").Point3;
const infinity = @import("../utils/rtweekend.zig").infinity;
const unitVector = @import("vec3.zig").unitVector;
const writeColor = @import("color.zig").writeColor;

pub const Camera = struct {
    aspectRatio: f64,
    imageWidth: u32,

    var imageHeight: u32 = undefined;
    var center: Point3 = undefined;
    var pixel00Loc: Point3 = undefined;
    var pixelDeltaU: Vec3 = undefined;
    var pixelDeltaV: Vec3 = undefined;

    const Self = @This();

    pub fn render(self: *Self, world: HittableList) !void {
        self.initialize();

        try stdout.print("P3\n{} {}\n255\n", .{ self.imageWidth, imageHeight });

        for (0..@intCast(imageHeight)) |j| {
            try stderr.print("\rScanlines remaining: {d} ", .{@as(usize, @intCast(imageHeight)) - j});
            for (0..self.imageWidth) |i| {
                const pixelCenter = pixel00Loc.add(pixelDeltaU.mulScalar(@floatFromInt(i))).add(pixelDeltaV.mulScalar(@floatFromInt(j)));
                const rayDirection = pixelCenter.sub(center);
                const r = Ray{ .orig = center, .dir = rayDirection };

                var pixelColor = rayColor(r, world);
                try writeColor(&stdout, &pixelColor);
            }
        }

        try stderr.print("\rDone.                     \n", .{});
    }

    pub fn init() Self {
        return undefined;
    }

    fn initialize(self: Self) void {
        imageHeight = @intFromFloat(@as(f64, @floatFromInt(self.imageWidth)) / self.aspectRatio);
        imageHeight = if (imageHeight < 1) 1 else imageHeight;

        center = Point3.initWith(0, 0, 0);

        const focalLength = 1.0;
        const viewportHeight = 2.0;
        const viewportWidth: f64 = @as(f64, viewportHeight) * (@as(f64, @floatFromInt(self.imageWidth)) / @as(f64, @floatFromInt(imageHeight)));

        const viewportU = Vec3.initWith(viewportWidth, 0, 0);
        const viewportV = Vec3.initWith(0, -viewportHeight, 0);

        pixelDeltaU = viewportU.divScalar(@floatFromInt(self.imageWidth));
        pixelDeltaV = viewportV.divScalar(@floatFromInt(imageHeight));

        const viewportUpperLeft = center.sub(Vec3.initWith(0, 0, focalLength)).sub(viewportU.divScalar(2)).sub(viewportV.divScalar(2));
        pixel00Loc = viewportUpperLeft.add(pixelDeltaU.add(pixelDeltaV).mulScalar(0.5));
    }

    fn rayColor(r: Ray, world: HittableList) Color {
        var rec: HitRecord = undefined;
        if (world.hit(r, Interval.init(0, infinity), &rec)) {
            return rec.normal.add(Color.initWith(1, 1, 1)).mulScalar(0.5);
        }

        var unitDirection = unitVector(r.getDirection());
        const a = 0.5 * (unitDirection.y() + 1.0);
        return Color.initWith(1.0, 1.0, 1.0).mulScalar(1.0 - a).add(Color.initWith(0.5, 0.7, 1.0).mulScalar(a));
    }
};
