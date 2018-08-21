import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: - Course Routes
    
    // POST /api/courses
    // Create a new course. Course info in JSON body
    
    router.post("api", "courses") { req -> Future<Course> in
        return try req.content.decode(Course.self).flatMap(to: Course.self) { course in
            return course.save(on: req)
        }
    }
    
    // GET /api/courses
    // Return all courses
    
    router.get("api", "courses") { req -> Future<[Course]> in
        return Course.query(on: req).all()
    }
    
    // GET /api/courses/:courseId
    // Return a single course
    
    router.get("api", "courses", Course.parameter) { req -> Future<Course> in
        return try req.parameters.next(Course.self)
    }
    
    // PUT /api/courses/:courseId
    // Update a course
    
    router.put("api", "courses", Course.parameter) { req -> Future<Course> in
        return try flatMap(to: Course.self, req.parameters.next(Course.self), req.content.decode(Course.self)) { course, updateCourse in
            course.name = updateCourse.name
            course.url = updateCourse.url
            
            return course.save(on: req)
        }
    }
    
    // DELETE /api/courses/:courseId
    // Delete a single course
    
    router.delete("api", "courses", Course.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Course.self).flatMap(to: HTTPStatus.self) { course in
            return course.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
}

















