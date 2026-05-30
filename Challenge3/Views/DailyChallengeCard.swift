import SwiftUI
import SwiftData

struct DailyChallengeCard: View {
    let phrases: [LearnElement]
    let language: String

    @EnvironmentObject private var streakStore: QuizStreakStore
    @Query(sort: \QuizRecord.date, order: .reverse) private var allRecords: [QuizRecord]
    @State private var showQuiz = false

    private var stats: QuizLanguageStats { streakStore.getStats(for: language) }
    private var records: [QuizRecord] { allRecords.filter { $0.language == language } }
    private var hasEnoughWords: Bool { QuizEngine.canGenerateQuiz(from: phrases) }
    private var flag: String { LanguageHelper.flag(from: language) }

    private var todayRecord: QuizRecord? {
        let today = Calendar.current.startOfDay(for: .now)
        return records.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    var body: some View {
        Group {
            if !hasEnoughWords {
                lockedCard
            } else if streakStore.completedToday(for: language) {
                completedCard
            } else {
                availableCard
            }
        }
        .fullScreenCover(isPresented: $showQuiz) {
            DailyQuizView(phrases: phrases, language: language) { _, _ in
                streakStore.recordCompletion(for: language)
                showQuiz = false
            }
        }
    }

    // MARK: - Available

    private var availableCard: some View {
        Button { showQuiz = true } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.08, green: 0.72, blue: 0.65),
                                    Color(red: 0.1, green: 0.7, blue: 0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Daily Challenge")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    HStack(spacing: 6) {
                        Text("5 questions · \(flag)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if stats.currentStreak > 0 {
                            Text("·")
                                .foregroundColor(.secondary)
                                .font(.caption)

                            Label("\(stats.currentStreak) day streak", systemImage: "flame.fill")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                                )
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.08, green: 0.72, blue: 0.65))
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.5),
                                Color(red: 0.1, green: 0.7, blue: 0.8).opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(color: Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.15), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Completed

    private var completedCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                Color(red: 0.1, green: 0.7, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Daily Challenge · \(flag)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                HStack(spacing: 6) {
                    if let record = todayRecord {
                        Text("\(record.score)/\(record.total)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color(red: 0.08, green: 0.72, blue: 0.65)))
                    }

                    Label("\(stats.currentStreak) day streak", systemImage: "flame.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                        )
                }
            }

            Spacer()
        }
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.secondary.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 3)
    }

    // MARK: - Locked

    private var lockedCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 48, height: 48)

                Image(systemName: "lock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Daily Challenge · \(flag)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)

                Text("Add \(QuizEngine.minimumWords)+ words to unlock")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.7))
            }

            Spacer()
        }
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.secondary.opacity(0.1), lineWidth: 1))
        .opacity(0.7)
    }
}

// MARK: - 7-day strip

struct WeekStripView: View {
    let records: [QuizRecord]

    private var last7Days: [(date: Date, record: QuizRecord?)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let recordMap = Dictionary(
            records.map { (calendar.startOfDay(for: $0.date), $0) },
            uniquingKeysWith: { first, _ in first }
        )
        return (0..<7).reversed().compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return (date: date, record: recordMap[date])
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(last7Days.enumerated()), id: \.offset) { _, entry in
                VStack(spacing: 4) {
                    Circle()
                        .fill(dotColor(for: entry.record, date: entry.date))
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .stroke(
                                    Calendar.current.isDateInToday(entry.date)
                                        ? Color(red: 0.08, green: 0.72, blue: 0.65)
                                        : Color.clear,
                                    lineWidth: 2
                                )
                        )

                    Text(shortDayLabel(for: entry.date))
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func dotColor(for record: QuizRecord?, date: Date) -> Color {
        guard date <= Calendar.current.startOfDay(for: .now) else { return Color.secondary.opacity(0.08) }
        guard let record else { return Color.secondary.opacity(0.15) }
        let ratio = Double(record.score) / Double(max(record.total, 1))
        return ratio >= 0.8
            ? Color(red: 0.08, green: 0.72, blue: 0.65)
            : Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.4)
    }

    private func shortDayLabel(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return String(f.string(from: date).prefix(1))
    }
}
