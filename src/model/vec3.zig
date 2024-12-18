const std = @import("std");

pub const Vec3 = struct {
    e: [3]f64,

    pub fn init() Vec3 {
        return Vec3{ .e = [3]f64{ 0, 0, 0 } };
    }

    pub fn initWith(e0: f64, e1: f64, e2: f64) Vec3 {
        return Vec3{ .e = [3]f64{ e0, e1, e2 } };
    }

    pub fn x(self: *Vec3) f64 {
        return self.e[0];
    }

    pub fn y(self: *Vec3) f64 {
        return self.e[1];
    }

    pub fn z(self: *Vec3) f64 {
        return self.e[2];
    }

    pub fn index(self: Vec3, i: usize) f64 {
        return self.e[i];
    }

    pub fn indexMut(self: Vec3, i: usize) *f64 {
        return &self.e[i];
    }

    pub fn add(self: *const Vec3, v: Vec3) Vec3 {
        return Vec3.initWith(self.e[0] + v.e[0], self.e[1] + v.e[1], self.e[2] + v.e[2]);
    }

    pub fn sub(self: *const Vec3, t: Vec3) Vec3 {
        return Vec3.initWith(self.e[0] - t.e[0], self.e[1] - t.e[1], self.e[2] - t.e[2]);
    }

    pub fn subAssign(self: *Vec3, v: *Vec3) *Vec3 {
        self.e[0] -= v.e[0];
        self.e[1] -= v.e[1];
        self.e[2] -= v.e[2];

        return &self;
    }

    pub fn addAssign(self: *Vec3, v: *Vec3) *Vec3 {
        self.e[0] += v.e[0];
        self.e[1] += v.e[1];
        self.e[2] += v.e[2];

        return &self;
    }

    pub fn mul(u: Vec3, v: Vec3) Vec3 {
        return Vec3.initWith(u.e[0] * v.e[0], u.e[1] * v.e[1], u.e[2] * v.e[2]);
    }

    pub fn mulScalar(self: *const Vec3, t: f64) Vec3 {
        return Vec3.initWith(t * self.e[0], t * self.e[1], t * self.e[2]);
    }

    pub fn mulAssign(self: *Vec3, t: f64) *Vec3 {
        self.e[0] *= t;
        self.e[1] *= t;
        self.e[2] *= t;

        return &self;
    }

    pub fn divScalar(self: *const Vec3, t: f64) Vec3 {
        return Vec3.initWith(self.e[0] / t, self.e[1] / t, self.e[2] / t);
    }

    pub fn divAssign(self: *const Vec3, t: f64) *Vec3 {
        self.mulAssign(1.0 / t);

        return &self;
    }

    pub fn length(self: *const Vec3) f64 {
        return std.math.sqrt(self.lengthSquared());
    }

    pub fn lengthSquared(self: *const Vec3) f64 {
        return self.e[0] * self.e[0] + self.e[1] * self.e[1] + self.e[2] * self.e[2];
    }
};

pub const Point3 = Vec3;

pub fn printVec3(v: *Vec3) void {
    const writer = std.io.getStdOut().writer();
    _ = writer.print("{} {} {}\n", .{ v.x(), v.y(), v.z() });
}

pub fn add(u: Vec3, v: Vec3) Vec3 {
    return Vec3.initWith(u.e[0] + v.e[0], u.e[1] + v.e[1], u.e[2] + v.e[2]);
}

pub fn sub(u: Vec3, v: Vec3) Vec3 {
    return Vec3.initWith(u.e[0] - v.e[0], u.e[1] - v.e[1], u.e[2] - v.e[2]);
}

pub fn mul(u: Vec3, v: Vec3) Vec3 {
    return Vec3.initWith(u.e[0] * v.e[0], u.e[1] * v.e[1], u.e[2] * v.e[2]);
}

pub fn mulScalar(t: f64, v: Vec3) Vec3 {
    return Vec3.initWith(t * v.e[0], t * v.e[1], t * v.e[2]);
}

pub fn div(v: Vec3, t: f64) Vec3 {
    return mulScalar(1.0 / t, v);
}

pub fn dot(u: Vec3, v: Vec3) f64 {
    return u.e[0] * v.e[0] + u.e[1] * v.e[1] + u.e[2] * v.e[2];
}

pub fn cross(u: Vec3, v: Vec3) Vec3 {
    return Vec3.initWith(
        v.e[1] * v.e[2] - u.e[2] * v.e[1],
        v.e[2] * v.e[0] - u.e[0] * v.e[2],
        v.e[0] * v.e[1] - u.e[1] * v.e[0],
    );
}

pub fn unitVector(v: Vec3) Vec3 {
    return div(v, v.length());
}
