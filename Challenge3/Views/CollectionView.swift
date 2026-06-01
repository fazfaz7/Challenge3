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
    case dateList = "By Date"
    case alphabetical = "A–Z"
    case byCategory = "By Category"
    case calendar = "Calendar"

    var icon: String {
        switch self {
        case .dateList: return "clock"
        case .alphabetical: return "textformat.abc"
        case .byCategory: return "folder"
        case .calendar: return "calendar"
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
    @State private var selectedOrder: CollectionOrder = .dateList
    @State private var selectedCalendarDate: Date? = nil
    
    var filteredPhrases: [LearnElement] {
        testPhrases.filter { phrase in
            let matchesSearch = searchText.isEmpty ||
                phrase.userEntry.localizedCaseInsensitiveContains(searchText) ||
                phrase.explanation.localizedCaseInsensitiveContains(searchText)
            return matchesSearch
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
                    
                    // SEARCH BAR — hidden in calendar mode
                    if selectedOrder != .calendar {
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
                                    Text(LanguageHelper.flag(from: selectedLanguage))
                                        .font(.system(size: 52))

                                    VStack(spacing: 8) {
                                        Text("No \(LanguageHelper.getLocalizedLanguageName(selectedLanguage)) words yet")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)

                                        Text("Words you mark as learned will appear here")
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

                            } else if selectedOrder == .dateList {
                                CollectionDateListView(phrases: filteredPhrases)
                                    .padding(.top, 8)

                            } else if selectedOrder == .alphabetical {
                                CollectionAlphabeticalGridView(phrases: filteredPhrases)
                                    .padding(.top, 8)

                            } else if selectedOrder == .byCategory {
                                CollectionCategoryGridView(
                                    phrases: filteredPhrases,
                                    selectedCategory: .constant(nil)
                                )
                                .padding(.top, 8)

                            } else {
                                CollectionCalendarView(
                                    phrases: filteredPhrases,
                                    selectedDate: $selectedCalendarDate
                                )
                                .padding(.top, 8)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onChange(of: selectedOrder) { _, newOrder in
            if newOrder != .calendar { selectedCalendarDate = nil }
            if newOrder == .calendar { searchText = "" }
        }
    }
}

#Preview {
    CollectionView()
}
