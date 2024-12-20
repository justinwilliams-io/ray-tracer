const std = @import("std");
const Ray = @import("ray.zig").Ray;
const vec3 = @import("vec3.zig");
const Point3 = vec3.Point3;
const Vec3 = vec3.Vec3;
const dot = vec3.dot;
const Sphere = @import("sphere.zig").Sphere;
const Interval = @import("interval.zig").Interval;

pub const Hittable = union(enum) {
    sphere: Sphere,
    const Self = @This();

    pub fn hit(self: Self, r: Ray, rayT: Interval, rec: *HitRecord) bool {
        return switch (self) {
            .sphere => |s| s.hit(r, rayT, rec),
        };
    }
};

pub const HitRecord = struct {
    p: Point3,
    normal: Vec3,
    t: f64,
    frontFace: bool,

    pub fn setFaceNormal(self: *HitRecord, r: Ray, outwardNormal: Vec3) void {
        self.frontFace = dot(r.getDirection(), outwardNormal) < 0;
        self.normal = if (self.frontFace) outwardNormal else outwardNormal.negative();
    }
};

pub const ReturnHitStruct = struct {
    isHit: bool,
    rec: HitRecord,
};
