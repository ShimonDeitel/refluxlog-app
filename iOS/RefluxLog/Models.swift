import Foundation

struct EpisodeEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String
    var metric: Int          // Severity
    var tag: String          // Trigger food
    var note: String = ""
}

enum RefluxLogTags {
    static let all: [String] = ["Coffee", "Tomato", "Spicy", "Fried", "Chocolate", "Alcohol"]
}
