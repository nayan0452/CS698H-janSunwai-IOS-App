//
//  ContentView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @State private var showingHelpView = false
    @State private var showingLanguageSelector = false
    @State private var showingSidebar = false
    @State private var loginButtonScale: CGFloat = 1.0 // Added for animation effect
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                VStack(spacing: 20) {
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                .foregroundStyle(.tint)
                        .padding(.top, 20)
                    
                    Text("welcome".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .accessibility(addTraits: .isHeader)
                    
                    Text("app_description".localized)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer().frame(height: 30)
                    
                    VStack(spacing: 15) {
                        // Login prompt label
                        Text("  an account?")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25)
                        
                        NavigationLink(destination: LoginView()) {
                            // Enhanced login button
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                Text("login".localized)
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .padding(.horizontal)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    .padding(.horizontal)
                            )
                            .scaleEffect(loginButtonScale)
                        }
                        .buttonStyle(PressableButtonStyle())
                        
                        NavigationLink(destination: RegisterComplaintView()) {
                            PrimaryButton(title: "register_complaint".localized)
                        }
                        
                        NavigationLink(destination: TrackComplaintView()) {
                            PrimaryButton(title: "track_complaint".localized)
                        }
                        
                        NavigationLink(destination: HelpView()) {
                            Text("help_support".localized)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                    Text("privacy_message".localized)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .padding()
                .navigationBarTitle("app_title".localized, displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        withAnimation(.spring()) {
                            showingLanguageSelector = true
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(languageManager.currentLanguage.displayName)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            Image(systemName: "globe")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PressableButtonStyle())
                )
                .sheet(isPresented: $showingLanguageSelector) {
                    LanguageSelectorView(isPresented: $showingLanguageSelector)
                }
                .onAppear {
                    // Start subtle pulsing animation for the login button
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        loginButtonScale = 1.06
                    }
                }
            }
        }
    }
}

struct PrimaryButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .frame(minHeight: 44)
    }
}

// Custom button style for a pressable effect
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Note: Placeholder views have been removed as they conflict with the actual implementations
// The app now uses the full implementations from their respective files:
// - LoginView.swift
// - RegisterComplaintView.swift
// - TrackComplaintView.swift
// - HelpView.swift

#Preview {
    ContentView()
}
