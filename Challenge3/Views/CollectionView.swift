import SwiftUI
import SwiftData

enum PhraseType: String, CaseIterable {
    case howToSay = "How to Say"
    case newPhrase = "New Phrase"
    
    var description: String {
        switch self {
        case .howToSay: return "How to Say"
        case .newPhrase: return "New Phrase"
        }
    }
}

enum CollectionOrder: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case byDate = "By Date"
    case byCategory = "By Category"
}

struct CollectionView: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \LearnElement.dateAdded, order: .reverse) var allPhrases: [LearnElement]
    
    var testPhrases: [LearnElement] {
        allPhrases.filter { $0.isCompleted && $0.language == selectedLanguage }
    }
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"

    @State private var searchText = ""
    @State private var selectedType: PhraseType = .newPhrase
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var selectedOrder: CollectionOrder = .alphabetical
    @State private var showingFilterOptions = false
    @State private var expandedCategories: Set<String> = []
    

    var filteredPhrases: [LearnElement] {
        testPhrases.filter { phrase in
            let matchesSearch = searchText.isEmpty || phrase.userEntry.localizedCaseInsensitiveContains(searchText)
            let matchesType =
            (selectedType == .howToSay && phrase.learnType == .howToSay) ||
            (selectedType == .newPhrase && phrase.learnType == .newPhrase)
            return matchesSearch //&& matchesType
        }
    }
    
    var groupedPhrases: [(title: String, phrases: [LearnElement])] {
        switch selectedOrder {
        case .alphabetical:
            return Dictionary(grouping: filteredPhrases) { phrase in
                String(phrase.userEntry.prefix(1)).uppercased()
            }
            .mapValues { phrases in
                phrases.sorted { $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending }
            }
            .sorted { $0.key < $1.key }
            .map { (title: $0.key, phrases: $0.value) }
            
        case .byDate:
            return Dictionary(grouping: filteredPhrases) { phrase in
                Calendar.current.startOfDay(for: phrase.dateAdded)
            }
            .mapValues { phrases in
                phrases.sorted { $0.dateAdded > $1.dateAdded }
            }
            .sorted { $0.key > $1.key }
            .map { (title: formatDate($0.key), phrases: $0.value) }
            
        case .byCategory:
            return Dictionary(grouping: filteredPhrases) { phrase in
                if let category = phrase.category {
                    "\(category.name) \(category.emoji) "
                } else {
                    "No Category"
                }
            }
            .mapValues { phrases in
                phrases.sorted { $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending }
            }
            .sorted { lhs, rhs in
                if lhs.key == "No Category" { return false }
                if rhs.key == "No Category" { return true }
                return lhs.key < rhs.key
            }

            .map { (title: $0.key, phrases: $0.value) }


        }
        


        
       

        
        
    }
    
    var isLibraryCompletelyEmpty: Bool {
        testPhrases.isEmpty
    }

    var isFilteredEmpty: Bool {
        !testPhrases.isEmpty && filteredPhrases.isEmpty
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
                    
                    Menu {
                        Picker("Order", selection: $selectedOrder) {
                            ForEach(CollectionOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                        .pickerStyle(.inline) // mostrerà le scelte come una lista
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }

                }
                .frame(width: Global.screenWidth*0.85)
                
                
                TextField("Search for a word or phrase", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: Global.screenWidth*0.85)
                
               
                        
                        if isLibraryCompletelyEmpty {
                            Spacer()
                            VStack(alignment: .center, spacing: 10) {
                                Spacer()
                                Image(systemName: "books.vertical")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                
                                Text("Your collection is empty")
                                    .fontWeight(.semibold)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text("Save the words and phrases you discover and build your vocabulary from the things you live, see, and hear every day.")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }.padding()
                                .frame(maxWidth: Global.screenWidth*0.85)
                           Spacer()
                        } else if isFilteredEmpty {
                            VStack(alignment: .center, spacing: 10) {
                                Spacer()
                                
                                Image(systemName: "magnifyingglass.circle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                
                                Text("No results found")
                                    .fontWeight(.semibold)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text("Try searching for something else!")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: Global.screenWidth * 0.85)

                        } else {
                            
                            ScrollView {
                                VStack(spacing: 20) {
                            
                            ForEach(groupedPhrases, id: \.title) { group in
                                Section(header:
                                            HStack {
                                    if selectedOrder == .byCategory {
                                        Button {
                                            if expandedCategories.contains(group.title) {
                                                expandedCategories.remove(group.title)
                                            } else {
                                                expandedCategories.insert(group.title)
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: expandedCategories.contains(group.title) ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                                                    .foregroundColor(.accentColor)
                                                Text(group.title)
                                                    .font(selectedOrder == .alphabetical ? .title2 : .title3)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.accentColor)
                                            }
                                        }
                                    } else {
                                        HStack {
                                            Text(group.title)
                                                .font(selectedOrder == .alphabetical ? .title2 : .title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                    Spacer()
                                }
                                    .padding(.top, 10)
                                ) {
                                    if selectedOrder != .byCategory || expandedCategories.contains(group.title) {
                                        ForEach(group.phrases, id: \.self) { phrase in
                                            NavigationLink {
                                                CollectionDetailView(phrase: phrase)
                                            } label: {
                                                WordElementView(phrase: phrase, isCollection: true)
                                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                            }
                                        }
                                    }
                                }
                                .frame(width: Global.screenWidth*0.85)
                            }
                            
                        }

                        
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.40), value: expandedCategories)
                }
            }
            .padding(.top)
            
        }
        
        .confirmationDialog("Choose Order", isPresented: $showingFilterOptions, titleVisibility: .visible) {
            Button("Alphabetical") { selectedOrder = .alphabetical }
            Button("By Date") { selectedOrder = .byDate }
            Button("By Category") {selectedOrder = .byCategory}
            Button("Cancel", role: .cancel) { }
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
