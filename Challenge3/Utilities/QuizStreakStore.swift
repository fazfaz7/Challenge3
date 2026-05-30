import Foundation
import SwiftUI

struct QuizLanguageStats: Codable {
    var lastQuizDate: String = ""
    var currentStreak: Int = 0
    var longestStreak: Int = 0
}

class QuizStreakStore: ObservableObject {
    static let shared = QuizStreakStore()

    @Published private(set) var stats: [String: QuizLanguageStats] = [:]

    private let key = "quizLanguageStats"

    private init() { load() }

    func getStats(for language: String) -> QuizLanguageStats {
        stats[language] ?? QuizLanguageStats()
    }

    func completedToday(for language: String) -> Bool {
        getStats(for: language).lastQuizDate == todayString
    }

    func recordCompletion(for language: String) {
        var s = getStats(for: language)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        if let lastDate = ISO8601DateFormatter().date(from: s.lastQuizDate) {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if calendar.isDate(lastDate, inSameDayAs: yesterday) {
                s.currentStreak += 1
            } else if !calendar.isDate(lastDate, inSameDayAs: today) {
                s.currentStreak = 1
            }
        } else {
            s.currentStreak = 1
        }

        if s.currentStreak > s.longestStreak {
            s.longestStreak = s.currentStreak
        }

        s.lastQuizDate = todayString
        stats[language] = s
        save()
    }

    func resetToday(for language: String) {
        var s = getStats(for: language)
        s.lastQuizDate = ""
        stats[language] = s
        save()
    }

    private var todayString: String {
        ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: .now))
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: QuizLanguageStats].self, from: data)
        else { return }
        stats = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
