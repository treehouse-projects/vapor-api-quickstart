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

extension Course: SQLiteModel {}
extension Course: Migration {}


















