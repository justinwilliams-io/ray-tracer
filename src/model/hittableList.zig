const std = @import("std");
const hittable = @import("hittable.zig");
const Hittable = hittable.Hittable;
const HitRecord = hittable.HitRecord;
const Ray = @import("ray.zig").Ray;

pub const HittableList = struct {
    objects: []*const Hittable,

    pub fn init() HittableList {
        return HittableList{ .objects = &[_]*const Hittable{} };
    }

    pub fn add(self: *const HittableList, object: *const Hittable) void {
        self.objects = std.mem.resize(self.objects.len + 1);
        self.objects[self.objects.len] = object;
    }

    pub fn clear(self: *const HittableList) void {
        self.objects = &[_]*const Hittable{};
    }

    pub fn hit(self: *const HittableList, r: *const Ray, ray_tmin: f64, ray_tmax: f64, rec: *HitRecord) bool {
        var tempRec: HitRecord = undefined;
        var hitAnything = false;
        var closestSoFar = ray_tmax;

        for (self.objects) |object| {
            if (object.hit(r, ray_tmin, closestSoFar, &tempRec)) {
                hitAnything = true;
                closestSoFar = tempRec.t;
                rec.* = tempRec;
            }
        }

        return hitAnything;
    }
};
