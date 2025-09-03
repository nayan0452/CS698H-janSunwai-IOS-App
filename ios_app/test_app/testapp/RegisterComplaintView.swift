//
//  RegisterComplaintView.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI
import MapKit

struct RegisterComplaintView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var isComplaint = true // Toggle between complaint and demand
    @State private var complaintType: String = ""
    @State private var subject: String = ""
    @State private var description: String = ""
    
    // Personal information
    @State private var applicantName: String = ""
    @State private var selectedGender: String = "Male"
    @State private var showingGenderPicker = false
    @State private var mobileNumber: String = ""
    @State private var email: String = ""
    
    // Location related
    @State private var useMapForLocation = true  // Changed to true as default
    @State private var location: String = ""
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showingMapPicker = false
    
    // Administrative hierarchy
    @State private var districtSearch: String = ""
    @State private var showingDistrictDropdown = false
    @State private var selectedDistrict: String = ""
    @State private var tehsilSearch: String = ""
    @State private var showingTehsilDropdown = false
    @State private var selectedTehsil: String = ""
    @State private var thanaSearch: String = ""
    @State private var showingThanaDropdown = false
    @State private var selectedThana: String = ""
    @State private var blockSearch: String = ""
    @State private var showingBlockDropdown = false
    @State private var selectedBlock: String = ""
    @State private var villageSearch: String = ""
    @State private var showingVillageDropdown = false
    @State private var selectedVillage: String = ""
    
    // Document and image upload
    @State private var showingImagePicker = false
    @State private var showingDocumentPicker = false
    @State private var inputImage: UIImage?
    @State private var documentNames: [String] = []
    
    // Form submission
    @State private var showingSubmissionAlert = false
    @State private var showingOTPScreen = false
    @State private var isSubmitting = false
    @State private var otpCode: String = ""
    
    // Validation states - Add these
    @State private var formSubmitted = false
    @State private var showValidationErrors = false
    @State private var emailValidationError = false
    
    // Field focus states with FocusState
    enum Field: Hashable {
        case complaintType, subject, description, applicantName, mobileNumber, email, location
    }
    @FocusState private var focusedField: Field?
    
    // Sample data for dropdowns
    let complaintTypes = ["Water", "Electricity", "Roads", "Sanitation", "Public Services", "Not Sure..."]
    let genderOptions = ["Male", "Female", "Other", "Prefer not to say"]
    
    // Sample administrative data
    let districts = ["Delhi", "Mumbai", "Kolkata", "Chennai", "Bengaluru", "Hyderabad", "Pune", "Ahmedabad"]
    let tehsils = ["Tehsil 1", "Tehsil 2", "Tehsil 3", "Tehsil 4", "Tehsil 5"]
    let thanas = ["Thana 1", "Thana 2", "Thana 3", "Thana 4", "Thana 5"]
    let blocks = ["Block 1", "Block 2", "Block 3", "Block 4", "Block 5"]
    let villages = ["Village 1", "Village 2", "Village 3", "Village 4", "Village 5"]
    
    // New states
    @State private var showSuccessAlert = false
    @State private var showOTPView = false
    @State private var complaintID = ""
    @State private var showSuccessAnimation = false
    
    // Calculate form progress percentage
    var formProgress: Double {
        var completedSteps = 0
        var totalSteps = 5 // Total number of main required sections
        
        // Department selected (Step 1)
        if !complaintType.isEmpty {
            completedSteps += 1
        }
        
        // Subject and description (Step 2)
        if !subject.isEmpty && !description.isEmpty {
            completedSteps += 1
        }
        
        // Applicant information (Step 3)
        if !applicantName.isEmpty && mobileNumber.count == 10 {
            completedSteps += 1
        }
        
        // Location information (Step 4)
        if useMapForLocation {
            if selectedCoordinate != nil {
                completedSteps += 1
            }
        } else {
            if !selectedDistrict.isEmpty {
                completedSteps += 1
            }
        }
        
        // Document/image upload (Step 5) - Optional but counted in progress
        if !documentNames.isEmpty || inputImage != nil {
            completedSteps += 1
        }
        
        return Double(completedSteps) / Double(totalSteps)
    }
    
    // Status text based on progress
    var formProgressText: String {
        let progress = Int(formProgress * 100)
        
        if progress == 0 {
            return "Getting started"
        } else if progress < 25 {
            return "Just started"
        } else if progress < 50 {
            return "Making progress"
        } else if progress < 75 {
            return "Getting there"
        } else if progress < 100 {
            return "Almost done"
        } else {
            return "Ready to submit!"
        }
    }
    
    // Field validation methods
    func isFieldValid(_ field: Field) -> Bool {
        if !showValidationErrors { return true }
        
        switch field {
        case .complaintType:
            return !complaintType.isEmpty
        case .subject:
            return !subject.isEmpty
        case .description:
            return !description.isEmpty
        case .applicantName:
            return !applicantName.isEmpty
        case .mobileNumber:
            return mobileNumber.count == 10
        case .email:
            // Basic email validation
            if email.isEmpty { return true } // Email is optional
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        case .location:
            return useMapForLocation ? selectedCoordinate != nil : !selectedDistrict.isEmpty
        }
    }
    
    // Validation helper method
    func validateField(_ field: Field) {
        if !isFieldValid(field) {
            focusedField = field
        }
    }
    
    // Required field marker
    func requiredFieldMark(for field: Field) -> some View {
        let isRequired = field != .email // All fields except email are required
        
        return Text(isRequired ? " *" : "")
            .foregroundColor(.red)
            .font(.headline)
    }
    
    // Filtered lists based on search
    var filteredDistricts: [String] {
        if districtSearch.isEmpty {
            return districts
        }
        return districts.filter { $0.lowercased().contains(districtSearch.lowercased()) }
    }
    
    var filteredTehsils: [String] {
        if tehsilSearch.isEmpty {
            return tehsils
        }
        return tehsils.filter { $0.lowercased().contains(tehsilSearch.lowercased()) }
    }
    
    var filteredThanas: [String] {
        if thanaSearch.isEmpty {
            return thanas
        }
        return thanas.filter { $0.lowercased().contains(thanaSearch.lowercased()) }
    }
    
    var filteredBlocks: [String] {
        if blockSearch.isEmpty {
            return blocks
        }
        return blocks.filter { $0.lowercased().contains(blockSearch.lowercased()) }
    }
    
    var filteredVillages: [String] {
        if villageSearch.isEmpty {
            return villages
        }
        return villages.filter { $0.lowercased().contains(villageSearch.lowercased()) }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            ScrollView {
                // Add padding at the top to make room for the floating progress bar
                Spacer().frame(height: 65)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header - Fixed to always show "register_complaint"
                    Text("register_complaint".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("complaint_form_description".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                        
                    // Complaint/Demand Toggle
                    VStack(alignment: .leading) {
                        Text("Request Type".localized)
                            .font(.headline)
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                isComplaint = true
                            }) {
                                Text("Complaint".localized)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(isComplaint ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(isComplaint ? .white : .primary)
                            }
                            
                            Button(action: {
                                isComplaint = false
                            }) {
                                Text("Demand".localized)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(!isComplaint ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(!isComplaint ? .white : .primary)
                            }
                        }
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.vertical, 8)
                    }
                    
                    // Complaint type dropdown
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Department".localized)
                                .font(.headline)
                            requiredFieldMark(for: .complaintType)
                        }
                        
                        Picker("", selection: $complaintType) {
                            Text("select Department ".localized).tag("")
                            ForEach(complaintTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showValidationErrors && !isFieldValid(.complaintType) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .focused($focusedField, equals: .complaintType)
                        
                        if showValidationErrors && !isFieldValid(.complaintType) {
                            Text("Please select a department")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Subject field
                    VStack(alignment: .leading) {
                        HStack {
                            Text("subject".localized)
                                .font(.headline)
                            requiredFieldMark(for: .subject)
                        }
                        
                        TextField("subject_placeholder".localized, text: $subject)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(showValidationErrors && !isFieldValid(.subject) ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .focused($focusedField, equals: .subject)
                        
                        if showValidationErrors && !isFieldValid(.subject) {
                            Text("Please enter a subject")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Description field with placeholder
                    VStack(alignment: .leading) {
                        HStack {
                            Text("description".localized)
                                .font(.headline)
                            requiredFieldMark(for: .description)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                                .padding(4)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(showValidationErrors && !isFieldValid(.description) ? Color.red : Color.gray.opacity(0.2), lineWidth: showValidationErrors && !isFieldValid(.description) ? 2 : 1)
                                )
                                .focused($focusedField, equals: .description)
                            
                            if description.isEmpty {
                                Text("Describe your issue, time, severity etc here...")
                                    .foregroundColor(.gray)
                                    .padding(10)
                                    .padding(.top, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                        
                        if showValidationErrors && !isFieldValid(.description) {
                            Text("Please provide a description")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Applicant Information Section - Grouped visually
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Applicant Information".localized)
                            .font(.headline)
                            .padding(.top)
                        
                        // Background container for grouped fields
                        VStack(alignment: .leading, spacing: 16) {
                            // Applicant Name
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Applicant Name".localized)
                                        .font(.subheadline)
                                    requiredFieldMark(for: .applicantName)
                                }
                                
                                TextField("enter name".localized, text: $applicantName)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(showValidationErrors && !isFieldValid(.applicantName) ? Color.red : Color.clear, lineWidth: 2)
                                    )
                                    .focused($focusedField, equals: .applicantName)
                                
                                if showValidationErrors && !isFieldValid(.applicantName) {
                                    Text("Please enter your name")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Gender Selection
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("gender".localized)
                                        .font(.subheadline)
                                    // Gender is pre-selected so no asterisk needed
                                }
                                
                                Button(action: {
                                    showingGenderPicker = true
                                }) {
                                    HStack {
                                        Text(selectedGender)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .actionSheet(isPresented: $showingGenderPicker) {
                                    ActionSheet(
                                        title: Text("select_gender".localized),
                                        buttons: genderOptions.map { gender in
                                            .default(Text(gender)) {
                                                selectedGender = gender
                                            }
                                        } + [.cancel()]
                                    )
                                }
                            }
                            
                            // Mobile Number
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("mobile_number".localized)
                                        .font(.subheadline)
                                    requiredFieldMark(for: .mobileNumber)
                                }
                                
                                TextField("enter_mobile".localized, text: $mobileNumber)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.bottom, 10)
                                    .onChange(of: mobileNumber) { newValue in
                                        // Restrict to 10 digits
                                        if newValue.count > 10 {
                                            mobileNumber = String(newValue.prefix(10))
                                        }
                                        // Remove non-numeric characters
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            mobileNumber = filtered
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(showValidationErrors && (mobileNumber.isEmpty || mobileNumber.count < 10) ? Color.red : Color.clear, lineWidth: 2)
                                    )
                                
                                if showValidationErrors && !isFieldValid(.mobileNumber) {
                                    Text("Please enter a valid 10-digit mobile number")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                } else {
                                    Text("used to generate otp for verification".localized)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 4)
                                }
                            }
                            
                            // Email with example
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("email".localized)
                                        .font(.subheadline)
                                    // Email is optional, no asterisk
                                }
                                
                                TextField("example@gmail.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(showValidationErrors && !isFieldValid(.email) ? Color.red : Color.clear, lineWidth: 2)
                                    )
                                    .focused($focusedField, equals: .email)
                                
                                if showValidationErrors && !isFieldValid(.email) && !email.isEmpty {
                                    Text("Please enter a valid email address")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(12)
                    }
                    
                    // Location Section - Grouped visually
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Location Information".localized)
                                .font(.headline)
                            requiredFieldMark(for: .location)
                            .padding(.top)
                        }
                        
                        // Background container for location fields
                        VStack(alignment: .leading, spacing: 16) {
                            // Location Toggle - Replaced with new implementation
                            VStack(alignment: .leading, spacing: 4) {
                                Text("select_location_method".localized)
                                    .font(.subheadline)
                                
                                // Custom toggle instead of Picker to ensure correct order
                                HStack(spacing: 0) {
                                    Button(action: {
                                        useMapForLocation = true
                                    }) {
                                        Text("select on Map".localized)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth: .infinity)
                                            .background(useMapForLocation ? Color.blue : Color(.systemGray6))
                                            .foregroundColor(useMapForLocation ? .white : .primary)
                                    }
                                    
                                    Button(action: {
                                        useMapForLocation = false
                                    }) {
                                        Text("enter Manually".localized)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth: .infinity)
                                            .background(!useMapForLocation ? Color.blue : Color(.systemGray6))
                                            .foregroundColor(!useMapForLocation ? .white : .primary)
                                    }
                                }
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                .padding(.vertical, 8)
                            }
                            
                            if useMapForLocation {
                                // Map Selection Button
                                Button(action: {
                                    showingMapPicker = true
                                }) {
                                    HStack {
                                        Spacer()
                                        
                                        VStack {
                                            Image(systemName: "map")
                                                .font(.largeTitle)
                                                .foregroundColor(.blue)
                                            
                                            Text(selectedCoordinate != nil ? 
                                                 "location_selected".localized : 
                                                 "select_on_map".localized)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(25)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(showValidationErrors && !isFieldValid(.location) ? Color.red : Color.clear, lineWidth: 2)
                                    )
                                }
                                .sheet(isPresented: $showingMapPicker) {
                                    // In a real app, this would be a proper map picker
                                    VStack {
                                        Text("location_picker_function()".localized)
                                            .font(.headline)
                                            .padding()
                                        
                                        Button("select current location".localized) {
                                            selectedCoordinate = CLLocationCoordinate2D(
                                                latitude: 28.7041,
                                                longitude: 77.1025
                                            )
                                            showingMapPicker = false
                                        }
                                        .padding()
                                        
                                        Button("close".localized) {
                                            showingMapPicker = false
                                        }
                                        .padding()
                                    }
                                }
                                
                                if showValidationErrors && !isFieldValid(.location) {
                                    Text("Please select a location on the map")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                }
                            } else {
                                // Administrative Hierarchy Dropdowns
                                VStack(spacing: 16) {
                                    // District
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("district".localized)
                                                .font(.subheadline)
                                            requiredFieldMark(for: .location)
                                        }
                                        
                                        VStack {
                                            TextField("select district".localized, text: $districtSearch)
                                                .padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                                                .onChange(of: districtSearch) { _ in
                                                    showingDistrictDropdown = districtSearch.count > 1
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(showValidationErrors && !useMapForLocation && selectedDistrict.isEmpty ? Color.red : Color.clear, lineWidth: 2)
                                                )
                                            
                                            if showingDistrictDropdown && !filteredDistricts.isEmpty {
                                                ScrollView {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        ForEach(filteredDistricts, id: \.self) { district in
                                                            Button(action: {
                                                                selectedDistrict = district
                                                                districtSearch = district
                                                                showingDistrictDropdown = false
                                                            }) {
                                                                Text(district)
                                                                    .padding()
                                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                                    .background(
                                                                        district == selectedDistrict ? 
                                                                        Color.blue.opacity(0.1) : Color.clear
                                                                    )
                                                            }
                                                            .foregroundColor(.primary)
                                                            
                                                            Divider()
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 200)
                                                .background(Color(.systemBackground))
                                                .cornerRadius(8)
                                                .shadow(radius: 2)
                                                .zIndex(1)
                                            }
                                        }
                                        
                                        if showValidationErrors && !useMapForLocation && selectedDistrict.isEmpty {
                                            Text("Please select a district")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    // Tehsil
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("tehsil".localized)
                                            .font(.subheadline)
                                        
                                        VStack {
                                            TextField("select tehsil".localized, text: $tehsilSearch)
                                                .padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                                                .onChange(of: tehsilSearch) { _ in
                                                    showingTehsilDropdown = tehsilSearch.count > 1
                                                }
                                            
                                            if showingTehsilDropdown && !filteredTehsils.isEmpty {
                                                ScrollView {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        ForEach(filteredTehsils, id: \.self) { tehsil in
                                                            Button(action: {
                                                                selectedTehsil = tehsil
                                                                tehsilSearch = tehsil
                                                                showingTehsilDropdown = false
                                                            }) {
                                                                Text(tehsil)
                                                                    .padding()
                                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                                    .background(
                                                                        tehsil == selectedTehsil ? 
                                                                        Color.blue.opacity(0.1) : Color.clear
                                                                    )
                                                            }
                                                            .foregroundColor(.primary)
                                                            
                                                            Divider()
                                                        }
                                                    }
                                                }
                                                .frame(maxHeight: 200)
                                                .background(Color(.systemBackground))
                                                .cornerRadius(8)
                                                .shadow(radius: 2)
                                                .zIndex(1)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Uploads Section
                Group {
                    // Photo upload
                    VStack(alignment: .leading) {
                        Text("upload_photo".localized)
                            .font(.headline)
                            .padding(.top)
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            HStack {
                                Spacer()
                                
                                if let image = inputImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                } else {
                                    VStack {
                                        Image(systemName: "camera.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue)
                                        
                                        Text("add_photo".localized)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(25)
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            // In a real app, this would be a proper image picker
                            VStack {
                                Text("image_picker_placeholder".localized)
                                    .font(.headline)
                                    .padding()
                                
                                Button("close".localized) {
                                    showingImagePicker = false
                                }
                                .padding()
                            }
                        }
                    }
                    
                    // Document upload
                    VStack(alignment: .leading) {
                        Text("upload_documents".localized)
                            .font(.headline)
                            .padding(.top)
                        
                        Button(action: {
                            showingDocumentPicker = true
                        }) {
                            HStack {
                                Spacer()
                                
                                if documentNames.isEmpty {
                                    VStack {
                                        Image(systemName: "doc.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue)
                                        
                                        Text("add_documents".localized)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(25)
                                } else {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ForEach(documentNames, id: \.self) { name in
                                            HStack {
                                                Image(systemName: "doc.fill")
                                                    .foregroundColor(.blue)
                                                Text(name)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                Button(action: {
                                                    if let index = documentNames.firstIndex(of: name) {
                                                        documentNames.remove(at: index)
                                                    }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        }
                                        
                                        Button(action: {
                                            showingDocumentPicker = true
                                        }) {
                                            Text("add_more".localized)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.top, 5)
                                    }
                                    .padding()
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showingDocumentPicker) {
                            // In a real app, this would be a proper document picker
                            VStack {
                                Text("document_picker_placeholder".localized)
                                    .font(.headline)
                                    .padding()
                                
                                Button("select_document".localized) {
                                    // Simulate adding a document
                                    let fileName = "Document_\(documentNames.count + 1).pdf"
                                    documentNames.append(fileName)
                                    showingDocumentPicker = false
                                }
                                .padding()
                                
                                Button("close".localized) {
                                    showingDocumentPicker = false
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                // Submit button
                Button(action: {
                    showValidationErrors = true
                    
                    // First validate all fields
                    if isFormInvalid {
                        // Find the first invalid field and focus on it
                        if !isFieldValid(.complaintType) {
                            focusedField = .complaintType
                        } else if !isFieldValid(.subject) {
                            focusedField = .subject
                        } else if !isFieldValid(.description) {
                            focusedField = .description
                        } else if !isFieldValid(.applicantName) {
                            focusedField = .applicantName
                        } else if !isFieldValid(.mobileNumber) {
                            focusedField = .mobileNumber
                        } else if !isFieldValid(.email) && !email.isEmpty {
                            focusedField = .email
                        } else if !isFieldValid(.location) {
                            focusedField = .location
                        }
                        return
                    }
                    
                    // Validate mobile number has 10 digits
                    if mobileNumber.count != 10 {
                        showValidationErrors = true
                        focusedField = .mobileNumber
                        return
                    }
                    
                    // All validation passed, proceed with submission
                    isSubmitting = true
                    
                    // Generate the complaint ID now
                    complaintID = generateComplaintID()
                    
                    // Simulate OTP sending
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isSubmitting = false
                        showOTPView = true
                    }
                }) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.trailing, 5)
                        }
                        
                        Text(isSubmitting ? "sending_otp".localized : "submit".localized)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSubmitting ? Color.blue.opacity(0.7) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isSubmitting)
                .sheet(isPresented: $showOTPView) {
                    OTPVerificationView(
                        mobileNumber: mobileNumber,
                        otpCode: $otpCode,
                        onVerify: onVerifyOTP
                    )
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(
                        title: Text("success_title".localized),
                        message: Text("complaint_registered".localized + "\n\n" + "complaint_id".localized + ": \(complaintID)"),
                        dismissButton: .default(Text("ok".localized)) {
                            // Reset form after successful submission
                            resetForm()
                        }
                    )
                }
                
                Spacer(minLength: 50)
            }
            .padding()
            
            // Floating progress bar at the top
            VStack {
                ZStack {
                    // Progress bar background
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .frame(height: 60)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, y: 2)
                    
                    VStack(spacing: 4) {
                        // Progress text
                        Text(formProgressText)
                            .font(.headline)
                            .padding(.top, 8)
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background bar
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                // Progress indicator
                                Rectangle()
                                    .fill(formProgress == 1.0 ? Color.green : Color.blue)
                                    .frame(width: max(geometry.size.width * CGFloat(formProgress), 0), height: 8)
                                    .cornerRadius(4)
                                    .animation(.easeInOut, value: formProgress)
                            }
                        }
                        .frame(height: 8)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
                .frame(height: 60)
                
                Spacer()
            }
            
            // Success animation overlay
            if showSuccessAnimation {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green)
                            .aspectRatio(contentMode: .fit)
                            .shadow(color: .white.opacity(0.5), radius: 10)
                        
                        Text("complaint_registered".localized)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                    }
                    .padding(40)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(20)
                    .shadow(radius: 15)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: showSuccessAnimation)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                // Use SwiftUI's environment method to go back
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.white)
            }
        )
    }
    
    // Validation check for form
    var isFormInvalid: Bool {
        // Check all required fields
        return !isFieldValid(.complaintType) || 
               !isFieldValid(.subject) || 
               !isFieldValid(.description) || 
               !isFieldValid(.applicantName) || 
               !isFieldValid(.mobileNumber) || 
               !isFieldValid(.location) ||
               (!email.isEmpty && !isFieldValid(.email)) // Only validate email if provided
    }
    
    // Add a method to generate a random complaint ID
    func generateComplaintID() -> String {
        let prefix = "JS"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateComponent = dateFormatter.string(from: Date())
        let randomComponent = String(format: "%04d", Int.random(in: 1000...9999))
        
        return "\(prefix)-\(dateComponent)-\(randomComponent)"
    }
    
    // Reset form
    func resetForm() {
        isComplaint = true
        complaintType = ""
        subject = ""
        description = ""
        applicantName = ""
        selectedGender = "Male"
        showingGenderPicker = false
        mobileNumber = ""
        email = ""
        useMapForLocation = true
        location = ""
        selectedCoordinate = nil
        showingMapPicker = false
        districtSearch = ""
        showingDistrictDropdown = false
        selectedDistrict = ""
        tehsilSearch = ""
        showingTehsilDropdown = false
        selectedTehsil = ""
        thanaSearch = ""
        showingThanaDropdown = false
        selectedThana = ""
        blockSearch = ""
        showingBlockDropdown = false
        selectedBlock = ""
        villageSearch = ""
        showingVillageDropdown = false
        selectedVillage = ""
        showingImagePicker = false
        showingDocumentPicker = false
        inputImage = nil
        documentNames = []
        showValidationErrors = false
        emailValidationError = false
        focusedField = nil
    }
    
    // Update the onVerifyOTP closure to show success with complaint ID
    var onVerifyOTP: () -> Void {
        return {
            // Show success animation first
            self.showSuccessAnimation = true
            self.showOTPView = false
            
            // Provide haptic feedback for success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // After a short delay, show the success alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.showSuccessAnimation = false
                self.showSuccessAlert = true
            }
        }
    }
}

// OTPVerificationView is now in a separate file: OTPVerificationView.swift

struct RegisterComplaintView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterComplaintView()
    }
} 
