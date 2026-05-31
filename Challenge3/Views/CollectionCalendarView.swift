import SwiftUI

struct CollectionCalendarView: View {
    let phrases: [LearnElement]
    @Binding var selectedDate: Date?

    @State private var displayedMonth: Date = Calendar.current.startOfDay(for: .now)

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let dayHeaders = ["M", "T", "W", "T", "F", "S", "S"]

    // Words grouped by start-of-day
    private var wordsByDay: [Date: [LearnElement]] {
        Dictionary(grouping: phrases) { calendar.startOfDay(for: $0.dateAdded) }
    }

    private var wordsOnSelectedDate: [LearnElement] {
        guard let date = selectedDate else { return [] }
        return wordsByDay[calendar.startOfDay(for: date)] ?? []
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    private var days: [CalendarDayItem] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))
        else { return [] }

        let offset = (calendar.component(.weekday, from: firstDay) + 5) % 7
        var result: [CalendarDayItem] = Array(repeating: CalendarDayItem(date: nil), count: offset)

        for day in range {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else { continue }
            let count = wordsByDay[date]?.count ?? 0
            result.append(CalendarDayItem(date: date, wordCount: count))
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            calendarCard
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            wordList
        }
    }

    // MARK: - Calendar card

    private var calendarCard: some View {
        VStack(spacing: 16) {
            monthHeader

            // Day of week labels
            HStack(spacing: 0) {
                ForEach(dayHeaders, id: \.self) { label in
                    Text(label)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, item in
                    if let date = item.date {
                        DayCell(
                            date: date,
                            wordCount: item.wordCount,
                            isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                            isToday: calendar.isDateInToday(date)
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if let sel = selectedDate, calendar.isDate(sel, inSameDayAs: date) {
                                    selectedDate = nil
                                } else {
                                    selectedDate = date
                                }
                            }
                        }
                    } else {
                        Color.clear.frame(height: 40)
                    }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.secondary.opacity(0.12), lineWidth: 1))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
        .gesture(
            DragGesture(minimumDistance: 40, coordinateSpace: .local)
                .onEnded { value in
                    let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
                    guard isHorizontal else { return }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        if value.translation.width < 0 {
                            // Swipe left → next month
                            let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                            if next <= calendar.startOfDay(for: .now) {
                                displayedMonth = next
                                selectedDate = nil
                            }
                        } else {
                            // Swipe right → previous month
                            displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                            selectedDate = nil
                        }
                    }
                }
        )
    }

    // MARK: - Month header

    private var monthHeader: some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                    selectedDate = nil
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.08, green: 0.72, blue: 0.65))
                    .frame(width: 36, height: 36)
                    .background(Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(monthTitle)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                    if next <= calendar.startOfDay(for: .now) {
                        displayedMonth = next
                        selectedDate = nil
                    }
                }
            } label: {
                let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                let isFuture = next > calendar.startOfDay(for: .now)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isFuture ? Color.secondary.opacity(0.3) : Color(red: 0.08, green: 0.72, blue: 0.65))
                    .frame(width: 36, height: 36)
                    .background(isFuture ? Color.clear : Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled({
                let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                return next > calendar.startOfDay(for: .now)
            }())
        }
    }

    private var monthHasWords: Bool {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))
        else { return false }
        return range.contains(where: { day in
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else { return false }
            return (wordsByDay[date]?.isEmpty == false)
        })
    }

    // MARK: - Word list

    @ViewBuilder
    private var wordList: some View {
        if !monthHasWords {
            VStack(spacing: 8) {
                Text("No words added in \(monthTitle)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Label("Try an earlier month", systemImage: "arrow.left")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.08, green: 0.72, blue: 0.65))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .transition(.opacity)

        } else if let date = selectedDate {
            VStack(alignment: .leading, spacing: 12) {
                // Date header
                HStack {
                    Text(formattedDate(date))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Spacer()

                    Text("\(wordsOnSelectedDate.count) \(wordsOnSelectedDate.count == 1 ? "word" : "words")")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.secondary.opacity(0.12)))
                }
                .padding(.horizontal, 24)

                if wordsOnSelectedDate.isEmpty {
                    Text("No words added this day")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                } else {
                    VStack(spacing: 10) {
                        ForEach(wordsOnSelectedDate, id: \.id) { phrase in
                            NavigationLink {
                                CollectionDetailView(phrase: phrase)
                            } label: {
                                WordElementView(phrase: phrase, isCollection: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .opacity
            ))
            .padding(.bottom, 40)

        } else {
            Text("Tap a day to see words")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .transition(.opacity)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let date: Date
    let wordCount: Int
    let isSelected: Bool
    let isToday: Bool

    private let calendar = Calendar.current

    private var isFuture: Bool {
        date > calendar.startOfDay(for: .now)
    }

    private var intensity: Double {
        guard wordCount > 0 else { return 0 }
        return min(0.4 + Double(wordCount) * 0.12, 1.0)
    }

    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(cellBackground)
                .frame(width: 38, height: 38)

            // Today ring
            if isToday && !isSelected {
                Circle()
                    .stroke(Color(red: 0.08, green: 0.72, blue: 0.65), lineWidth: 2)
                    .frame(width: 38, height: 38)
            }

            // Day number
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 15, weight: isSelected || isToday ? .bold : wordCount > 0 ? .semibold : .regular))
                .foregroundColor(textColor)
        }
        .frame(height: 40)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
    }

    private var cellBackground: Color {
        if isSelected {
            return Color(red: 0.08, green: 0.72, blue: 0.65)
        }
        if wordCount > 0 && !isFuture {
            return Color(red: 0.08, green: 0.72, blue: 0.65).opacity(intensity * 0.25)
        }
        return Color.clear
    }

    private var textColor: Color {
        if isSelected { return .white }
        if isFuture { return Color.secondary.opacity(0.3) }
        if wordCount > 0 { return Color(red: 0.08, green: 0.72, blue: 0.65) }
        return .primary.opacity(0.6)
    }
}

// MARK: - Model

struct CalendarDayItem {
    let date: Date?
    var wordCount: Int = 0
}
