import Vapor
import FluentSQLite

final class Course: Codable {
    var id: Int?
    var name: String
    var url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

extension Course {
    var reviews: Children<Course, Review> {
        return children(\.courseID)
    }
}

extension Course: SQLiteModel {}
extension Course: Migration {}
extension Course: Content {}
extension Course: Parameter {}


















