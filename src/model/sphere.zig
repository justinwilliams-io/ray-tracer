const std = @import("std");
const HitRecord = @import("hittable.zig").HitRecord;
const Ray = @import("ray.zig").Ray;
const vec3 = @import("vec3.zig");
const Point3 = vec3.Point3;
const Vec3 = vec3.Vec3;
const dot = vec3.dot;
const Interval = @import("interval.zig").Interval;

pub const Sphere = struct {
    center: Point3,
    radius: f64,

    const Self = @This();

    pub fn init(center: Point3, radius: f64) Self {
        return .{ .center = center, .radius = @max(0.0, radius) };
    }

    pub fn hit(self: Self, r: Ray, rayT: Interval, rec: *HitRecord) bool {
        const oc = self.center.sub(r.getOrigin());
        const a = r.getDirection().lengthSquared();
        const h = dot(r.getDirection(), oc);
        const c = oc.lengthSquared() - (self.radius * self.radius);

        const discriminant = h * h - a * c;
        if (discriminant < 0) return false;

        const sqrtd = std.math.sqrt(discriminant);

        var root = (h - sqrtd) / a;
        if (!rayT.surrounds(root)) {
            root = (h + sqrtd) / a;
            if (!rayT.surrounds(root)) {
                return false;
            }
        }

        rec.t = root;
        rec.p = r.at(rec.t);
        const outwardNormal = rec.p.sub(self.center).divScalar(self.radius);
        rec.setFaceNormal(r, outwardNormal);

        return true;
    }
};
