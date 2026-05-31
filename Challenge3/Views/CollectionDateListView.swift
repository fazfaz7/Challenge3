import SwiftUI

private struct DateSection: Identifiable {
    var id: String { title }
    let title: String
    let phrases: [LearnElement]
}

struct CollectionDateListView: View {
    let phrases: [LearnElement]

    private let calendar = Calendar.current

    private var sections: [DateSection] {
        let sorted = phrases.sorted { $0.dateAdded > $1.dateAdded }

        var today: [LearnElement] = []
        var yesterday: [LearnElement] = []
        var thisWeek: [LearnElement] = []
        var byMonth: [Date: [LearnElement]] = [:]

        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: .now))!

        for phrase in sorted {
            let d = phrase.dateAdded
            if calendar.isDateInToday(d) {
                today.append(phrase)
            } else if calendar.isDateInYesterday(d) {
                yesterday.append(phrase)
            } else if d >= weekStart {
                thisWeek.append(phrase)
            } else {
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: d))!
                byMonth[monthStart, default: []].append(phrase)
            }
        }

        var result: [DateSection] = []
        if !today.isEmpty     { result.append(DateSection(title: "Today", phrases: today)) }
        if !yesterday.isEmpty { result.append(DateSection(title: "Yesterday", phrases: yesterday)) }
        if !thisWeek.isEmpty  { result.append(DateSection(title: "This week", phrases: thisWeek)) }

        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        for monthStart in byMonth.keys.sorted(by: >) {
            result.append(DateSection(title: f.string(from: monthStart), phrases: byMonth[monthStart]!))
        }

        return result
    }

    var body: some View {
        VStack(spacing: 24) {
            ForEach(sections) { section in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(section.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(section.phrases.count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.secondary.opacity(0.12)))
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(section.phrases, id: \.id) { phrase in
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
        }
        .padding(.top, 8)
        .padding(.bottom, 40)
    }
}
