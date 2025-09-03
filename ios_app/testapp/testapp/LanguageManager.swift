//
//  LanguageManager.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import Foundation
import SwiftUI
import Combine

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case hindi = "hi"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "हिन्दी"
        }
    }
    
    var flagEmoji: String {
        switch self {
        case .english: return "🇺🇸"
        case .hindi: return "🇮🇳"
        }
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: Language = .english {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
            self.objectWillChange.send()
        }
    }
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        }
    }
    
    func setLanguage(_ language: Language) {
        self.currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "AppLanguage")
        self.objectWillChange.send()
    }
    
    // MARK: - Translation Dictionaries
    
    private let englishTranslations: [String: String] = [
        // App Title
        "app_title": "JanSunwai",
        
        // Welcome Screen
        "welcome": "Welcome to JanSunwai",
        "app_description": "A platform to register and track your complaints and grievances with government departments",
        "login": "Login",
        "register_complaint": "Register New Complaint (without Login)",
        "track_complaint": "Track Complaint (Complaint ID)",
        "help_support": "Help & Support",
        "privacy_message": "We respect your privacy. This app only requests permissions that are essential for its functioning.",
        "have_an_account": "Have an account?",
        
        // Login Screen
        "login_title": "Sign in to JanSunwai",
        "login_description": "Please enter your registered mobile number to receive OTP for login",
        "mobile_number": "Mobile Number",
        "mobile_placeholder": "10-digit mobile number",
        "send_otp": "Send OTP",
        "resend_otp_in": "Resend OTP in",
        "enter_otp": "Enter OTP",
        "otp_placeholder": "6-digit OTP",
        "need_help": "Need help?",
        "login_support_message": "Having trouble logging in? Call our support at 1800-XXX-XXXX",
        "back": "Back",
        
        // General
        "ok": "OK",
        "cancel": "Cancel",
        "close": "Close",
        "select": "Select",
        "submit": "Submit",
        "submitting": "Submitting...",
        "success": "Success",
        "error": "Error",
        "logout": "Logout",
        "select_language": "Select Language",
        "details": "Details",
        "getting_started": "Getting started",
        "just_started": "Just started",
        "making_progress": "Making progress",
        "getting_there": "Getting there", 
        "almost_done": "Almost done",
        "ready_to_submit": "Ready to submit!",
        
        // Validation Messages
        "please_select_department": "Please select a department",
        "please_enter_subject": "Please enter a subject",
        "please_provide_description": "Please provide a description",
        "please_enter_name": "Please enter your name",
        "please_valid_mobile": "Please enter a valid 10-digit mobile number",
        "please_valid_email": "Please enter a valid email address",
        "please_select_location": "Please select a location on the map",
        "please_select_district": "Please select a district",
        
        // Tab Titles
        "dashboard": "Dashboard",
        "new_complaint": "New Complaint",
        "track": "Track",
        "profile": "Profile",
        
        // Dashboard
        "welcome_user": "Welcome, User",
        "dashboard_description": "Your complaints dashboard",
        "total": "Total",
        "pending": "Pending",
        "resolved": "Resolved",
        "recent_complaints": "Recent Complaints",
        "complaint_status": "Status",
        "status_pending": "Pending",
        "status_in_progress": "In Progress",
        "status_resolved": "Resolved",
        "water_issue": "Water Issue",
        "electricity_issue": "Electricity Issue",
        "road_repair": "Road Repair",
        
        // Register Complaint Form
        "complaint_form_description": "Fill out the form below to submit a new complaint",
        "complaint_type": "Complaint Type",
        "subject": "Subject",
        "subject_placeholder": "Enter complaint subject",
        "description": "Description",
        "location": "Location",
        "location_placeholder": "Enter location of issue",
        "upload_photo": "Upload Photo",
        "add_photo": "Add Photo",
        "image_picker_placeholder": "Image Picker (Placeholder)",
        "complaint_submitted": "Your complaint has been submitted successfully. Your reference number is JSCMP-2023-12345",
        "request_type": "Request Type",
        "complaint": "Complaint",
        "demand": "Demand",
        
        "select_department": "Select Department",
        "describe_issue": "Describe your issue, time, severity etc here...",
        "applicant_information": "Applicant Information",
        "applicant_name": "Applicant Name",
        "enter_name": "Enter name",
        "gender": "Gender",
        "select_gender": "Select Gender",
        "male": "Male",
        "female": "Female",
        "other": "Other",
        "prefer_not_to_say": "Prefer not to say",
        "used_for_otp": "Used to generate OTP for verification",
        
        "location_information": "Location Information",
        "select_location_method": "Select Location Method",
        "select_on_map": "Select on Map",
        "enter_manually": "Enter Manually",
        "location_selected": "Location Selected",
        "location_picker_function": "Location Picker Function",
        "select_current_location": "Select Current Location",
        "district": "District",
        "select_district": "Select District",
        "tehsil": "Tehsil",
        "select_tehsil": "Select Tehsil",
        "thana": "Thana",
        "select_thana": "Select Thana",
        "block": "Block",
        "select_block": "Select Block",
        "village_panchayat": "Village/Panchayat",
        "select_village_panchayat": "Select Village/Panchayat",
        "upload_documents": "Upload Documents",
        "add_documents": "Add Documents",
        "document_picker_placeholder": "Document Picker (Placeholder)",
        "select_document": "Select Document",
        "add_more": "Add More",
        
        // Tracking
        "track_complaints": "Track Complaints",
        "track_your_complaint": "Track Your Complaint",
        "enter_details_prompt": "Enter your complaint ID and registered mobile number",
        "complaint_id": "Complaint ID",
        "enter_complaint_id": "Enter complaint ID",
        "track_button": "Track Complaint",
        "complaint_details": "Complaint Details",
        "tracking_subject": "Subject",
        "department": "Department",
        "date_filed": "Date Filed",
        "status": "Status",
        "status_updates": "Status Updates",
        "provide_feedback": "Provide Feedback",
        
        "satisfaction_question": "How satisfied are you with the response?",
        "very_satisfied": "Very Satisfied",
        "satisfied": "Satisfied",
        "neutral": "Neutral", 
        "dissatisfied": "Dissatisfied",
        "very_dissatisfied": "Very Dissatisfied",
        "enter_complaint_id_placeholder": "Enter your complaint ID (e.g., JSCMP-20230501-1234)",
        "complaint_id_info": "Your complaint ID can be found in the SMS or email you received after submission.",
        "id_prefix": "ID: ",
        
        // Help & Support
        "help_description": "This is a prototype of an improved JanSunwai app addressing key usability issues:",
        "simplified_navigation": "Simplified navigation",
        "consistent_language": "Consistent language support",
        "improved_form_design": "Improved form design",
        "better_feedback": "Better feedback system",
        "reduced_permissions": "Reduced permission requests",
        "faq_title": "Frequently Asked Questions",
        "faq_register_question": "How do I register a complaint?",
        "faq_register_answer": "From the home screen, tap on 'Register New Complaint'. Fill in the required details and submit the form.",
        "faq_track_question": "How can I check the status of my complaint?",
        "faq_track_answer": "Use the 'Track Complaint' option from the home screen. Enter your complaint ID and mobile number to view the current status.",
        "faq_forgot_id_question": "I forgot my complaint ID. What should I do?",
        "faq_forgot_id_answer": "If you're logged in, you can view all your complaints in the dashboard. Otherwise, contact our support team for assistance.",
        "faq_language_question": "How do I change the language?",
        "faq_language_answer": "You can change the language using the selector at the top of the home screen.",
        "contact_info": "Contact Information",
        "toll_free": "Toll-free",
        "ministry_name": "Ministry of Administrative Reforms and Public Grievances",
        
        // Profile
        "profile_title": "Your Profile",
        "personal_details": "Personal Details",
        "name": "Name",
        "email": "Email",
        "phone": "Phone",
        "address": "Address",
        "edit_profile": "Edit Profile",
        "account_settings": "Account Settings",
        "notification_preferences": "Notification Preferences",
        "privacy_settings": "Privacy Settings",
        "app_settings": "App Settings",
        "dark_mode": "Dark Mode",
        
        // Dashboard translations
        "dashboard_title": "Dashboard",
        "dashboard_title_hi": "डैशबोर्ड",
        
        // Success messages
        "success_title": "Success!",
        "success_title_hi": "सफलता!",
        "complaint_registered": "Complaint Successfully Registered!",
        "complaint_registered_hi": "शिकायत सफलतापूर्वक पंजीकृत!",
        
        // Feedback specific
        "rate_your_experience": "Rate Your Experience",
        "help_us_improve": "Help us improve by sharing your feedback",
        "tell_us_about_experience": "Tell us about your experience...",
        "submit_feedback": "Submit Feedback",
        "thank_you": "Thank You!",
        "feedback_submitted": "Your feedback has been submitted successfully.",
        "we_value_feedback": "We value your feedback",
        "please_tell_experience": "Please tell us about your experience with this complaint",
        "feedback": "Feedback",
        "additional_comments": "Additional comments",
        "optional": "(optional)",
        "privacy_notice": "Your feedback helps us improve our services. No personal information is collected through this form.",
        "how_rate_experience": "How would you rate your experience?",
        
        // Escalation
        "escalate_matter": "Escalate Matter",
        "escalate_complaint": "Escalate Complaint",
        "escalation_description": "If you're not satisfied with the current progress of your complaint, you can escalate it to a higher authority.",
        "search_another_complaint": "Search Another Complaint",
        "what_happens_next": "What happens next?",
        "next_steps_desc": "Your complaint will be reviewed by a senior official who will take appropriate action.",
        "response_time": "Response time",
        "response_time_desc": "You should receive a response within 7 working days after escalation.",
        "higher_authority": "Higher authority",
        "higher_authority_desc": "Your complaint will be forwarded to the department head or district administration.",
        "reason_escalation": "Reason for Escalation",
        "explain_escalation": "Please explain why you are escalating this complaint...",
        "submit_escalation": "Submit Escalation Request",
        "escalation_note": "Note: Escalation should only be used if you believe your complaint is not being addressed properly.",
        "request_submitted": "Request Submitted",
        "escalation_success": "Your escalation request has been submitted successfully. You will be notified of the progress.",
        
        // Download
        "download": "Download",
        "download_response": "Download Response",
        "download_prompt": "Would you like to download the official response document for this complaint?",
        
        // Sidebar and menu items
        "documents": "Documents",
        "settings": "Settings",
        "my_profile": "My Profile",
        "sign_out": "Sign Out",
        
        // New translations
        "app_version": "App version 1.0.0",
        "all_complaints": "All Complaints",
        "pending_complaints": "Pending Complaints",
        "resolved_complaints": "Resolved Complaints",
        "sms_alerts": "SMS Alerts",
        "notification": "Notification",
        "home": "Home"
    ]
    
    private let hindiTranslations: [String: String] = [
        // App Title
        "app_title": "जनसुनवाई",
        
        // Welcome Screen
        "welcome": "जनसुनवाई में आपका स्वागत है",
        "app_description": "सरकारी विभागों के साथ अपनी शिकायतों और शिकायतों को पंजीकृत करने और ट्रैक करने के लिए एक मंच",
        "login": "लॉगिन",
        "register_complaint": "नई शिकायत दर्ज करें",
        "track_complaint": "शिकायत ट्रैक करें",
        "help_support": "सहायता और समर्थन",
        "privacy_message": "हम आपकी गोपनीयता का सम्मान करते हैं। यह ऐप केवल उन अनुमतियों का अनुरोध करता है जो इसके कार्य के लिए आवश्यक हैं।",
        "have_an_account": "क्या आपका खाता है?",
        
        // Login Screen
        "login_title": "जनसुनवाई में साइन इन करें",
        "login_description": "लॉगिन के लिए OTP प्राप्त करने के लिए कृपया अपना पंजीकृत मोबाइल नंबर दर्ज करें",
        "mobile_number": "मोबाइल नंबर",
        "mobile_placeholder": "10-अंकों का मोबाइल नंबर",
        "send_otp": "OTP भेजें",
        "resend_otp_in": "OTP पुनः भेजें",
        "enter_otp": "OTP दर्ज करें",
        "otp_placeholder": "6-अंकों का OTP",
        "need_help": "मदद चाहिए?",
        "login_support_message": "लॉगिन करने में परेशानी हो रही है? हमारे सपोर्ट को 1800-XXX-XXXX पर कॉल करें",
        "back": "वापस",
        
        // General
        "ok": "ठीक है",
        "cancel": "रद्द करें",
        
        "select": "चुनें",
        "submit": "जमा करें",
        "submitting": "प्रस्तुत कर रहा है...",
        "success": "सफलता",
        "error": "त्रुटि",
        "logout": "लॉग आउट",
        "select_language": "भाषा चुनें",
        "details": "विवरण",
        "getting_started": "शुरू कर रहे हैं",
        "just_started": "अभी शुरू किया",
        "making_progress": "प्रगति कर रहे हैं",
        "getting_there": "पहुंच रहे हैं", 
        "almost_done": "लगभग पूरा हुआ",
        "ready_to_submit": "जमा करने के लिए तैयार!",
        
        // Validation Messages
        "please_select_department": "कृपया एक विभाग चुनें",
        "please_enter_subject": "कृपया विषय दर्ज करें",
        "please_provide_description": "कृपया विवरण प्रदान करें",
        "please_enter_name": "कृपया अपना नाम दर्ज करें",
        "please_valid_mobile": "कृपया एक वैध 10-अंकों का मोबाइल नंबर दर्ज करें",
        "please_valid_email": "कृपया एक वैध ईमेल पता दर्ज करें",
        "please_select_location": "कृपया मानचित्र पर एक स्थान चुनें",
        "please_select_district": "कृपया एक जिला चुनें",
        
        // Tab Titles
        "dashboard": "डैशबोर्ड",
        "new_complaint": "नई शिकायत",
        "track": "ट्रैक",
        "profile": "प्रोफाइल",
        
        // Dashboard
        "welcome_user": "स्वागत है, उपयोगकर्ता",
        "dashboard_description": "आपका शिकायत डैशबोर्ड",
        "total": "कुल",
        "pending": "लंबित",
        "resolved": "हल किया गया",
        "recent_complaints": "हाल की शिकायतें",
        "complaint_status": "स्थिति",
        "status_pending": "लंबित",
        "status_in_progress": "प्रगति पर",
        "status_resolved": "हल किया गया",
        "water_issue": "पानी की समस्या",
        "electricity_issue": "बिजली की समस्या",
        "road_repair": "सड़क मरम्मत",
        
        // Register Complaint Form
        "complaint_form_description": "नई शिकायत जमा करने के लिए नीचे दिया गया फॉर्म भरें",
        "complaint_type": "शिकायत प्रकार",
        "subject": "विषय",
        "subject_placeholder": "शिकायत का विषय दर्ज करें",
        "description": "विवरण",
        
        "location_placeholder": "समस्या का स्थान दर्ज करें",
        "upload_photo": "फोटो अपलोड करें",
        "add_photo": "फोटो जोड़ें",
        "image_picker_placeholder": "इमेज पिकर (प्लेसहोल्डर)",
        "complaint_submitted": "आपकी शिकायत सफलतापूर्वक जमा कर दी गई है। आपका संदर्भ नंबर है JSCMP-2023-12345",
        "request_type": "अनुरोध प्रकार",
        "complaint": "शिकायत",
        "demand": "मांग",
        
        "select_department": "विभाग चुनें",
        "describe_issue": "अपनी समस्या, समय, गंभीरता आदि का वर्णन यहां करें...",
        "applicant_information": "आवेदक की जानकारी",
        "applicant_name": "आवेदक का नाम",
        "enter_name": "नाम दर्ज करें",
        "gender": "लिंग",
        "select_gender": "लिंग चुनें",
        "male": "पुरुष",
        "female": "महिला",
        "other": "अन्य",
        "prefer_not_to_say": "कहना नहीं चाहते",
        "used_for_otp": "सत्यापन के लिए OTP जनरेट करने के लिए उपयोग किया जाता है",
        "email": "ईमेल",
        "location_information": "स्थान की जानकारी",
        "select_location_method": "स्थान चयन विधि चुनें",
        "select_on_map": "मानचित्र पर चुनें",
        "enter_manually": "मैन्युअल रूप से दर्ज करें",
        "location_selected": "स्थान चुना गया",
        "location_picker_function": "स्थान चयनकर्ता फ़ंक्शन",
        "select_current_location": "वर्तमान स्थान चुनें",
        "district": "जिला",
        "select_district": "जिला चुनें",
        "tehsil": "तहसील",
        "select_tehsil": "तहसील चुनें",
        "thana": "थाना",
        "select_thana": "थाना चुनें",
        "block": "ब्लॉक",
        "select_block": "ब्लॉक चुनें",
        "village_panchayat": "गांव/पंचायत",
        "select_village_panchayat": "गांव/पंचायत चुनें",
        "upload_documents": "दस्तावेज़ अपलोड करें",
        "add_documents": "दस्तावेज़ जोड़ें",
        "document_picker_placeholder": "दस्तावेज़ चयनकर्ता (प्लेसहोल्डर)",
        "select_document": "दस्तावेज़ चुनें",
        "add_more": "और जोड़ें",
        
        // Tracking
        "track_complaints": "शिकायतें ट्रैक करें",
        "track_your_complaint": "अपनी शिकायत ट्रैक करें",
        "enter_details_prompt": "अपनी शिकायत आईडी और पंजीकृत मोबाइल नंबर दर्ज करें",
        "complaint_id": "शिकायत आईडी",
        "enter_complaint_id": "शिकायत आईडी दर्ज करें",
        "track_button": "ट्रैक करें",
        "complaint_details": "शिकायत विवरण",
        "tracking_subject": "विषय",
        "department": "विभाग",
        "date_filed": "दायर करने की तिथि",
        "status": "स्थिति",
        "status_updates": "स्थिति अपडेट",
        "provide_feedback": "प्रतिक्रिया दें",
        
        "satisfaction_question": "आप प्रतिक्रिया से कितने संतुष्ट हैं?",
        "very_satisfied": "बहुत संतुष्ट",
        "satisfied": "संतुष्ट",
        "neutral": "तटस्थ",
        "dissatisfied": "असंतुष्ट",
        "very_dissatisfied": "बहुत असंतुष्ट",
        "enter_complaint_id_placeholder": "अपनी शिकायत आईडी दर्ज करें (उदाहरण के लिए, JSCMP-20230501-1234)",
        "complaint_id_info": "आपकी शिकायत आईडी आपको शिकायत जमा करने के बाद प्राप्त SMS या ईमेल में मिल सकती है।",
        "id_prefix": "आईडी: ",
        "location": "स्थान",
        
        // Help & Support
        "help_description": "यह एक बेहतर जनसुनवाई ऐप का प्रोटोटाइप है जो प्रमुख उपयोगिता समस्याओं को संबोधित करता है:",
        "simplified_navigation": "सरलीकृत नेविगेशन",
        "consistent_language": "सुसंगत भाषा समर्थन",
        "improved_form_design": "बेहतर फॉर्म डिज़ाइन",
        "better_feedback": "बेहतर प्रतिक्रिया प्रणाली",
        "reduced_permissions": "कम अनुमति अनुरोध",
        "faq_title": "अक्सर पूछे जाने वाले प्रश्न",
        "faq_register_question": "मैं शिकायत कैसे दर्ज करूं?",
        "faq_register_answer": "होम स्क्रीन से, 'नई शिकायत दर्ज करें' पर टैप करें। आवश्यक विवरण भरें और फॉर्म जमा करें।",
        "faq_track_question": "मैं अपनी शिकायत की स्थिति कैसे जांच सकता हूं?",
        "faq_track_answer": "होम स्क्रीन से 'शिकायत ट्रैक करें' विकल्प का उपयोग करें। वर्तमान स्थिति देखने के लिए अपनी शिकायत आईडी और मोबाइल नंबर दर्ज करें।",
        "faq_forgot_id_question": "मैं अपनी शिकायत आईडी भूल गया। मुझे क्या करना चाहिए?",
        "faq_forgot_id_answer": "यदि आप लॉग इन हैं, तो आप डैशबोर्ड में अपनी सभी शिकायतें देख सकते हैं। अन्यथा, सहायता के लिए हमारी सहायता टीम से संपर्क करें।",
        "faq_language_question": "मैं भाषा कैसे बदलूं?",
        "faq_language_answer": "आप होम स्क्रीन के शीर्ष पर भाषा चयनकर्ता का उपयोग करके भाषा बदल सकते हैं।",
        "contact_info": "संपर्क जानकारी",
        "toll_free": "टोल-फ्री",
        "ministry_name": "प्रशासनिक सुधार और लोक शिकायत मंत्रालय",
        
        // Profile
        "profile_title": "आपका प्रोफाइल",
        "personal_details": "व्यक्तिगत विवरण",
        "name": "नाम",
        
        "phone": "फोन",
        "address": "पता",
        "edit_profile": "प्रोफाइल संपादित करें",
        "account_settings": "खाता सेटिंग्स",
        "notification_preferences": "अधिसूचना प्राथमिकताएँ",
        "privacy_settings": "गोपनीयता सेटिंग्स",
        "app_settings": "एप्लिकेशन सेटिंग्स",
        "dark_mode": "डार्क मोड",
        
        // Dashboard translations
        "dashboard_title": "डैशबोर्ड",
        "dashboard_title_hi": "डैशबोर्ड",
        
        // Success messages
        "success_title": "सफलता!",
        "success_title_hi": "सफलता!",
        "complaint_registered": "शिकायत सफलतापूर्वक पंजीकृत!",
        "complaint_registered_hi": "शिकायत सफलतापूर्वक पंजीकृत!",
        
        // Feedback specific
        "rate_your_experience": "अपने अनुभव का मूल्यांकन करें",
        "help_us_improve": "अपनी प्रतिक्रिया साझा करके हमें सुधार करने में मदद करें",
        "tell_us_about_experience": "अपने अनुभव के बारे में हमें बताएं...",
        "submit_feedback": "प्रतिक्रिया जमा करें",
        "thank_you": "धन्यवाद!",
        "feedback_submitted": "आपकी प्रतिक्रिया सफलतापूर्वक जमा कर दी गई है।",
        "close": "बंद करें",
        "we_value_feedback": "हम आपकी प्रतिक्रिया को महत्व देते हैं",
        "please_tell_experience": "कृपया हमें इस शिकायत के साथ अपने अनुभव के बारे में बताएं",
        "feedback": "प्रतिक्रिया",
        "additional_comments": "अतिरिक्त टिप्पणियाँ",
        "optional": "(वैकल्पिक)",
        "privacy_notice": "आपकी प्रतिक्रिया हमें अपनी सेवाओं में सुधार करने में मदद करती है। इस फॉर्म के माध्यम से कोई व्यक्तिगत जानकारी एकत्र नहीं की जाती है।",
        "how_rate_experience": "आप अपने अनुभव का मूल्यांकन कैसे करेंगे?",
        
        // Escalation
        "escalate_matter": "मामला बढ़ाएं",
        "escalate_complaint": "शिकायत बढ़ाएं",
        "escalation_description": "यदि आप अपनी शिकायत की वर्तमान प्रगति से संतुष्ट नहीं हैं, तो आप इसे उच्च अधिकारी तक बढ़ा सकते हैं।",
        "search_another_complaint": "अन्य शिकायत खोजें",
        "what_happens_next": "आगे क्या होगा?",
        "next_steps_desc": "आपकी शिकायत की समीक्षा एक वरिष्ठ अधिकारी द्वारा की जाएगी जो उचित कार्रवाई करेगा।",
        "response_time": "प्रतिक्रिया समय",
        "response_time_desc": "आपको शिकायत बढ़ाने के 7 कार्य दिवसों के भीतर प्रतिक्रिया मिलनी चाहिए।",
        "higher_authority": "उच्च अधिकारी",
        "higher_authority_desc": "आपकी शिकायत विभाग प्रमुख या जिला प्रशासन को अग्रेषित की जाएगी।",
        "reason_escalation": "शिकायत बढ़ाने का कारण",
        "explain_escalation": "कृपया बताएं कि आप इस शिकायत को क्यों बढ़ा रहे हैं...",
        "submit_escalation": "शिकायत बढ़ाने का अनुरोध जमा करें",
        "escalation_note": "नोट: शिकायत बढ़ाने का उपयोग केवल तभी किया जाना चाहिए जब आपको लगता है कि आपकी शिकायत का उचित रूप से समाधान नहीं किया जा रहा है।",
        "request_submitted": "अनुरोध जमा किया गया",
        "escalation_success": "आपका शिकायत बढ़ाने का अनुरोध सफलतापूर्वक जमा कर दिया गया है। आपको प्रगति के बारे में सूचित किया जाएगा।",
        
        // Download
        "download": "डाउनलोड",
        "download_response": "प्रतिक्रिया डाउनलोड करें",
        "download_prompt": "क्या आप इस शिकायत के लिए आधिकारिक प्रतिक्रिया दस्तावेज़ डाउनलोड करना चाहते हैं?",
        
        // Sidebar and menu items
        "documents": "दस्तावेज़",
        "settings": "सेटिंग्स",
        "my_profile": "मेरा प्रोफाइल",
        "sign_out": "साइन आउट",
        
        // New translations
        "app_version": "ऐप संस्करण 1.0.0",
        "all_complaints": "सभी शिकायतें",
        "pending_complaints": "लंबित शिकायतें",
        "resolved_complaints": "हल की गई शिकायतें",
        "sms_alerts": "एसएमएस अलर्ट",
        "notification": "अधिसूचना",
        "home": "होम"
    ]
    
    // Primary localization function - use this for all keys
    func localizedString(for key: String) -> String {
        switch currentLanguage {
        case .english:
            return englishTranslations[key] ?? key
        case .hindi:
            return hindiTranslations[key] ?? key
        }
    }
    
    // Maintained for backwards compatibility - forwards to localizedString
    func localize(_ key: String) -> String {
        return localizedString(for: key)
    }
    
    // Helper for SwiftUI bindings
    func bindingForKey(_ key: String) -> Binding<String> {
        Binding<String>(
            get: { self.localizedString(for: key) },
            set: { _ in }
        )
    }
}

// This extension is redundant with the one in StringExtension.swift
// and should be removed to avoid confusion
/*
extension String {
    var localized: String {
        return LanguageManager.shared.localize(self)
    }
}
*/ 
