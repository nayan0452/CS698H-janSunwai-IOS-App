//
//  SharedComponents.swift
//  testapp
//
//  Created by Nayan . on 24/04/25.
//

import SwiftUI

/// Shared components used throughout the app

// Helper view for displaying escalation information rows
struct EscalationInfoRow: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    
    init(icon: String, title: String, description: String, iconColor: Color = .blue) {
        self.icon = icon
        self.title = title
        self.description = description
        self.iconColor = iconColor
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// Add any other shared components here as needed 