//
//  LanguageSelectorView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct LanguageSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    @ObservedObject private var languageManager = LanguageManager.shared
    
    // Language options showing only the native language name
    private let languageOptions: [(language: Language, displayName: String)] = [
        (Language.english, "English"),
        (Language.hindi, "हिन्दी")
    ]
    
    // Additional languages (not functional)
    private let additionalLanguages = [
        "தமிழ்",       // Tamil
        "ગુજરાતી",      // Gujarati
        "मराठी",       // Marathi
        "বাংলা",        // Bengali
        "ਪੰਜਾਬੀ"        // Punjabi
    ]
    
    var body: some View {
        NavigationView {
            List {
                // Functional languages
                ForEach(languageOptions, id: \.language) { option in
                    Button(action: {
                        languageManager.setLanguage(option.language)
                        isPresented = false
                    }) {
                        HStack {
                            Text(option.displayName)
                                .font(.headline)
                            
                            Spacer()
                            
                            if languageManager.currentLanguage == option.language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Additional non-functional languages
                Section(header: Text("Other Languages")) {
                    ForEach(additionalLanguages, id: \.self) { language in
                        HStack {
                            Text(language)
                                .font(.headline)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitle("select_language".localized, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Text("close".localized)
                    .bold()
                    .foregroundColor(.black)
            })
        }
    }
}

#Preview {
    LanguageSelectorView(isPresented: .constant(true))
} 