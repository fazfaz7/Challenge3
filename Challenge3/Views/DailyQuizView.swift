import SwiftUI
import SwiftData

// MARK: - Phase

enum QuizPhase: Equatable {
    case asking
    case revealed(selected: String)
    case finished
}

// MARK: - ViewModel

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var phase: QuizPhase = .asking
    @Published var score: Int = 0
    @Published var wrongPhrases: [LearnElement] = []

    private(set) var language: String

    init(phrases: [LearnElement], language: String) {
        self.language = language
        self.questions = QuizEngine.generateQuestions(from: phrases)
    }

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    func select(answer: String, modelContext: ModelContext) {
        guard case .asking = phase, let q = currentQuestion else { return }

        let correct = answer == q.correctAnswer
        phase = .revealed(selected: answer)

        if correct {
            score += 1
            q.phrase.correctStreak += 1
            if q.phrase.correctStreak >= 3 { q.phrase.isMastered = true }
        } else {
            q.phrase.correctStreak = 0
            wrongPhrases.append(q.phrase)
        }
        q.phrase.lastReviewedAt = .now

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.advance(modelContext: modelContext)
        }
    }

    private func advance(modelContext: ModelContext) {
        let next = currentIndex + 1
        if next >= questions.count {
            saveRecord(modelContext: modelContext)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                phase = .finished
            }
        } else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                currentIndex = next
                phase = .asking
            }
        }
    }

    private func saveRecord(modelContext: ModelContext) {
        let record = QuizRecord(score: score, total: questions.count, language: language)
        modelContext.insert(record)
        try? modelContext.save()
    }
}

// MARK: - Main View

struct DailyQuizView: View {
    @StateObject private var vm: QuizViewModel
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var streakStore: QuizStreakStore

    var onFinish: (Int, Int) -> Void

    init(phrases: [LearnElement], language: String, onFinish: @escaping (Int, Int) -> Void) {
        _vm = StateObject(wrappedValue: QuizViewModel(phrases: phrases, language: language))
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            if case .finished = vm.phase {
                QuizResultsView(
                    score: vm.score,
                    total: vm.questions.count,
                    wrongPhrases: vm.wrongPhrases,
                    language: vm.language
                ) {
                    onFinish(vm.score, vm.questions.count)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .opacity
                ))
            } else {
                quizContent
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.phase == .finished)
    }

    // MARK: Quiz content

    private var quizContent: some View {
        VStack(spacing: 0) {
            progressHeader
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)

            if let question = vm.currentQuestion {
                questionCard(question)
                    .padding(.horizontal, 24)
                    .id(vm.currentIndex)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

                Spacer(minLength: 24)

                answerButtons(question)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .id(vm.currentIndex)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
    }

    // MARK: Progress header

    private var progressHeader: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Daily Challenge")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("\(vm.currentIndex + 1) of \(vm.questions.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 120, height: 6)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                Color(red: 0.1, green: 0.7, blue: 0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: max(6, 120 * (vm.progress + 1.0 / Double(vm.questions.count))),
                        height: 6
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.currentIndex)
            }
        }
    }

    // MARK: Question card

    private func questionCard(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                question.type == .wordToExplanation ? "What does this mean?" : "How do you say it?",
                systemImage: question.type == .wordToExplanation ? "text.bubble" : "character.bubble"
            )
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)

            Text(question.questionText)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }

    // MARK: Answer buttons

    private func answerButtons(_ question: QuizQuestion) -> some View {
        VStack(spacing: 12) {
            ForEach(question.options, id: \.self) { option in
                AnswerButton(
                    text: option,
                    state: buttonState(for: option, question: question),
                    action: { vm.select(answer: option, modelContext: modelContext) }
                )
            }
        }
    }

    private func buttonState(for option: String, question: QuizQuestion) -> AnswerButtonState {
        guard case .revealed(let selected) = vm.phase else { return .idle }
        if option == question.correctAnswer { return .correct }
        if option == selected { return .wrong }
        return .dimmed
    }
}

// MARK: - Answer Button

enum AnswerButtonState { case idle, correct, wrong, dimmed }

struct AnswerButton: View {
    let text: String
    let state: AnswerButtonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: state == .idle ? 1 : 0)
                )
                .shadow(color: shadowColor, radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(state != .idle)
        .scaleEffect(state == .correct ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state)
    }

    @ViewBuilder
    private var background: some View {
        switch state {
        case .idle:
            Color.clear.background(.ultraThinMaterial)
        case .correct:
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.72, blue: 0.65), Color(red: 0.1, green: 0.7, blue: 0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .wrong:
            Color(red: 0.95, green: 0.3, blue: 0.3).opacity(0.85)
        case .dimmed:
            Color.clear.background(.ultraThinMaterial).opacity(0.5)
        }
    }

    private var foregroundColor: Color {
        switch state {
        case .idle: return .primary
        case .correct, .wrong: return .white
        case .dimmed: return .secondary
        }
    }

    private var borderColor: Color {
        Color.secondary.opacity(0.2)
    }

    private var shadowColor: Color {
        switch state {
        case .correct: return Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.35)
        case .wrong: return Color.red.opacity(0.25)
        default: return Color.black.opacity(0.03)
        }
    }
}
