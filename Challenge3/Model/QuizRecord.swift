import Foundation
import SwiftData

@Model
class QuizRecord {
    var id = UUID()
    var date: Date
    var score: Int
    var total: Int
    var language: String

    init(date: Date = Calendar.current.startOfDay(for: .now), score: Int, total: Int, language: String) {
        self.date = date
        self.score = score
        self.total = total
        self.language = language
    }
}
