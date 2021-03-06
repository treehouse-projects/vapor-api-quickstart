import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let coursesController = CoursesController()
    try router.register(collection: coursesController)
    
    // MARK: - Review Routes
    
    // POST /api/courses/:courseId/reviews
    // Create a new review for a course
    // Review info in JSON body
    
    router.post("api", "courses", Course.parameter, "reviews") { req -> Future<Review> in
        return try flatMap(to: Review.self, req.parameters.next(Course.self), req.content.decode(Review.self)) { course, review in
            
            guard course.id == review.courseID else {
                throw Abort(.badRequest, reason: "Course ID specified in JSON does not match")
            }
            
            return review.save(on: req)
        }
    }
    
    // GET /api/courses/:courseId/reviews
    // Return all reviews for a course
    
    router.get("api", "courses", Course.parameter, "reviews") { req -> Future<[Review]> in
        return try req.parameters.next(Course.self).flatMap(to: [Review].self) { course in
            try course.reviews.query(on: req).all()
        }
    }
    
    // GET /api/courses/:courseId/reviews/:reviewId
    // Return a single review
    
    router.get("api", "courses", Course.parameter, "reviews", Int.parameter) { req -> Future<Review> in
        return try req.parameters.next(Course.self).flatMap(to: Review.self) { course in
            let reviewId = try req.parameters.next(Int.self)
            return try course.reviews.query(on: req).filter(\Review.id == reviewId).first().map(to: Review.self) { filteredReview in
                
                guard let filteredReview = filteredReview else {
                    throw Abort(.notFound, reason: "No review available for specified ID")
                }
                
                return filteredReview
            }
        }
    }
    
    // PUT /api/courses/:courseId/reviews/:reviewId
    // Update review
    
    router.put("api", "courses", Course.parameter, "reviews", Int.parameter) { req -> Future<Review> in
        return try flatMap(to: Review.self, req.parameters.next(Course.self), req.content.decode(Review.self)) { course, updatedReview in
            
            let reviewId = try req.parameters.next(Int.self)
            
            return try course.reviews.query(on: req).filter(\Review.id == reviewId).first().flatMap(to: Review.self) { filteredReview in
                
                guard let filteredReview = filteredReview else {
                    throw Abort(.notFound, reason: "No review available for specified ID")
                }
                
                filteredReview.rating = updatedReview.rating
                filteredReview.comment = updatedReview.comment
                
                return filteredReview.save(on: req)
            }
        }
    }
    
    // DELETE /api/courses/:courseId/reviews/:reviewId
    // Delete a review
    
    router.delete("api", "courses", Course.parameter, "reviews", Int.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Course.self).flatMap(to: HTTPStatus.self) { course in
            let reviewId = try req.parameters.next(Int.self)
            return try course.reviews.query(on: req).filter(\Review.id == reviewId).first().flatMap(to: HTTPStatus.self) { filteredReview in
                
                guard let filteredReview = filteredReview else {
                    throw Abort(.notFound, reason: "No review available for specified ID")
                }
                
                return filteredReview.delete(on: req).transform(to: HTTPStatus.noContent)
            }
        }
    }
}

















