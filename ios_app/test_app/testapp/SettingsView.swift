import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @StateObject private var languageManager = LanguageManager.shared
    
    // Settings states
    @State private var receivePushNotifications = true
    @State private var receiveEmailNotifications = true
    @State private var receiveSmsNotifications = true
    @State private var receiveStatusUpdates = true
    @State private var showingLanguageSelector = false
    @State private var showingAboutSheet = false
    
    // For feedback in TrackComplaintView
    @State private var showingFeedbackView = false
    
    // Display settings
    @State private var darkModeSelection: DarkModeOption = .system
    @State private var textSize = 1 // 0: Small, 1: Medium, 2: Large
    
    enum DarkModeOption: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light" 
        case dark = "Dark"
        
        var id: String { self.rawValue }
    }
    
    enum FontSize: Int, CaseIterable, Identifiable {
        case small = 0
        case medium = 1
        case large = 2
        
        var id: Int { self.rawValue }
        
        var displayName: String {
            switch self {
            case .small: return "Small".localized
            case .medium: return "Medium".localized
            case .large: return "Large".localized
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // General section
                Section(header: Text("General".localized).font(.headline)) {
                    // Language selection option
                    Button(action: {
                        showingLanguageSelector = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("App Language".localized)
                            
                            Spacer()
                            
                            Text(languageManager.currentLanguage.displayName)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityLabel("Change app language. Current language is \(languageManager.currentLanguage.displayName)")
                    
                    // Appearance option
                    HStack {
                        Image(systemName: "moon.stars.fill")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        
                        Picker("Dark Mode".localized, selection: $darkModeSelection) {
                            ForEach(DarkModeOption.allCases) { option in
                                Text(option.rawValue.localized).tag(option)
                            }
                        }
                    }
                    .accessibilityHint("Select appearance mode for the app")
                    
                    // Text size option
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "textformat.size")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Text Size".localized)
                        }
                        
                        Picker("", selection: $textSize) {
                            Text("Small".localized).tag(0)
                            Text("Medium".localized).tag(1)
                            Text("Large".localized).tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 8)
                    .accessibilityHint("Adjust text size for better readability")
                }
                
                // Notification Settings Section
                Section(header: Text("Notification Settings".localized).font(.headline)) {
                    Toggle(isOn: $receivePushNotifications) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Push Notifications".localized)
                        }
                    }
                    .accessibilityHint("Enable or disable push notifications")
                    
                    Toggle(isOn: $receiveStatusUpdates) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Status Updates".localized)
                        }
                    }
                    .accessibilityHint("Enable or disable notifications for complaint status updates")
                    
                    Toggle(isOn: $receiveEmailNotifications) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Email Notifications".localized)
                        }
                    }
                    .accessibilityHint("Enable or disable email notifications")
                    
                    Toggle(isOn: $receiveSmsNotifications) {
                        HStack {
                            Image(systemName: "message.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("SMS Notifications".localized)
                        }
                    }
                    .accessibilityHint("Enable or disable SMS notifications")
                }
                
                // Data & Storage section
                Section(header: Text("Data & Storage".localized).font(.headline)) {
                    Button(action: {
                        // Simulate clearing cache with haptic feedback
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Clear Cache".localized)
                            
                            Spacer()
                            
                            Text("45.5 MB")
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityHint("Clear cached data to free up storage space")
                }
                
                // Account Section
                Section(header: Text("Account".localized).font(.headline)) {
                    HStack {
                        Image(systemName: "person.crop.square.fill")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        
                        Text("User ID".localized)
                        
                        Spacer()
                        
                        Text("JWS12345")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        
                        Text("Mobile Number".localized)
                        
                        Spacer()
                        
                        Text("+91 98765 43210")
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        // Would navigate to profile edit screen in a real app
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Edit Profile".localized)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityHint("Edit your profile information")
                }
                
                // About Section
                Section(header: Text("About".localized).font(.headline)) {
                    Button(action: {
                        showingAboutSheet = true
                    }) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("About This App".localized)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityHint("Learn more about this app")
                    
                    Button(action: {
                        // Show feedback view from TrackComplaintView
                        showingFeedbackView = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.badge.fill")
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                            
                            Text("Send Feedback".localized)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .accessibilityHint("Send feedback about the app")
                    
                    HStack {
                        Image(systemName: "number")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        
                        Text("App Version".localized)
                        
                        Spacer()
                        
                        Text("1.0.0 (Build 42)")
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings".localized, displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Close".localized)
                        .foregroundColor(.white)
                        .bold()
                }
            )
            .sheet(isPresented: $showingLanguageSelector) {
                LanguageSelectorView(isPresented: $showingLanguageSelector)
            }
            .sheet(isPresented: $showingAboutSheet) {
                AboutView(isPresented: $showingAboutSheet)
            }
            .sheet(isPresented: $showingFeedbackView) {
                // Create a wrapper for the TrackComplaintView's feedback sheet
                NavigationView {
                    FeedbackSheetWrapper(isPresented: $showingFeedbackView)
                }
            }
        }
        .accentColor(.blue)
    }
}

// Wrapper view to reuse TrackComplaintView's feedback functionality
struct FeedbackSheetWrapper: View {
    @Binding var isPresented: Bool
    @State private var feedbackRating = 3
    @State private var feedbackComment = ""
    @State private var isSubmitting = false
    @State private var showingFeedbackSuccess = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text("We value your feedback")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                        
                        Text("Please tell us about your experience with this app")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Rating section with improved feedback
                    VStack(spacing: 15) {
                        Text("How satisfied are you with our service?")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .accessibilityAddTraits(.isHeader)
                        
                        // Star rating
                        HStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { rating in
                                Button(action: {
                                    feedbackRating = rating
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                }) {
                                    VStack {
                                        Image(systemName: rating <= feedbackRating ? "star.fill" : "star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(rating <= feedbackRating ? .yellow : .gray)
                                            .animation(.spring(), value: feedbackRating)
                                            .shadow(color: rating <= feedbackRating ? .yellow.opacity(0.3) : .clear, radius: 3)
                                        
                                        // Small dot indicator under selected star
                                        Circle()
                                            .frame(width: 5, height: 5)
                                            .foregroundColor(rating == feedbackRating ? .blue : .clear)
                                    }
                                    .padding(.vertical, 5)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityLabel("Rate \(rating) stars")
                                .accessibilityValue(rating <= feedbackRating ? "Selected" : "Not selected")
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Rating description based on selection
                        Text(ratingDescription(for: feedbackRating))
                            .font(.callout)
                            .foregroundColor(.primary)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(ratingDescriptionColor(for: feedbackRating).opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .animation(.easeInOut, value: feedbackRating)
                    }
                    
                    // Comments section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Additional comments")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            Text("(optional)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if feedbackComment.isEmpty {
                                Text("Tell us about your experience...")
                                    .foregroundColor(.gray.opacity(0.8))
                                    .font(.body)
                                    .padding(.horizontal, 5)
                                    .padding(.top, 8)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $feedbackComment)
                                .frame(minHeight: 120)
                                .padding(4)
                                .background(Color.clear)
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .padding(.horizontal)
                        )
                    }
                    
                    // Privacy notice
                    Text("Your feedback helps us improve our services. No personal data will be shared.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Submit button
                    Button(action: {
                        submitFeedback()
                    }) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 10)
                            }
                            
                            Text(isSubmitting ? "Submitting..." : "Submit Feedback")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitting || showingFeedbackSuccess ? Color.blue.opacity(0.4) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                    .disabled(isSubmitting || showingFeedbackSuccess)
                    .opacity(isSubmitting || showingFeedbackSuccess ? 0.7 : 1)
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
                .padding()
                .opacity(showingFeedbackSuccess ? 0.3 : 1)
            }
            .disabled(showingFeedbackSuccess)
            
            // Success overlay
            if showingFeedbackSuccess {
                VStack(spacing: 20) {
                    ZStack {
                        // Animated stars behind the checkmark
                        ForEach(0..<5) { i in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .offset(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: -30...30))
                                .scaleEffect(0.7)
                                .opacity(0.6)
                        }
                        
                        // Main success indicator
                        Circle()
                            .fill(Color.green)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            )
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Text("Thank You for Your Feedback!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Your input helps us improve our services for everyone.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(30)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .navigationBarTitle("Feedback", displayMode: .inline)
        .navigationBarItems(trailing: Button("Close") {
            isPresented = false
        }
        .foregroundColor(.white)
        .bold()
        )
    }
    
    private func submitFeedback() {
        isSubmitting = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            
            // Show success UI within the sheet
            withAnimation {
                self.showingFeedbackSuccess = true
            }
            
            // Provide haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Dismiss sheet and show alert after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isPresented = false
            }
        }
    }
    
    // Helper functions for rating descriptions
    private func ratingDescription(for rating: Int) -> String {
        switch rating {
        case 1:
            return "Very Dissatisfied 😞"
        case 2:
            return "Dissatisfied 😕"
        case 3:
            return "Neutral 😐"
        case 4:
            return "Satisfied 🙂"
        case 5:
            return "Very Satisfied 😀"
        default:
            return "Please select a rating"
        }
    }
    
    private func ratingDescriptionColor(for rating: Int) -> Color {
        switch rating {
        case 1:
            return .red
        case 2:
            return .orange
        case 3:
            return .blue
        case 4:
            return .green
        case 5:
            return .green
        default:
            return .gray
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true))
    }
} 