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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose a category")
                .font(.title2)
                .fontWeight(.semibold)
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(myCategories, id: \.id) { category in
                        VStack {
                            HStack {
                                Text(category.emoji)
                                    .font(.title)
                                    .padding(.trailing,8)
                                Text(category.name)
                                Spacer()
                            }.padding(12)
                                .font(.title3)
                                .frame(width: Global.screenWidth*0.85)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10).fill(.clear)
                                        .stroke(selectedCategory == category ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 4)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    withAnimation {
                                        selectedCategory = category
                                    }
                                }
                            
                            
                        }
                    }
                    
                    HStack {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }.padding(12)
                        .font(.title3)
                        .frame(width: Global.screenWidth*0.85, height: 55)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).fill(.secondary.opacity(0.2))
                            
                        }
                        .onTapGesture {
                            showAddCategoryModal = true
                        }
                }
                
            }
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Select category")
                            .foregroundStyle(.white)
                    }.padding(12)
                        .font(.title3)
                        .frame(width: Global.screenWidth*0.85, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.accent))
                        .shadow(radius: 1)
                }
            
        }.padding()
            .sheet(isPresented: $showAddCategoryModal) {
                AddCategoryView()
                    .presentationDetents([.fraction(0.3)])
            }
    }
}


struct AddCategoryView: View {
    @State var categoryName: String = ""
    @State var emojiText: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Custom Category")
                .font(.title)
                .fontWeight(.medium)
            
            HStack {
                
                VStack() {
                    
                    HStack(spacing: 20) {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(.gray.opacity(0.3))
                            .overlay {
                                EmojiTextFieldWrapper(text: $emojiText, font: UIFont.systemFont(ofSize: 30))
                                    .padding(30)
                            }
                        
                    
                    
                    TextField("Category Name",text: $categoryName)
                            .padding(.horizontal)
                            .padding(.vertical,10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.clear))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).fill(.clear)
                                .stroke(Color.gray, lineWidth: 1)
                        }
                        .frame(width: Global.screenWidth*0.65)
                    }.frame(width: Global.screenWidth*0.85)
                }
                
            }
            
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation{
                        if !categoryName.isEmpty && !emojiText.isEmpty {
                            modelContext.insert(Category(name: categoryName, emoji: emojiText))
                        try? modelContext.save()
                        }
                    }
                }
                dismiss()
            } label: {
                HStack {
                    Text("Add category")
                        .foregroundStyle(.white)
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }.padding(12)
                    .font(.title3)
                    .frame(width: Global.screenWidth*0.85, height: 55)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.accent))
                    .shadow(radius: 1)
            }
        }
        
        .frame(width: Global.screenWidth*0.85)
        .padding()
        .onChange(of: emojiText) { oldValue, newValue in
            if let firstChar = newValue.first, firstChar.isEmoji {
                emojiText = String(firstChar)
            } else {
                emojiText = ""
            }
        }
    }
}
