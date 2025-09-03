import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App logo
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .padding(.top, 32)
                    
                    // App title
                    Text("JanSunwai".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Public Grievance Redressal System".localized)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // App description
                    Text("app_about_description".localized)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    
                    // Features list
                    VStack(alignment: .leading, spacing: 12) {
                        AboutFeatureRow(
                            icon: "doc.text.fill", 
                            title: "Register Complaints".localized, 
                            description: "Easy submission of grievances to appropriate departments".localized
                        )
                        AboutFeatureRow(
                            icon: "magnifyingglass", 
                            title: "Track Status".localized, 
                            description: "Real-time updates on your complaints".localized
                        )
                        AboutFeatureRow(
                            icon: "person.fill", 
                            title: "User Profile".localized, 
                            description: "Manage your account and complaint history".localized
                        )
                        AboutFeatureRow(
                            icon: "bell.fill", 
                            title: "Notifications".localized, 
                            description: "Stay updated on complaint progress".localized
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    
                    // Credits
                    Text("developed_by".localized)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.top, 16)
                    
                    Spacer()
                }
                .padding(.bottom, 32)
            }
            .navigationBarTitle("About".localized, displayMode: .inline)
            .navigationBarItems(trailing: Button("Close".localized) {
                isPresented = false
            }
            .foregroundColor(.white)
            .bold()
            )
        }
    }
}

// About feature row component
struct AboutFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(isPresented: .constant(true))
    }
} 