//
//  HelpView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("help_support".localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                
                Text("help_description".localized)
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    BulletPoint(text: "simplified_navigation".localized)
                    BulletPoint(text: "consistent_language".localized)
                    BulletPoint(text: "improved_form_design".localized)
                    BulletPoint(text: "better_feedback".localized)
                    BulletPoint(text: "reduced_permissions".localized)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                Text("faq_title".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                FAQItem(
                    question: "faq_register_question".localized,
                    answer: "faq_register_answer".localized
                )
                
                FAQItem(
                    question: "faq_track_question".localized,
                    answer: "faq_track_answer".localized
                )
                
                FAQItem(
                    question: "faq_forgot_id_question".localized,
                    answer: "faq_forgot_id_answer".localized
                )
                
                FAQItem(
                    question: "faq_language_question".localized,
                    answer: "faq_language_answer".localized
                )
                
                Divider()
                    .padding(.vertical)
                
                Text("contact_info".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    ContactItem(iconName: "envelope", text: "support@jansunwai.gov.in")
                    ContactItem(iconName: "phone", text: "toll_free".localized + ": 1800-XXX-XXXX")
                    ContactItem(iconName: "building", text: "ministry_name".localized)
                }
                .padding(.horizontal)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("close".localized)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("help_support".localized, displayMode: .inline)
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.headline)
            Text(text)
                .font(.body)
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.headline)
            
            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ContactItem: View {
    let iconName: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    NavigationView {
        HelpView()
            .environmentObject(LanguageManager.shared)
    }
} 