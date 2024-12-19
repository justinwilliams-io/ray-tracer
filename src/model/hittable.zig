const std = @import("std");
const Ray = @import("ray.zig").Ray;
const vec3 = @import("vec3.zig");
const Point3 = vec3.Point3;
const Vec3 = vec3.Vec3;
const dot = vec3.dot;
const Sphere = @import("sphere.zig").Sphere;

pub const HitRecord = struct {
    p: Point3,
    normal: Vec3,
    t: f64,
    frontFace: bool,

    pub fn setFaceNormal(self: *const HitRecord, r: *const Ray, outwardNormal: *const Vec3) void {
        self.frontFace = dot(r.getDirection(), outwardNormal) < 0;
        self.normal = if (self.frontFace) outwardNormal else -outwardNormal;
    }
};

pub const ReturnHitStruct = struct {
    isHit: bool,
    rec: HitRecord,
};

pub const Hittable = union(enum) {
    Sphere: Sphere,
    const Self = @This();

    pub fn hit(self: Self, r: Ray, ray_tmin: f64, ray_tmax: f64) ReturnHitStruct {
        return switch (self) {
            .sphere => |s| s.hit(r, ray_tmin, ray_tmax),
        };
    }
};
