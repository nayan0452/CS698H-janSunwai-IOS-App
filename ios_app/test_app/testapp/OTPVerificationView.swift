import SwiftUI

struct OTPVerificationView: View {
    let mobileNumber: String
    @Binding var otpCode: String
    let onVerify: () -> Void
    
    @State private var otpDigits: [String] = Array(repeating: "", count: 6)
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var remainingSeconds = 30
    @State private var isResendActive = false
    @State private var isTimerRunning = true
    
    @FocusState private var focusedField: Int?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with app logo
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 30)
            
            Text("otp_verification".localized)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("verify_otp_instructions".localized + " \(mobileNumber)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // OTP Input Fields
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $otpDigits[index])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 45, height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    !otpDigits[index].isEmpty ? Color.blue : Color.gray.opacity(0.5),
                                    lineWidth: 2
                                )
                        )
                        .focused($focusedField, equals: index)
                        .onChange(of: otpDigits[index]) { newValue in
                            // Limit to single digit
                            if newValue.count > 1 {
                                otpDigits[index] = String(newValue.suffix(1))
                            }
                            
                            // Filter out non-numeric characters
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                otpDigits[index] = filtered
                            }
                            
                            // Auto advance to next field
                            if !newValue.isEmpty && index < 5 {
                                focusedField = index + 1
                            }
                            
                            // Update the combined OTP code
                            otpCode = otpDigits.joined()
                        }
                        .submitLabel(index == 5 ? .done : .next)
                        .onSubmit {
                            if index < 5 {
                                focusedField = index + 1
                            } else {
                                focusedField = nil
                            }
                        }
                }
            }
            .padding(.vertical, 20)
            
            // Error message if any
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Verify OTP Button
            Button(action: {
                verifyOTP()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 5)
                    }
                    Text("verify".localized)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(otpCode.count == 6 ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(otpCode.count < 6 || isLoading)
            }
            .padding(.horizontal, 20)
            
            // Resend OTP button and timer
            HStack {
                Text("didnt_receive_otp".localized)
                    .foregroundColor(.gray)
                
                Button(action: {
                    resendOTP()
                }) {
                    Text("resend".localized)
                        .foregroundColor(isResendActive ? .blue : .gray)
                }
                .disabled(!isResendActive)
            }
            
            if isTimerRunning {
                Text("resend_in".localized + " \(remainingSeconds)s")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Set focus to first field
            focusedField = 0
            
            // Start timer for resend button
            startResendTimer()
        }
        .onReceive(timer) { _ in
            if isTimerRunning && remainingSeconds > 0 {
                remainingSeconds -= 1
            } else if remainingSeconds == 0 {
                isTimerRunning = false
                isResendActive = true
            }
        }
    }
    
    // Verify the entered OTP code
    private func verifyOTP() {
        isLoading = true
        errorMessage = nil
        
        // Simulate OTP verification (replace with actual verification)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // For demo, consider OTP valid if it's 6 digits
            if otpCode.count == 6 {
                onVerify()
            } else {
                errorMessage = "invalid_otp".localized
            }
        }
    }
    
    // Resend OTP functionality
    private func resendOTP() {
        // Reset OTP fields
        otpDigits = Array(repeating: "", count: 6)
        otpCode = ""
        errorMessage = nil
        focusedField = 0
        
        // Reset timer
        startResendTimer()
        
        // Simulate resending OTP
        // In a real app, call your API here
    }
    
    // Start or restart the resend timer
    private func startResendTimer() {
        remainingSeconds = 30
        isTimerRunning = true
        isResendActive = false
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(
            mobileNumber: "9876543210",
            otpCode: .constant(""),
            onVerify: {}
        )
    }
} 