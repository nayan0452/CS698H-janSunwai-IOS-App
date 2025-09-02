# JanSunwai iOS App

This is the iOS version of the JanSunwai application, designed to address key usability issues in the public grievance redressal system.

## Project Overview

The JanSunwai iOS app is a SwiftUI implementation of the public grievance redressal system that allows citizens to register, track, and manage complaints with government departments.

## Key Features

- **Simplified Navigation**: Clear, intuitive navigation with focused user journeys
- **Consistent Language Support**: Bilingual support for English and Hindi
- **Improved Form Design**: User-friendly forms with clear validation feedback
- **Better Feedback System**: Ability to provide feedback on complaint resolution
- **Reduced Permission Requests**: Only essential permissions are requested

## Apple Human Interface Guidelines Compliance

This app follows Apple's Human Interface Guidelines in several key areas:

- **Touch Targets**: All interactive elements are at least 44x44pt for easy tapping
- **Text Legibility**: Text is properly sized and spaced for readability
- **Contrast**: High contrast between text and backgrounds for better visibility
- **Navigation Patterns**: Uses standard iOS navigation patterns like TabView
- **Accessibility**: Includes proper accessibility labels and hints for VoiceOver
- **Form Design**: Clear field labels, validation, and error messaging
- **Content Organization**: Logical grouping of related elements
- **Visual Hierarchy**: Clear visual hierarchy with appropriate font sizes and weights
- **Feedback**: Provides clear feedback for user actions

## Screens Implemented

1. **Home Screen**: Entry point with language selection and main navigation options
2. **Login**: OTP-based authentication using mobile number
3. **Dashboard**: Post-login interface showing complaint statistics and recent complaints
4. **Register Complaint**: Form to submit new complaints with department selection
5. **Track Complaint**: Tools to track existing complaints by ID and view status updates

## Technical Implementation

- Built with SwiftUI for iOS 14+
- Follows modern iOS design patterns
- Uses NavigationView and TabView for standard iOS navigation
- Implements form validation with appropriate user feedback
- Features proper error handling and success messaging

## Future Enhancements

- Data persistence with Core Data
- Push notifications for complaint updates
- Integration with government APIs
- Enhanced accessibility features
- Dark mode support 