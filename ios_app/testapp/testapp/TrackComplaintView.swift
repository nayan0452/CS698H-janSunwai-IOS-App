//
//  TrackComplaintView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct TrackComplaintView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var complaintId = ""
    @State private var showingComplaintDetails = false
    @State private var showingFeedbackSheet = false
    @State private var showingEscalationSheet = false
    @State private var feedbackRating = 3
    @State private var feedbackComment = ""
    @State private var escalationReason = ""
    @State private var isSubmitting = false
    @State private var showingDownloadAlert = false
    @State private var showSuccessAlert = false
    @State private var successMessage = ""
    @State private var showingFeedbackSuccess = false
    @State private var showingEscalationSuccess = false
    
    // Mock data for complaint details (in a real app, this would come from API)
    let complaintData = ComplaintData(
        id: "JSCMP-2023-12345",
        subject: "Road repair in sector 15",
        department: "Public Works Department",
        date: "05-Oct-2023",
        status: "In Progress",
        location: "Sector 15, Near Central Park",
        updates: [
            StatusUpdate(
                date: "05-Oct-2023",
                time: "10:30 AM",
                status: "Complaint Registered",
                details: "Your complaint has been successfully registered in our system."
            ),
            StatusUpdate(
                date: "06-Oct-2023",
                time: "2:15 PM",
                status: "Assigned to Department",
                details: "Your complaint has been assigned to the Public Works Department."
            ),
            StatusUpdate(
                date: "08-Oct-2023",
                time: "11:45 AM",
                status: "Under Review",
                details: "A team has been dispatched to inspect the reported issue."
            )
        ]
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if !showingComplaintDetails {
                    // Track complaint form - simplified to use only complaint ID
                    trackComplaintForm
                } else {
                    // Complaint details view - enhanced design aligned with DashboardView
                    enhancedComplaintDetailsView
                }
            }
            .padding()
        }
        .navigationBarTitle("track_complaint".localized, displayMode: .inline)
        .sheet(isPresented: $showingFeedbackSheet) {
            feedbackSheet
        }
        .sheet(isPresented: $showingEscalationSheet) {
            escalationSheet
        }
        .alert("download_response".localized, isPresented: $showingDownloadAlert) {
            Button("download".localized, role: .none) {
                downloadResponse()
            }
            Button("cancel".localized, role: .cancel) {}
        } message: {
            Text("download_prompt".localized)
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("success".localized),
                message: Text(successMessage),
                dismissButton: .default(Text("ok".localized))
            )
        }
    }
    
    var trackComplaintForm: some View {
        VStack(spacing: 25) {
            // Header with illustration for visual appeal
            VStack(spacing: 16) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .accessibilityHidden(true)
                
                Text("track_your_complaint".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            
                Text("enter_details_prompt".localized)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            
            // Information banner - useful for users to understand
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                
                Text("complaint_id_info".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // Complaint ID input - focused, primary action
            VStack(alignment: .leading, spacing: 10) {
                Text("complaint_id".localized)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                HStack {
                    TextField("enter_complaint_id_placeholder".localized, text: $complaintId)
                        .padding()
                        .frame(height: 50) // Minimum 44pt for touch target (Apple guideline)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .accessibilityLabel("Complaint ID Field")
                    
                    if !complaintId.isEmpty {
                        Button(action: {
                            complaintId = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44) // 44pt minimum for touch targets
                        }
                        .accessibilityLabel("Clear complaint ID")
                    }
                }
            }
            
            // Track button - prominent and follows Apple guidelines
            Button(action: {
                trackComplaint()
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.headline)
                    
                    Text("track_button".localized)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55) // Comfortably exceeds 44pt minimum touch target size
                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(color: isFormValid ? Color.blue.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 3)
            }
            .disabled(!isFormValid)
            .padding(.top, 10)
            .accessibilityHint("Tap to search for your complaint")
            
            // Additional help section
            VStack(spacing: 15) {
               
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
            
            Spacer(minLength: 30)
        }
    }
    
    // Enhanced complaint details view based on DashboardView design
    var enhancedComplaintDetailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Complaint header with more visual prominence
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("complaint_details".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(complaintData.status)
                        .font(.subheadline)
                        .foregroundColor(statusColor(for: complaintData.status))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor(for: complaintData.status).opacity(0.1))
                        .cornerRadius(20)
                }
                
                Text("\("id_prefix".localized)\(complaintData.id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Complaint information
            VStack(spacing: 15) {
                informationRow(title: "tracking_subject".localized, value: complaintData.subject)
                informationRow(title: "department".localized, value: complaintData.department)
                informationRow(title: "date_filed".localized, value: complaintData.date)
                informationRow(title: "location".localized, value: complaintData.location)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Status updates timeline
            VStack(alignment: .leading, spacing: 12) {
                Text("status_updates".localized)
                    .font(.headline)
                    .padding(.bottom, 5)
                
                ForEach(complaintData.updates, id: \.date) { update in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .top) {
                            // Timeline dot and line
                            VStack {
                                Circle()
                                    .fill(statusColor(for: update.status))
                                    .frame(width: 12, height: 12)
                                
                                if update != complaintData.updates.last {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 2, height: 40)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(update.status)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Text(update.date + " at " + update.time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(update.details)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 2)
                            }
                            .padding(.leading, 10)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Action buttons
            VStack(spacing: 15) {
                // Aligned with DashboardView implementation
                Button(action: {
                    showingFeedbackSheet = true
                }) {
                    HStack {
                        Image(systemName: "star")
                            .font(.system(size: 16))
                        
                        Text("provide_feedback".localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                    .frame(height: 55) // Exceeds 44pt minimum hit target
                    .padding(.horizontal)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    showingDownloadAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.doc")
                            .font(.system(size: 16))
                        
                        Text("download_response".localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                    .frame(height: 55) // Exceeds 44pt minimum hit target
                    .padding(.horizontal)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(10)
                }
                
                // Escalate Matter Button - aligned with DashboardView implementation
                Button(action: {
                    showingEscalationSheet = true
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 16))
                        
                        Text("escalate_matter".localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                    .frame(height: 55) // Exceeds 44pt minimum hit target
                    .padding(.horizontal)
                    .background(Color.red.opacity(0.15))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // Back to search button
            Button(action: {
                showingComplaintDetails = false
                complaintId = ""
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("search_another_complaint".localized)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55) // Exceeds 44pt minimum hit target
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
    
    // Feedback sheet - aligned with DashboardView implementation
    var feedbackSheet: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 25) {
                        // Header with stars for visual appeal
                        VStack(spacing: 10) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.yellow)
                                .padding(.top, 10)
                            
                            Text("rate_your_experience".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text("help_us_improve".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Star rating
                        VStack(spacing: 15) {
                            Text("satisfaction_question".localized)
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(1...5, id: \.self) { rating in
                                    Button(action: {
                                        feedbackRating = rating
                                    }) {
                                        Image(systemName: rating <= feedbackRating ? "star.fill" : "star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(rating <= feedbackRating ? .yellow : .gray)
                                            .padding(8)
                                    }
                                    .frame(minWidth: 50, minHeight: 50) // Exceeds 44pt hit target
                                    .buttonStyle(PlainButtonStyle())
                                    .accessibilityLabel("Rate \(rating) stars")
                                    .accessibilityValue(rating <= feedbackRating ? "Selected" : "Not selected")
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6).opacity(0.5))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            
                            // Rating description
                            Text(ratingDescription(for: feedbackRating))
                                .font(.callout)
                                .foregroundColor(.primary)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(ratingDescriptionColor(for: feedbackRating).opacity(0.1))
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .animation(.easeInOut(duration: 0.3), value: feedbackRating)
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
                                    Text("tell_us_about_experience".localized)
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
                        
                        // Submit button
                        Button(action: {
                            submitFeedback()
                        }) {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("submit_feedback".localized)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .disabled(isSubmitting)
                        
                        // Privacy notice
                        Text("Your feedback helps us improve our services. No personal information is collected through this form.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                    }
                    .padding(.bottom, 30)
                }
                
                // Success overlay - shown after feedback submission
                if showingFeedbackSuccess {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack(spacing: 20) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.green)
                                
                                Text("thank_you".localized)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("feedback_submitted".localized)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    withAnimation {
                                        showingFeedbackSuccess = false
                                        showingFeedbackSheet = false
                                    }
                                }) {
                                    Text("close".localized)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 50)
                                .padding(.top, 10)
                            }
                            .padding(30)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(20)
                            .padding(.horizontal, 40)
                        )
                        .transition(.opacity)
                }
            }
            .navigationBarTitle("feedback".localized, displayMode: .inline)
            .navigationBarItems(trailing: Button("close".localized) {
                showingFeedbackSheet = false
            })
        }
    }
    
    // Escalation sheet - aligned with DashboardView implementation
    var escalationSheet: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header section
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.orange)
                                .padding(.top, 20)
                            
                            Text("escalate_complaint".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text("escalation_description".localized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                        
                        // Information about escalation
                        VStack(spacing: 15) {
                            EscalationInfoRow(
                                icon: "arrow.up.circle",
                                title: "what_happens_next".localized,
                                description: "next_steps_desc".localized,
                                iconColor: .orange
                            )
                            
                            EscalationInfoRow(
                                icon: "clock",
                                title: "response_time".localized,
                                description: "response_time_desc".localized,
                                iconColor: .orange
                            )
                            
                            EscalationInfoRow(
                                icon: "person.2",
                                title: "higher_authority".localized,
                                description: "higher_authority_desc".localized,
                                iconColor: .orange
                            )
                        }
                        .padding(.horizontal)
                        
                        // Input section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("reason_escalation".localized)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .topLeading) {
                                if escalationReason.isEmpty {
                                    Text("explain_escalation".localized)
                                        .foregroundColor(.gray.opacity(0.8))
                                        .font(.body)
                                        .padding(.horizontal, 5)
                                        .padding(.top, 8)
                                        .allowsHitTesting(false)
                                }
                                
                                TextEditor(text: $escalationReason)
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
                        .padding(.top, 10)
                        
                        // Submit button
                        Button(action: {
                            submitEscalation()
                        }) {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("submit_escalation".localized)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(escalationReason.count > 10 ? Color.orange : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .disabled(escalationReason.count < 10 || isSubmitting)
                        
                        // Note
                        Text("escalation_note".localized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 5)
                            .padding(.bottom, 40)
                    }
                }
                
                // Success overlay - shown after escalation submission
                if showingEscalationSuccess {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack(spacing: 20) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.green)
                                
                                Text("request_submitted".localized)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("escalation_success".localized)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    withAnimation {
                                        showingEscalationSuccess = false
                                        showingEscalationSheet = false
                                    }
                                }) {
                                    Text("close".localized)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 50)
                                .padding(.top, 10)
                            }
                            .padding(30)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(20)
                            .padding(.horizontal, 40)
                        )
                        .transition(.opacity)
                }
            }
            .navigationBarTitle("escalate_complaint".localized, displayMode: .inline)
            .navigationBarItems(trailing: Button("close".localized) {
                showingEscalationSheet = false
            })
        }
    }
    
    // Helper views and functions
    func informationRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(title):")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "completed", "resolved":
            return .green
        case "in progress", "assigned", "under review":
            return .orange
        case "pending", "open", "complaint registered":
            return .blue
        case "rejected", "closed":
            return .red
        default:
            return .gray
        }
    }
    
    // Form validation - simplified to only check complaint ID
    var isFormValid: Bool {
        !complaintId.isEmpty
    }
    
    // Action functions
    func trackComplaint() {
        // In a real app, this would make an API call with the complaint ID
        withAnimation {
            showingComplaintDetails = true
        }
    }
    
    func downloadResponse() {
        // In a real app, this would download a document
        // Simulate download success with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            successMessage = "Response document has been downloaded successfully."
            showSuccessAlert = true
        }
    }
    
    func submitFeedback() {
        isSubmitting = true
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            
            // Show success message
            withAnimation {
                showingFeedbackSuccess = true
            }
            
            // Provide haptic feedback on success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func submitEscalation() {
        isSubmitting = true
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            
            // Show success message
            withAnimation {
                showingEscalationSuccess = true
            }
            
            // Provide haptic feedback on success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func ratingDescription(for rating: Int) -> String {
        switch rating {
        case 1: return "Very Dissatisfied"
        case 2: return "Dissatisfied"
        case 3: return "Neutral"
        case 4: return "Satisfied"
        case 5: return "Very Satisfied"
        default: return "Neutral"
        }
    }
    
    func ratingDescriptionColor(for rating: Int) -> Color {
        switch rating {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .green
        default: return .yellow
        }
    }
}

// Shared models
struct ComplaintData {
    let id: String
    let subject: String
    let department: String
    let date: String
    let status: String
    let location: String
    let updates: [StatusUpdate]
}

struct StatusUpdate: Identifiable, Equatable {
    var id: String { date + time + status }
    let date: String
    let time: String
    let status: String
    let details: String
    
    static func ==(lhs: StatusUpdate, rhs: StatusUpdate) -> Bool {
        return lhs.id == rhs.id
    }
}

// Preview
struct TrackComplaintView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackComplaintView()
        }
    }
} 
