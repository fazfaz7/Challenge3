import Foundation

enum QuizQuestionType {
    case wordToExplanation
    case explanationToWord
}

struct QuizQuestion {
    let phrase: LearnElement
    let questionText: String
    let correctAnswer: String
    let options: [String]
    let type: QuizQuestionType
}

struct QuizEngine {

    static let questionsPerSession = 5
    static let minimumWords = 4

    static func canGenerateQuiz(from phrases: [LearnElement]) -> Bool {
        phrases.count >= minimumWords
    }

    static func generateQuestions(from phrases: [LearnElement]) -> [QuizQuestion] {
        guard canGenerateQuiz(from: phrases) else { return [] }

        let pool = prioritizedPool(from: phrases)
        let selected = Array(pool.prefix(questionsPerSession))

        return selected.enumerated().compactMap { index, phrase in
            let type: QuizQuestionType = index.isMultiple(of: 2) ? .wordToExplanation : .explanationToWord
            return buildQuestion(for: phrase, type: type, pool: phrases)
        }
    }

    // MARK: - Private

    private static func prioritizedPool(from phrases: [LearnElement]) -> [LearnElement] {
        let neverReviewed = phrases.filter { $0.lastReviewedAt == nil }.shuffled()
        let reviewed = phrases
            .filter { $0.lastReviewedAt != nil }
            .sorted { ($0.lastReviewedAt ?? .distantPast) < ($1.lastReviewedAt ?? .distantPast) }
        return neverReviewed + reviewed
    }

    private static func buildQuestion(
        for phrase: LearnElement,
        type: QuizQuestionType,
        pool: [LearnElement]
    ) -> QuizQuestion? {
        let distractors = pool
            .filter { $0.id != phrase.id }
            .shuffled()
            .prefix(3)

        switch type {
        case .wordToExplanation:
            guard !phrase.explanation.isEmpty else { return nil }
            let wrongOptions = distractors.compactMap { $0.explanation.isEmpty ? nil : $0.explanation }
            guard wrongOptions.count >= 3 else { return nil }
            let options = ([phrase.explanation] + Array(wrongOptions.prefix(3))).shuffled()
            return QuizQuestion(
                phrase: phrase,
                questionText: phrase.userEntry,
                correctAnswer: phrase.explanation,
                options: options,
                type: .wordToExplanation
            )

        case .explanationToWord:
            guard !phrase.explanation.isEmpty else { return nil }
            let wrongOptions = distractors.compactMap { $0.userEntry.isEmpty ? nil : $0.userEntry }
            guard wrongOptions.count >= 3 else { return nil }
            let options = ([phrase.userEntry] + Array(wrongOptions.prefix(3))).shuffled()
            return QuizQuestion(
                phrase: phrase,
                questionText: phrase.explanation,
                correctAnswer: phrase.userEntry,
                options: options,
                type: .explanationToWord
            )
        }
    }
}
