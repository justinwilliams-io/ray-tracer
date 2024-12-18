const Vec3 = @import("vec3.zig").Vec3;
const Point3 = @import("vec3.zig").Point3;

pub const Ray = struct {
    orig: Point3,
    dir: Vec3,

    pub fn init() Ray {
        return Ray{
            .orig = Point3.init(),
            .dir = Vec3.init(),
        };
    }

    pub fn initWith(origin: Point3, direction: Vec3) Ray {
        return Ray{
            .orig = origin,
            .dir = direction,
        };
    }

    pub fn getOrigin(self: *Ray) Point3 {
        return self.orig;
    }

    pub fn getDirection(self: *const Ray) Point3 {
        return self.dir;
    }

    pub fn at(self: *Ray, t: f64) Point3 {
        return self.orig + (self.dir * t);
    }
};
