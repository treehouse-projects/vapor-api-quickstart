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
}
