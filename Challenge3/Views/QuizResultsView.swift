import SwiftUI
import SwiftData

struct QuizResultsView: View {
    let score: Int
    let total: Int
    let wrongPhrases: [LearnElement]
    let language: String
    var onDone: () -> Void

    @EnvironmentObject private var streakStore: QuizStreakStore
    private var currentStreak: Int { streakStore.getStats(for: language).currentStreak }

    @Query(sort: \QuizRecord.date, order: .reverse) private var allRecords: [QuizRecord]
    @State private var appeared = false

    private var records: [QuizRecord] {
        allRecords.filter { $0.language == language }
    }

    private var isPerfect: Bool { score == total }
    private var scoreRatio: Double { total > 0 ? Double(score) / Double(total) : 0 }

    private var headline: String {
        switch score {
        case total: return "Perfect! 🎉"
        case (total - 1)...: return "Almost there!"
        case (total / 2)...: return "Good effort!"
        default: return "Keep practising!"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                scoreSection
                streakSection
                calendarSection
                if !wrongPhrases.isEmpty { wrongSection }
                doneButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 48)
        }
    }

    // MARK: Score

    private var scoreSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.12), lineWidth: 8)
                    .frame(width: 110, height: 110)

                Circle()
                    .trim(from: 0, to: appeared ? scoreRatio : 0)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                Color(red: 0.1, green: 0.7, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 110, height: 110)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: appeared)

                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                    Text("/ \(total)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Text(headline)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .onAppear { appeared = true }
    }

    // MARK: Streak

    private var streakSection: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: 28))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("\(currentStreak) day streak")
                    .font(.headline)
                    .fontWeight(.bold)

                Text(currentStreak == 1 ? "You started! Come back tomorrow." : "Keep it going!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
    }

    // MARK: Calendar

    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This month")
                .font(.headline)
                .fontWeight(.bold)

            ActivityCalendarGrid(records: records)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
    }

    // MARK: Wrong words

    private var wrongSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Review these", systemImage: "arrow.circlepath")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 8) {
                ForEach(wrongPhrases, id: \.id) { phrase in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(phrase.userEntry)
                                .font(.body)
                                .fontWeight(.semibold)
                            Text(phrase.explanation)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.secondary.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
    }

    // MARK: Done button

    private var doneButton: some View {
        Button(action: onDone) {
            Text("Done")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.72, blue: 0.65),
                            Color(red: 0.1, green: 0.7, blue: 0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.35), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Activity Calendar Grid

struct ActivityCalendarGrid: View {
    let records: [QuizRecord]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    private let dayLetters = ["M", "T", "W", "T", "F", "S", "S"]

    private var days: [CalendarDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else { return [] }

        let weekdayOffset = (calendar.component(.weekday, from: firstDay) + 5) % 7

        let recordMap = Dictionary(
            records.map { (calendar.startOfDay(for: $0.date), $0) },
            uniquingKeysWith: { first, _ in first }
        )

        var result: [CalendarDay] = Array(repeating: CalendarDay(date: nil, record: nil), count: weekdayOffset)

        for day in range {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else { continue }
            let isFuture = date > today
            result.append(CalendarDay(date: date, record: isFuture ? nil : recordMap[date], isFuture: isFuture))
        }
        return result
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                ForEach(dayLetters, id: \.self) { letter in
                    Text(letter)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                    CalendarDot(day: day)
                }
            }
        }
    }
}

struct CalendarDay {
    let date: Date?
    let record: QuizRecord?
    var isFuture: Bool = false

    var isToday: Bool {
        guard let date else { return false }
        return Calendar.current.isDateInToday(date)
    }
}

struct CalendarDot: View {
    let day: CalendarDay

    var body: some View {
        Circle()
            .fill(fillColor)
            .frame(width: 28, height: 28)
            .overlay(
                Circle()
                    .stroke(day.isToday ? Color(red: 0.08, green: 0.72, blue: 0.65) : Color.clear, lineWidth: 2)
            )
    }

    private var fillColor: Color {
        guard day.date != nil, !day.isFuture else {
            return Color.secondary.opacity(0.08)
        }
        guard let record = day.record else {
            return Color.secondary.opacity(0.12)
        }
        let ratio = Double(record.score) / Double(max(record.total, 1))
        if ratio >= 0.8 {
            return Color(red: 0.08, green: 0.72, blue: 0.65)
        } else {
            return Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.4)
        }
    }
}
