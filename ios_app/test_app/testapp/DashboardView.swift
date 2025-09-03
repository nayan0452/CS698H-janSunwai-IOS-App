//
//  DashboardView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var languageManager = LanguageManager.shared
    @State private var selectedTab = 0
    @State private var showingLanguageSelector = false
    @State private var showingSidebar = false
    @State private var selectedComplaintType: ComplaintFilterType? = nil
    @State private var showingComplaintDetails = false
    @State private var selectedComplaintId: String? = nil
    @State private var showingDocumentsView = false
    @State private var showingSettingsView = false
    
    enum ComplaintFilterType {
        case all, pending, resolved
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Dashboard tab
                dashboardContent
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("dashboard".localized)
                    }
                    .tag(0)
                
                // Register complaint tab
                RegisterComplaintView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("new_complaint".localized)
                    }
                    .tag(1)
                
                // Track complaints tab
                TrackComplaintView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("track".localized)
                    }
                    .tag(2)
                
                // Profile tab
                profileContent
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("profile".localized)
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showingSidebar.toggle()
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                            .accessibility(label: Text("Menu"))
                            .accessibility(hint: Text("Opens navigation menu"))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLanguageSelector = true
                    }) {
                        HStack(spacing: 4) {
                            Text(languageManager.currentLanguage.displayName)
                                .foregroundColor(.white)
                            
                            Image(systemName: "globe")
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            .sheet(isPresented: $showingLanguageSelector) {
                LanguageSelectorView(isPresented: $showingLanguageSelector)
            }
            .sheet(isPresented: $showingComplaintDetails) {
                // Display complaint details when a specific complaint is selected
                ComplaintDetailView(
                    complaintId: selectedComplaintId ?? "JSCMP-2023-12345",
                    onDismiss: { showingComplaintDetails = false }
                )
            }
            .sheet(isPresented: $showingDocumentsView) {
                // Display documents view
                DocumentsView(isPresented: $showingDocumentsView)
            }
            .sheet(isPresented: $showingSettingsView) {
                // Display settings view
                SettingsView(isPresented: $showingSettingsView)
            }
            
            // Hamburger menu / Sidebar
            if showingSidebar {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingSidebar = false
                        }
                    }
                
                GeometryReader { geometry in
                    HStack(alignment: .top, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            // Sidebar header
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("HCI User")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text("+91 98765 43210")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            showingSidebar = false
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.title3)
                                            .foregroundColor(.primary)
                                            .frame(width: 44, height: 44)
                                            .contentShape(Rectangle())
                                            .accessibility(label: Text("Close menu"))
                                    }
                                }
                                
                                Divider()
                                    .padding(.top, 8)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            // Menu items
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(sidebarMenuItems, id: \.title) { item in
                                        SidebarMenuItemView(item: item) {
                                            withAnimation(.spring()) {
                                                showingSidebar = false
                                            }
                                            item.action()
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Divider()
                            
                            // Sign out button
                            Button(action: {
                                // Sign out action
                                withAnimation(.spring()) {
                                    showingSidebar = false
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                        .frame(width: 28, height: 28)
                                    Text("sign_out".localized)
                                        .font(.body)
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding()
                                .contentShape(Rectangle())
                            }
                            
                            // App version
                            Text("app_version".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                        }
                        .frame(width: min(geometry.size.width * 0.85, 300))
                        .background(
                            Color(.systemBackground)
                                .edgesIgnoringSafeArea(.vertical)
                        )
                        .overlay(
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 1)
                                .edgesIgnoringSafeArea(.vertical),
                            alignment: .trailing
                        )
                        
                        Spacer()
                    }
                }
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
    }
    
    var dashboardContent: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("welcome_user".localized)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .accessibility(addTraits: .isHeader)
                        
                        Text("dashboard_description".localized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                
                // Stats summary with clickable cards
                HStack(spacing: 15) {
                    Button(action: {
                        selectedComplaintType = .all
                    }) {
                        StatCard(
                            title: "total".localized,
                            count: "3",
                            color: .blue,
                            systemImage: "doc.text"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        selectedComplaintType = .pending
                    }) {
                        StatCard(
                            title: "pending".localized,
                            count: "1",
                            color: .orange,
                            systemImage: "clock"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        selectedComplaintType = .resolved
                    }) {
                        StatCard(
                            title: "resolved".localized,
                            count: "2",
                            color: .green,
                            systemImage: "checkmark.circle"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                // Filter header if a filter is selected
                if let filterType = selectedComplaintType {
                    HStack {
                        Text(filterTitle(for: filterType))
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedComplaintType = nil
                        }) {
                            Text("recent_complaints".localized)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
                // Recent complaints section
                VStack(alignment: .leading, spacing: 15) {
                    if selectedComplaintType == nil {
                        Text("recent_complaints".localized)
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            // Show filtered complaints based on selection
                            if shouldShowComplaint(status: "status_in_progress".localized) {
                                DashboardComplaintCard(
                                    id: "JSCMP-2023-12345",
                                    subject: "road_repair".localized,
                                    status: "status_in_progress".localized,
                                    date: "05-Oct-2023",
                                    onDetailsTap: {
                                        selectedComplaintId = "JSCMP-2023-12345"
                                        showingComplaintDetails = true
                                    }
                                )
                            }
                            
                            if shouldShowComplaint(status: "status_resolved".localized) {
                                DashboardComplaintCard(
                                    id: "JSCMP-2023-12344",
                                    subject: "streetlight".localized,
                                    status: "status_resolved".localized,
                                    date: "28-Sep-2023",
                                    onDetailsTap: {
                                        selectedComplaintId = "JSCMP-2023-12344"
                                        showingComplaintDetails = true
                                    }
                                )
                                
                                DashboardComplaintCard(
                                    id: "JSCMP-2023-12343",
                                    subject: "water_issue".localized,
                                    status: "status_resolved".localized,
                                    date: "15-Sep-2023",
                                    onDetailsTap: {
                                        selectedComplaintId = "JSCMP-2023-12343"
                                        showingComplaintDetails = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // Helper function to determine filter title
    func filterTitle(for type: ComplaintFilterType) -> String {
        switch type {
        case .all:
            return "all_complaints".localized + " (3)"
        case .pending:
            return "pending_complaints".localized + " (1)"
        case .resolved:
            return "resolved_complaints".localized + " (2)"
        }
    }
    
    // Helper function to determine if a complaint should be shown based on filter
    func shouldShowComplaint(status: String) -> Bool {
        guard let filterType = selectedComplaintType else {
            return true // No filter, show all
        }
        
        switch filterType {
        case .all:
            return true
        case .pending:
            return status == "status_in_progress".localized || status == "status_pending".localized
        case .resolved:
            return status == "status_resolved".localized
        }
    }
    
    var profileContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 30)
            
            Text("profile_title".localized)
                .font(.title)
                .fontWeight(.bold)
            
            Form {
                Section(header: Text("personal_details".localized)) {
                    HStack {
                        Text("name".localized)
                        Spacer()
                        Text("HCI User")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("mobile_number".localized)
                        Spacer()
                        Text("+91 98765 43210")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("email".localized)
                        Spacer()
                        Text("user.hci@example.com")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("notification_preferences".localized)) {
                    Toggle("notification".localized, isOn: .constant(true))
                    Toggle("sms_alerts".localized, isOn: .constant(true))
                }
                
                Section {
                    Button(action: {
                        // Log out action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("sign_out".localized)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // Sidebar menu items
    var sidebarMenuItems: [SidebarMenuItem] {
        [
            // Group 1: Profile
            SidebarMenuItem(
                title: "profile".localized,
                icon: "person.fill",
                action: { selectedTab = 3 },
                type: .regular
            ),
            
            // Separator
            SidebarMenuItem(
                title: "",
                icon: "",
                action: {},
                type: .separator
            ),
            
            // Group 2: Home, Complaints & Documents
            SidebarMenuItem(
                title: "home".localized,
                icon: "house.fill",
                action: { 
                    selectedTab = 0 
                    withAnimation(.spring()) {
                        showingSidebar = false
                    }
                },
                type: .regular
            ),
            
            SidebarMenuItem(
                title: "new_complaint".localized,
                icon: "plus.circle.fill",
                action: { selectedTab = 1 },
                type: .regular
            ),
            
            SidebarMenuItem(
                title: "track_complaints".localized,
                icon: "magnifyingglass",
                action: { selectedTab = 2 },
                type: .regular
            ),
            
            SidebarMenuItem(
                title: "documents".localized,
                icon: "doc.text.fill",
                action: { 
                    withAnimation {
                        showingSidebar = false
                    }
                    // Create a temporary NavigationLink and trigger it
                    // This is a workaround since we can't directly use NavigationLink outside of body
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    // Show a sheet with the DocumentsView
                    showingDocumentsView = true
                },
                type: .regular
            ),
            
            // Separator
            SidebarMenuItem(
                title: "",
                icon: "",
                action: {},
                type: .separator
            ),
            
            // Group 3: Settings & Help
            SidebarMenuItem(
                title: "settings".localized,
                icon: "gear",
                action: { 
                    withAnimation {
                        showingSidebar = false
                    }
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    // Show settings view
                    showingSettingsView = true
                },
                type: .regular
            ),
            SidebarMenuItem(
                title: "help_support".localized,
                icon: "questionmark.circle.fill",
                action: { print("Help tapped") },
                type: .regular
            )
        ]
    }
}

struct StatCard: View {
    let title: String
    let count: String
    let color: Color
    let systemImage: String
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(count)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// Renamed from ComplaintCard to DashboardComplaintCard to avoid conflict
struct DashboardComplaintCard: View {
    let id: String
    let subject: String
    let status: String
    let date: String
    var onDetailsTap: () -> Void
    
    var statusColor: Color {
        switch status {
        case "status_resolved".localized:
            return .green
        case "status_in_progress".localized:
            return .orange
        default:
            return .gray
        }
    }
    
    var accessibilityStatus: String {
        "Status: \(status)"
    }
    
    var body: some View {
        Button(action: onDetailsTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(id)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Complaint \(id) dated \(date)")
                
                Text(subject)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibilityLabel("Subject: \(subject)")
                
                HStack {
                    Text(status)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.2))
                        .foregroundColor(statusColor)
                        .cornerRadius(4)
                        .accessibilityLabel(accessibilityStatus)
                    
                    Spacer()
                    
                    Text("details".localized)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .accessibilityHint("View complaint details")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

// Complaint detail view (new)
struct ComplaintDetailView: View {
    let complaintId: String
    let onDismiss: () -> Void
    @State private var showingEscalationSheet = false
    @State private var showingFeedbackSheet = false
    @State private var showingDownloadAlert = false
    @State private var escalationReason = ""
    @State private var feedbackRating = 3
    @State private var feedbackComment = ""
    @State private var isSubmitting = false
    @State private var showSuccessAlert = false
    @State private var successMessage = ""
    @State private var showingEscalationSuccess = false
    @State private var showingFeedbackSuccess = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Complaint header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Complaint Details")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("ID: \(complaintId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Complaint information
                    VStack(spacing: 20) {
                        informationRow(title: "Subject", value: "Road repair needed on Main Street")
                        informationRow(title: "Department", value: "Public Works Department")
                        informationRow(title: "Status", value: "In Progress", color: .orange)
                        informationRow(title: "Date Filed", value: "05-Oct-2023")
                        informationRow(title: "Location", value: "Sector 15, Near Central Park")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Status updates
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Status Updates")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            statusUpdate(
                                date: "05-Oct-2023",
                                time: "10:30 AM",
                                status: "Complaint Registered",
                                details: "Your complaint has been successfully registered in our system."
                            )
                            
                            statusUpdate(
                                date: "06-Oct-2023",
                                time: "2:15 PM",
                                status: "Assigned to Department",
                                details: "Your complaint has been assigned to the Public Works Department."
                            )
                            
                            statusUpdate(
                                date: "08-Oct-2023",
                                time: "11:45 AM",
                                status: "Under Review",
                                details: "A team has been dispatched to inspect the reported issue."
                            )
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            showingFeedbackSheet = true
                        }) {
                            HStack {
                                Image(systemName: "star")
                                Text("Provide Feedback")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showingDownloadAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.doc")
                                Text("Download Response")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(10)
                        }
                        
                        // Escalate Matter Button
                        Button(action: {
                            showingEscalationSheet = true
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Escalate Matter")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 30)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button(action: onDismiss) {
                HStack {
                    Text("Close")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                }
            })
            .background(Color(.systemBackground))
            // Escalation Sheet
            .sheet(isPresented: $showingEscalationSheet) {
                NavigationView {
                    ZStack {
                        ScrollView {
                            VStack(spacing: 25) {
                                // Header section
                                VStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.orange)
                                        .padding(.top, 10)
                                    
                                    Text("Escalate Your Complaint")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("If you feel your complaint isn't being addressed properly, we're here to help")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                
                                Divider()
                                    .padding(.horizontal)
                                
                                // Information about escalation
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("What happens when you escalate?")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                        .accessibilityAddTraits(.isHeader)
                                    
                                    EscalationInfoRow(
                                        icon: "bell.fill",
                                        title: "Priority Review",
                                        description: "Your complaint will be reviewed by a senior official"
                                    )
                                    
                                    EscalationInfoRow(
                                        icon: "clock.fill",
                                        title: "Timeline Update",
                                        description: "You'll receive an updated timeline for resolution"
                                    )
                                    
                                    EscalationInfoRow(
                                        icon: "phone.fill",
                                        title: "Follow Up",
                                        description: "You may receive a call for additional information"
                                    )
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.7))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                
                                // Input section
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Please provide details")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .accessibilityAddTraits(.isHeader)
                                    
                                    Text("Explain why you're escalating and any new information that might help")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                    
                                    ZStack(alignment: .topLeading) {
                                        if escalationReason.isEmpty {
                                            Text("For example: No progress has been made since reporting, or the issue has worsened...")
                                                .foregroundColor(.gray.opacity(0.8))
                                                .font(.body)
                                                .padding(.horizontal, 5)
                                                .padding(.top, 8)
                                                .padding(.leading, 8)
                                                .allowsHitTesting(false)
                                        }
                                        
                                        TextEditor(text: $escalationReason)
                                            .frame(minHeight: 150)
                                            .padding(4)
                                            .cornerRadius(8)
                                            .background(Color.clear)
                                    }
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                    
                                    // Word count indicator
                                    HStack {
                                        Spacer()
                                        Text("\(escalationReason.count)/500 characters")
                                            .font(.caption)
                                            .foregroundColor(escalationReason.count > 450 ? (escalationReason.count > 500 ? .red : .orange) : .gray)
                                            .padding(.trailing)
                                    }
                                }
                                
                                // Submit button
                                Button(action: {
                                    submitEscalation()
                                }) {
                                    HStack {
                                        if isSubmitting {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .padding(.trailing, 10)
                                        }
                                        
                                        Text(isSubmitting ? "Submitting..." : "Submit Escalation")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                                    .padding()
                                    .background(escalationReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting || showingEscalationSuccess ? Color.blue.opacity(0.4) : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                }
                                .disabled(escalationReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting || showingEscalationSuccess)
                                .padding(.top, 10)
                                
                                // Note about processing time
                                Text("Escalations are typically processed within 48 hours")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.bottom, 20)
                            }
                            .padding()
                            .opacity(showingEscalationSuccess ? 0.3 : 1)
                        }
                        .disabled(showingEscalationSuccess)
                        
                        // Success overlay
                        if showingEscalationSuccess {
                            VStack(spacing: 20) {
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
                                
                                Text("Escalation Submitted Successfully!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                
                                Text("A senior official will review your complaint shortly.")
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
                    .navigationBarTitle("Escalate Complaint", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        escalationReason = ""
                        showingEscalationSheet = false
                    }
                    .disabled(isSubmitting || showingEscalationSuccess))
                }
            }
            // Feedback Sheet
            .sheet(isPresented: $showingFeedbackSheet) {
                NavigationView {
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
                                    
                                    Text("Please tell us about your experience with this complaint")
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
                                    
                                    // Star rating with improved visual feedback
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
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                                    .padding()
                                    .background(isSubmitting || showingFeedbackSuccess ? Color.blue.opacity(0.4) : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                }
                                .disabled(isSubmitting || showingFeedbackSuccess)
                                .opacity(isSubmitting || showingFeedbackSuccess ? 0.7 : 1)
                                .padding(.top)
                                
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
                    .navigationBarItems(trailing: Button("Cancel") {
                        showingFeedbackSheet = false
                    }
                    .disabled(isSubmitting || showingFeedbackSuccess))
                }
            }
            // Success Alert
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(successMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            // Download Alert
            .alert("Download Response", isPresented: $showingDownloadAlert) {
                Button("Download", role: .none) {
                    downloadResponse()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Would you like to download the official response document for this complaint?")
            }
        }
    }
    
    // Helper functions for button actions
    
    private func submitEscalation() {
        isSubmitting = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            
            // Show success UI within the sheet
            withAnimation {
                self.showingEscalationSuccess = true
            }
            
            // Provide haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Dismiss sheet and show alert after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showingEscalationSheet = false
                
                // Reset form
                escalationReason = ""
                showingEscalationSuccess = false
                
                // Show success message in alert
                successMessage = "Your complaint has been escalated successfully. You will be notified when there is an update."
                showSuccessAlert = true
            }
        }
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
                showingFeedbackSheet = false
                
                // Reset form
                feedbackComment = ""
                showingFeedbackSuccess = false
                
                // Show success message in alert
                successMessage = "Thank you for your feedback! It helps us improve our services."
                showSuccessAlert = true
            }
        }
    }
    
    private func downloadResponse() {
        // Simulate download
        isSubmitting = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            
            // Show success message
            successMessage = "Response document downloaded successfully. You can find it in your Downloads folder."
            showSuccessAlert = true
        }
    }
    
    // Helper views for complaint details
    func informationRow(title: String, value: String, color: Color = .primary) -> some View {
        HStack(alignment: .top) {
            Text(title + ":")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(color)
            
            Spacer()
        }
    }
    
    func statusUpdate(date: String, time: String, status: String, details: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(status)
                        .font(.headline)
                    
                    Text("\(date) at \(time)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            
            Text(details)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .padding(.top, 5)
        }
        .padding()
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

struct ActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title3)
            
            Text(title)
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
        }
        .padding()
        .foregroundColor(color)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// Model for sidebar menu item
struct SidebarMenuItem {
    let title: String
    let icon: String
    let action: () -> Void
    let type: MenuItemType
    
    enum MenuItemType {
        case regular
        case separator
    }
}

// View for sidebar menu item
struct SidebarMenuItemView: View {
    let item: SidebarMenuItem
    let action: () -> Void
    
    var body: some View {
        Group {
            if item.type == .separator {
                Divider()
                    .padding(.vertical, 8)
            } else {
                Button(action: action) {
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                            .font(.system(size: 18))
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                        
                        Text(item.title)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    NavigationView {
        DashboardView()
    }
}

// Model for document items
struct DocumentItem: Identifiable {
    let id = UUID()
    let fileName: String
    let complaintId: String
    let uploadDate: String
    let fileType: FileType
    let fileSize: String
    
    enum FileType: String {
        case pdf = "PDF"
        case image = "Image"
        case doc = "Document"
        
        var iconName: String {
            switch self {
            case .pdf: return "doc.text.fill"
            case .image: return "photo.fill"
            case .doc: return "doc.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .pdf: return .red
            case .image: return .blue
            case .doc: return .green
            }
        }
    }
}

// View for displaying documents
struct DocumentsView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var showingPreview = false
    @State private var selectedDocument: DocumentItem? = nil
    @State private var showingActionSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    // Mock data for demonstration
    let documents = [
        DocumentItem(
            fileName: "Complaint_Evidence.pdf",
            complaintId: "JSCMP-2023-12345",
            uploadDate: "05-Oct-2023",
            fileType: .pdf,
            fileSize: "1.2 MB"
        ),
        DocumentItem(
            fileName: "Water_Issue_Photo.jpg",
            complaintId: "JSCMP-2023-12343",
            uploadDate: "15-Sep-2023",
            fileType: .image,
            fileSize: "3.5 MB"
        ),
        DocumentItem(
            fileName: "Electricity_Bill.pdf",
            complaintId: "JSCMP-2023-12344",
            uploadDate: "28-Sep-2023",
            fileType: .pdf,
            fileSize: "0.8 MB"
        ),
        DocumentItem(
            fileName: "Road_Damage_Photo.jpg",
            complaintId: "JSCMP-2023-12345",
            uploadDate: "05-Oct-2023",
            fileType: .image,
            fileSize: "2.7 MB"
        ),
        DocumentItem(
            fileName: "Official_Response.doc",
            complaintId: "JSCMP-2023-12344",
            uploadDate: "30-Sep-2023",
            fileType: .doc,
            fileSize: "0.5 MB"
        )
    ]
    
    var filteredDocuments: [DocumentItem] {
        if searchText.isEmpty {
            return documents
        } else {
            return documents.filter { document in
                document.fileName.lowercased().contains(searchText.lowercased()) ||
                document.complaintId.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search documents", text: $searchText)
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Documents list
                List {
                    ForEach(filteredDocuments) { document in
                        Button(action: {
                            selectedDocument = document
                            showingActionSheet = true
                        }) {
                            HStack(spacing: 16) {
                                // File icon
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(document.fileType.color.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: document.fileType.iconName)
                                        .font(.system(size: 20))
                                        .foregroundColor(document.fileType.color)
                                }
                                
                                // Document details
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(document.fileName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Text(document.complaintId)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Text("•")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Text(document.uploadDate)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    HStack {
                                        Text(document.fileType.rawValue)
                                            .font(.caption2)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(document.fileType.color.opacity(0.2))
                                            .foregroundColor(document.fileType.color)
                                            .cornerRadius(4)
                                        
                                        Text(document.fileSize)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                // Download icon
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button(action: {
                                // View document action
                                showingPreview = true
                            }) {
                                Label("View", systemImage: "eye")
                            }
                            
                            Button(action: {
                                // Download document action
                                // This would trigger actual download in a real app
                                let impactFeedback = UINotificationFeedbackGenerator()
                                impactFeedback.notificationOccurred(.success)
                            }) {
                                Label("Download", systemImage: "arrow.down.circle")
                            }
                            
                            Button(action: {
                                // Share document action
                            }) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Documents", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Done")
                        .fontWeight(.medium)
                }
            )
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text(selectedDocument?.fileName ?? "Document"),
                    message: Text("Choose an action for this document"),
                    buttons: [
                        .default(Text("View")) {
                            showingPreview = true
                        },
                        .default(Text("Download")) {
                            // Simulate download
                            let impactFeedback = UINotificationFeedbackGenerator()
                            impactFeedback.notificationOccurred(.success)
                        },
                        .default(Text("Share")) {
                            // Share functionality would be implemented here
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingPreview) {
                // This would be a preview of the document in a real app
                // For demo purposes, just showing a placeholder
                DocumentPreviewPlaceholder(document: selectedDocument)
            }
        }
    }
}

// Placeholder for document preview (would be replaced with actual preview in real app)
struct DocumentPreviewPlaceholder: View {
    let document: DocumentItem?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // File icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(document?.fileType.color.opacity(0.2) ?? Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: document?.fileType.iconName ?? "doc")
                        .font(.system(size: 50))
                        .foregroundColor(document?.fileType.color ?? .gray)
                }
                
                // File name
                Text(document?.fileName ?? "Document")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // File details
                HStack {
                    Label(document?.fileType.rawValue ?? "Unknown", systemImage: "doc")
                    Spacer()
                    Label(document?.fileSize ?? "0 KB", systemImage: "folder")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Text("This is a document preview placeholder. In a real app, this would display the actual document content.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Download action
                        let impactFeedback = UINotificationFeedbackGenerator()
                        impactFeedback.notificationOccurred(.success)
                    }) {
                        Label("Download", systemImage: "arrow.down.circle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Share action
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
            .navigationBarTitle("Document Preview", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
} 
