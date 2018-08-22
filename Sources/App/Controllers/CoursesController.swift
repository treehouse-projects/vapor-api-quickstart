import Vapor
import Fluent

struct CoursesController: RouteCollection {
    func boot(router: Router) throws {
        // MARK: - Course Routes
        
        let coursesRoutes = router.grouped("api", "courses")
        coursesRoutes.post(Course.self, use: createCourseHandler)
        coursesRoutes.get(use: getAllCoursesHandler)
        coursesRoutes.get(Course.parameter, use: getCourseHandler)
        coursesRoutes.put(Course.parameter, use: updateCourseHandler)
        coursesRoutes.delete(Course.parameter, use: deleteCourseHandler)
    }
    
    func createCourseHandler(_ req: Request, course: Course) throws -> Future<Course> {
        return course.save(on: req)
    }
    
    func getAllCoursesHandler(_ req: Request) throws -> Future<[Course]> {
        return Course.query(on: req).all()
    }
    
    func getCourseHandler(_ req: Request) throws -> Future<Course> {
        return try req.parameters.next(Course.self)
    }
    
    func updateCourseHandler(_ req: Request) throws -> Future<Course> {
        return try flatMap(to: Course.self, req.parameters.next(Course.self), req.content.decode(Course.self)) { course, updateCourse in
            course.name = updateCourse.name
            course.url = updateCourse.url
            
            return course.save(on: req)
        }
    }
    
    func deleteCourseHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Course.self).flatMap(to: HTTPStatus.self) { course in
            return course.delete(on: req).transform(to: HTTPStatus.noContent)
        }
    }
}

















