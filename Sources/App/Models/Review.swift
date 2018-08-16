import Vapor
import FluentSQLite

final class Review: Codable {
    var id: Int?
    var rating: Double
    var comment: String
    var courseID: Course.ID
    
    init(courseID: Course.ID, rating: Double, comment: String) {
        self.courseID = courseID
        self.rating = rating
        self.comment = comment
    }
}

extension Review: SQLiteModel {}
extension Review: Migration {}
