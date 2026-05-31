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

    var icon: String {
        switch self {
        case .alphabetical: return "textformat.abc"
        case .byDate: return "calendar"
        case .byCategory: return "folder"
        }
    }

    var localizedName: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
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
    @State private var selectedCalendarDate: Date? = nil
    @State private var selectedCategoryTitle: String? = nil
    
    var filteredPhrases: [LearnElement] {
        testPhrases.filter { phrase in
            let matchesSearch = searchText.isEmpty ||
                phrase.userEntry.localizedCaseInsensitiveContains(searchText) ||
                phrase.explanation.localizedCaseInsensitiveContains(searchText)
            return matchesSearch
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
                    "\(category.emoji) \(category.name)"
                } else {
                    "📝 No Category"
                }
            }
            .mapValues { phrases in
                phrases.sorted { $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending }
            }
            .sorted { lhs, rhs in
                if lhs.key.contains("No Category") { return false }
                if rhs.key.contains("No Category") { return true }
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
            ZStack {
                // Background gradient iOS 18
                Color(.systemGroupedBackground).ignoresSafeArea()
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // HEADER
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Collection")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("\(filteredPhrases.count) \(filteredPhrases.count == 1 ? "word" : "words")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        // Filter button con glass effect
                        Menu {
                            Picker("Order", selection: $selectedOrder) {
                                ForEach(CollectionOrder.allCases, id: \.self) { order in
                                    Label(order.localizedName, systemImage: order.icon)
                                        .tag(order)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
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
                                .clipShape(Circle())
                                .shadow(color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    
                    // SEARCH BAR — only relevant in alphabetical mode
                    if selectedOrder == .alphabetical {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        TextField("Search for a word or phrase", text: $searchText)
                            .font(.body)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary.opacity(0.6))
                            }
                        }
                    }
                    .padding(14)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    } // end search bar condition

                    // CONTENT
                    ScrollView {
                        VStack(spacing: 16) {
                            if isLibraryCompletelyEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "books.vertical")
                                        .font(.system(size: 60))
                                        .foregroundColor(.secondary.opacity(0.5))

                                    VStack(spacing: 8) {
                                        Text("Your collection is empty")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)

                                        Text("Start adding words to build your vocabulary")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 40)
                                .padding(.top, 40)

                            } else if isFilteredEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "magnifyingglass.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.secondary.opacity(0.5))

                                    VStack(spacing: 8) {
                                        Text("No results found")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)

                                        Text("Try searching for something else")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 40)
                                .padding(.top, 40)

                            } else if selectedOrder == .byDate {
                                CollectionCalendarView(
                                    phrases: filteredPhrases,
                                    selectedDate: $selectedCalendarDate
                                )
                                .padding(.top, 8)

                            } else if selectedOrder == .byCategory {
                                CollectionCategoryGridView(
                                    phrases: filteredPhrases,
                                    selectedCategory: .constant(nil)
                                )
                                .padding(.top, 8)

                            } else {
                                ForEach(groupedPhrases, id: \.title) { group in
                                    VStack(spacing: 12) {
                                        // Section header UNIFICADO (colapsable para todos)
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                if expandedCategories.contains(group.title) {
                                                    expandedCategories.remove(group.title)
                                                } else {
                                                    expandedCategories.insert(group.title)
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 12) {
                                                Image(systemName: expandedCategories.contains(group.title)
                                                      ? "chevron.down" : "chevron.right")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.accentColor)

                                                Text(group.title)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.primary)

                                                Spacer()

                                                Text("\(group.phrases.count)")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.secondary)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(
                                                        Capsule()
                                                            .fill(Color.secondary.opacity(0.15))
                                                    )
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.horizontal, 24)

                                        // Words list (solo si está expandido)
                                        if expandedCategories.contains(group.title) {
                                            VStack(spacing: 10) {
                                                ForEach(group.phrases, id: \.self) { phrase in
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
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .confirmationDialog(LocalizedStringKey("Choose Order"), isPresented: $showingFilterOptions, titleVisibility: .visible) {
            Button(LocalizedStringKey("Alphabetical")) { selectedOrder = .alphabetical; selectedCalendarDate = nil }
            Button(LocalizedStringKey("By Date")) { selectedOrder = .byDate }
            Button(LocalizedStringKey("By Category")) { selectedOrder = .byCategory; selectedCalendarDate = nil }
            Button(LocalizedStringKey("Cancel"), role: .cancel) { }
        }
        .onChange(of: selectedOrder) { _, newOrder in
            if newOrder != .byDate { selectedCalendarDate = nil }
            if newOrder != .byCategory { selectedCategoryTitle = nil }
            if newOrder != .alphabetical { searchText = "" }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CollectionView()
}
