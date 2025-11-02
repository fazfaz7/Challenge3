//
//  SelectCategoryView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 07/12/24.
//

import SwiftUI
import SwiftData

struct SelectCategoryView: View {
    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) var dismiss
    @State var showAddCategoryModal: Bool = false
    @Environment(\.modelContext) var modelContext
    @Query(
        sort: \Category.dateAdded,
        animation: .default
    ) var myCategories: [Category]
    @State private var showDeleteAlert = false
    @State private var categoryToDelete: Category? = nil
    
    var body: some View {
        ZStack {
            // Background gradient iOS 18
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.98, blue: 0.99),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                Text("Choose a category")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                
                // Lista de categorías
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(myCategories, id: \.id) { category in
                            CategoryCardView(
                                category: category,
                                isSelected: selectedCategory?.id == category.id,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCategory = category
                                    }
                                },
                                onDelete: {
                                    categoryToDelete = category
                                    showDeleteAlert = true
                                }
                            )
                        }
                        
                        // Botón Add Category
                        Button {
                            showAddCategoryModal = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                
                                Text("Add new category")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 1.5)
                            )
                            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100) // Space for button
                }
                
                Spacer()
            }
            
            // Botón flotante Select category
            VStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 10) {
                        Text("Select category")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                Color(red: 0.1, green: 0.7, blue: 0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .accentColor.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showAddCategoryModal) {
            AddCategoryView()
                .presentationDetents([.height(280)])
        }
        .alert("Delete Category", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let categoryToDelete = categoryToDelete {
                    withAnimation {
                        do {
                            let descriptor = FetchDescriptor<LearnElement>()
                            let allElements = try modelContext.fetch(descriptor)
                            
                            for element in allElements where element.category?.id == categoryToDelete.id {
                                element.category = nil
                            }
                            
                            modelContext.delete(categoryToDelete)
                            try modelContext.save()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
            }
        } message: {
            if let categoryToDelete = categoryToDelete {
                Text("All words in '\(categoryToDelete.name)' will become uncategorized. This cannot be undone.")
            } else {
                Text("Unknown category.")
            }
        }
    }
}

// MARK: - Category Card Component
struct CategoryCardView: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 16) {
                Text(category.emoji)
                    .font(.system(size: 32))
                
                Text(category.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Checkmark cuando está seleccionada
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.accentColor : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Category", systemImage: "trash.fill")
            }
        }
    }
}

// MARK: - Add Category View
struct AddCategoryView: View {
    @State var categoryName: String = ""
    @State var emojiText: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.98, blue: 0.99),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Custom Category")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                // Emoji + Name input
                HStack(spacing: 16) {
                    // Emoji picker
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 1.5)
                            )
                            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                        
                        // TextField centrado
                        EmojiTextFieldWrapper(
                            text: $emojiText,
                            font: UIFont.systemFont(ofSize: 36)
                        )
                        .frame(width: 70, height: 70)  // ✅ Mismo tamaño que el círculo
                        
                        // Placeholder si está vacío
                        if emojiText.isEmpty {
                            Image(systemName: "face.smiling")
                                .font(.system(size: 30))
                                .foregroundColor(.secondary.opacity(0.3))
                                .allowsHitTesting(false)
                        }
                    }
                    
                    // Name TextField
                    TextField("Category Name", text: $categoryName)
                        .font(.body)
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    isNameFieldFocused ? Color.accentColor : Color.secondary.opacity(0.2),
                                    lineWidth: isNameFieldFocused ? 2 : 1
                                )
                        )
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                        .focused($isNameFieldFocused)
                }
                
                // Add button
                Button {
                    if !categoryName.isEmpty && !emojiText.isEmpty {
                        withAnimation {
                            let newCategory = Category(name: categoryName, emoji: emojiText)
                            modelContext.insert(newCategory)
                            try? modelContext.save()
                        }
                        dismiss()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text("Add category")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "plus.circle.fill")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Group {
                            if categoryName.isEmpty || emojiText.isEmpty {
                                Color.gray.opacity(0.4)
                            } else {
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.08, green: 0.72, blue: 0.65),
                                        Color(red: 0.1, green: 0.7, blue: 0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(
                        color: (categoryName.isEmpty || emojiText.isEmpty) ? .clear : .accentColor.opacity(0.3),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .disabled(categoryName.isEmpty || emojiText.isEmpty)
            }
            .padding(24)
        }
        .onChange(of: emojiText) { oldValue, newValue in
            if let firstChar = newValue.first, firstChar.isEmoji {
                emojiText = String(firstChar)
            } else {
                emojiText = ""
            }
        }
    }
}
