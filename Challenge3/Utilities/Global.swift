//
//  Global.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import Foundation
import SwiftUI
import UIKit

enum Global {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
}

extension Character {
    var isEmoji: Bool {
        return String(self).range(of: #"[\p{Emoji}]"#, options: .regularExpression) != nil
    }
}


class EmojiTextField: UITextField {

    
    override var textInputContextIdentifier: String? { "" } 

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}


struct EmojiTextFieldWrapper: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont // Add this to customize the font

    func makeUIView(context: Context) -> EmojiTextField {
        let textField = EmojiTextField()
        textField.delegate = context.coordinator
        textField.font = font // Apply the font
        return textField
    }

    func updateUIView(_ uiView: EmojiTextField, context: Context) {
        uiView.text = text
        uiView.font = font // Ensure the font is updated if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextFieldWrapper

        init(_ parent: EmojiTextFieldWrapper) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

