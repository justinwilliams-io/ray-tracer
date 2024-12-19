const std = @import("std");
const Hittable = @import("hittable.zig");
const Ray = @import("ray.zig").Ray;
const vec3 = @import("vec3.zig");
const Point3 = vec3.Point3;
const Vec3 = vec3.Vec3;
const dot = vec3.dot;

pub const Sphere = struct {
    center: Point3,
    radius: f64,

    pub fn init(center: Point3, radius: f64) Sphere {
        return Sphere{ .center = center, .radius = @max(0.0, radius) };
    }

    pub fn hit(self: *Sphere, r: *const Ray, ray_tmin: f64, ray_tmax: f64, rec: *Hittable.HitRecord) bool {
        const oc = self.center.sub(r.getOrigin());
        const a = r.getDirection().lengthSquared();
        const h = dot(r.getDirection(), oc);
        const c = oc.lengthSquared() - (self.radius * self.radius);

        const discriminant = h * h - a * c;
        if (discriminant < 0) {
            return false;
        }

        const sqrtd = std.math.sqrt(discriminant);

        var root = (h - sqrtd) / a;
        if (root <= ray_tmin or ray_tmax <= root) {
            root = (h + sqrtd) / a;
            if (root <= ray_tmin or ray_tmax <= root) {
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
