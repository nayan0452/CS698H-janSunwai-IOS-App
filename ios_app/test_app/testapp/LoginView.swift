//
//  LoginView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @State private var mobileNumber = ""
    @State private var otp = ""
    @State private var isOtpSent = false
    @State private var isLoginEnabled = false
    @State private var remainingSeconds = 0
    @State private var timer: Timer? = nil
    @State private var cursorVisible = false  // For the flickering cursor
    @State private var cursorTimer: Timer? = nil
    @Environment(\.presentationMode) var presentationMode
    
    // Focus states for the text fields
    @FocusState private var isMobileNumberFocused: Bool
    @FocusState private var isOtpFocused: Bool
    
    // Environment object for navigation
    @State private var navigateToDashboard = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 16) {
                    Text("login_title".localized)
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 12)
                        .accessibility(addTraits: .isHeader)
                    
                    Text("login_description".localized)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .lineSpacing(4)
                }
                .padding(.bottom, 12)
                
                // Mobile number input section
                VStack(alignment: .leading, spacing: 12) {
                    Text("mobile_number".localized)
                        .font(.headline)
                    
                    HStack {
                        Text("+91")
                            .foregroundColor(.secondary)
                            .padding(.leading, 12)
                        
                        TextField("mobile_placeholder".localized, text: $mobileNumber)
                            .keyboardType(.numberPad)
                            .focused($isMobileNumberFocused)
                            .onChange(of: mobileNumber) { oldValue, newValue in
                                // Limit to 10 digits
                                if newValue.count > 10 {
                                    mobileNumber = String(newValue.prefix(10))
                                }
                            }
                            .accessibilityLabel("mobile_number".localized)
                            .submitLabel(.next)
                            .onSubmit {
                                if isValidMobileNumber() {
                                    sendOTP()
                                }
                            }
                    }
                    .padding()
                    .frame(height: 56)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // OTP Button Section
                Button(action: {
                    sendOTP()
                }) {
                    if remainingSeconds > 0 {
                        HStack {
                            Text("\("resend_otp_in".localized) \(remainingSeconds)s")
                            Spacer()
                            Image(systemName: "timer")
                        }
                        .padding()
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                    } else {
                        HStack {
                            Text("send_otp".localized)
                            Spacer()
                            Image(systemName: "paperplane.fill")
                        }
                        .padding()
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(isValidMobileNumber() ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .disabled(!isValidMobileNumber() || remainingSeconds > 0)
                .padding(.horizontal)
                
                if isOtpSent {
                    // OTP Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("enter_otp".localized)
                            .font(.headline)
                        
                        // OTP input with visual separation
                        HStack(spacing: 8) {
                            // Visual OTP digit boxes
                            ForEach(0..<6) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 44, height: 56)
                                    
                                    if index < otp.count {
                                        // Show entered digit
                                        Text(String(Array(otp)[index]))
                                            .font(.title2.bold())
                                    } else if index == otp.count && cursorVisible {
                                        // Show flickering cursor at the current position
                                        Text("|")
                                            .font(.title2.bold())
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .overlay(
                            TextField("otp_placeholder".localized, text: $otp)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .opacity(0.01) // Hidden but still functional
                                .focused($isOtpFocused)
                                .onChange(of: otp) { oldValue, newValue in
                                    // Limit to 6 digits
                                    if newValue.count > 6 {
                                        otp = String(newValue.prefix(6))
                                    }
                                    
                                    // Enable login button if OTP is 6 digits
                                    isLoginEnabled = newValue.count == 6
                                    
                                    // Auto login when 6 digits are entered
                                    if newValue.count == 6 {
                                        // Short delay to give visual feedback
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            navigateToDashboard = true
                                        }
                                    }
                                }
                        )
                        
                        Text("An OTP has been sent to +91-\(mobileNumber)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onAppear {
                        // Start cursor blinking when OTP field appears
                        startCursorBlink()
                    }
                    .onDisappear {
                        // Stop cursor blinking when OTP field disappears
                        stopCursorBlink()
                    }
                    
                    // Login Button
                    NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) {
                        HStack {
                            Text("login".localized)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(isLoginEnabled ? Color.blue : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!isLoginEnabled)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Help Link
                    NavigationLink(destination: HelpView()) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.blue)
                            Text("need_help".localized)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 12)
                        .frame(minWidth: 120, minHeight: 44)
                    }
                    .padding(.top, 8)
                }
                
                Spacer(minLength: 20)
                
                // Support message at bottom
                Text("login_support_message".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitle("app_title".localized, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("Back")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            // Focus on mobile number field when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isMobileNumberFocused = true
            }
        }
        .onDisappear {
            // Clean up timer when view disappears
            timer?.invalidate()
            timer = nil
            
            // Clean up cursor timer
            stopCursorBlink()
        }
    }
    
    // Start the cursor blinking animation
    private func startCursorBlink() {
        // Clean up any existing timer
        stopCursorBlink()
        
        // Create a timer that toggles cursor visibility every 0.5 seconds
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            cursorVisible.toggle()
        }
    }
    
    // Stop the cursor blinking animation
    private func stopCursorBlink() {
        cursorTimer?.invalidate()
        cursorTimer = nil
    }
    
    func isValidMobileNumber() -> Bool {
        return mobileNumber.count == 10 && mobileNumber.allSatisfy { $0.isNumber }
    }
    
    func sendOTP() {
        if isValidMobileNumber() && remainingSeconds == 0 {
            // In a real app, this would make an API call to send OTP
            isOtpSent = true
            
            // Start the 30-second timer
            remainingSeconds = 30
            
            // Create and start the timer
            timer?.invalidate() // Invalidate any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    timer?.invalidate()
                    timer = nil
                }
            }
            
            // Unfocus mobile number field and focus on OTP field after a slight delay
            isMobileNumberFocused = false
            
            // Slight delay to allow UI to update before focusing on OTP field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isOtpFocused = true
            }
        }
    }
}

#Preview {
    NavigationView {
        LoginView()
            .environmentObject(LanguageManager.shared)
    }
} 