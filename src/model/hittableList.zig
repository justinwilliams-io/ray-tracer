const std = @import("std");
const hittable = @import("hittable.zig");
const Hittable = hittable.Hittable;
const HitRecord = hittable.HitRecord;
const Ray = @import("ray.zig").Ray;
const ArrayList = std.ArrayList;
const Interval = @import("interval.zig").Interval;

pub const HittableList = struct {
    objects: ArrayList(Hittable),

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) HittableList {
        return .{
            .objects = ArrayList(Hittable).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.objects.deinit();
    }

    pub fn add(self: *Self, object: Hittable) !void {
        try self.objects.append(object);
    }

    pub fn clear(self: Self) void {
        self.objects = &[_]*const Hittable{};
    }

    pub fn hit(self: Self, r: Ray, rayT: Interval, rec: *HitRecord) bool {
        var tempRec: HitRecord = undefined;
        var hitAnything = false;
        var closestSoFar = rayT.max;

        for (self.objects.items) |object| {
            if (object.hit(r, Interval.init(rayT.min, closestSoFar), &tempRec)) {
                hitAnything = true;
                closestSoFar = tempRec.t;
                rec.* = tempRec;
            }
        }

        return hitAnything;
    }
};
