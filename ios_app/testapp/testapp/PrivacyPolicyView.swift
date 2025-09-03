import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Text("Last Updated: October 15, 2023".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("privacy_policy_intro".localized)
                        .padding(.top, 8)
                    
                    PolicySection(
                        title: "Information We Collect".localized,
                        content: "privacy_info_collect".localized
                    )
                    
                    PolicySection(
                        title: "How We Use Your Information".localized,
                        content: "privacy_info_use".localized
                    )
                    
                    PolicySection(
                        title: "Information Sharing".localized,
                        content: "privacy_info_sharing".localized
                    )
                    
                    PolicySection(
                        title: "Data Security".localized,
                        content: "privacy_data_security".localized
                    )
                    
                    PolicySection(
                        title: "Your Rights".localized,
                        content: "privacy_your_rights".localized
                    )
                    
                    Text("privacy_contact_info".localized)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitle("Privacy Policy".localized, displayMode: .inline)
            .navigationBarItems(trailing: Button("Close".localized) {
                isPresented = false
            })
        }
    }
}

// Policy section component
struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView(isPresented: .constant(true))
    }
} 