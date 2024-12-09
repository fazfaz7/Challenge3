import SwiftUI
import SwiftData

enum PhraseType: String, CaseIterable {
    case all = "All"
    case howToSay = "How to Say"
    case newPhrase = "New Phrase"
    
    var description: String {
        switch self {
        case .all: return "All"
        case .howToSay: return "How to Say"
        case .newPhrase: return "New Phrase"
        }
    }
}

struct CollectionView: View {
    @Environment(\.modelContext) var modelContext
    @Query(
        filter: #Predicate { $0.isCompleted == true },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var testPhrases: [LearnElement]
    
    @State private var searchText = ""
    @State private var selectedType: PhraseType = .all

    var filteredPhrases: [LearnElement] {
        testPhrases.filter { phrase in
            let matchesSearch = searchText.isEmpty || phrase.userEntry.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedType == .all ||
            (selectedType == .howToSay && phrase.learnType == .howToSay) ||
            (selectedType == .newPhrase && phrase.learnType == .newPhrase)
            return matchesSearch && matchesType
        }
    }
    
    var groupedPhrasesByDay: [(date: Date, phrases: [LearnElement])] {
        Dictionary(grouping: filteredPhrases) { phrase in
            // Strip time to group only by day
            Calendar.current.startOfDay(for: phrase.dateAdded)
        }
        .sorted { $0.key > $1.key } // Sort by Date in descending order
        .map { (date: $0.key, phrases: $0.value) } // Convert to an array of tuples
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Collection")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Inline Filter Picker
                    Picker("Filter", selection: $selectedType) {
                        ForEach(PhraseType.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())  // Compact style with menu dropdown
                    .padding(.horizontal, 5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .frame(width: Global.screenWidth*0.85)
                
                
                TextField("Search for a word or phrase", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: Global.screenWidth*0.85)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        ForEach(groupedPhrasesByDay, id: \.date) { group in
                            Section(header: Text(formatDate(group.date))
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .padding(.top, 10)
                            ) {
                                ForEach(group.phrases, id: \.self) { phrase in
                                    NavigationLink {
                                        CollectionDetailView(phrase: phrase)
                                    } label: {
                                        WordElementView(phrase: phrase, isCollection: true)
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }

}

#Preview {
    CollectionView()
}
