import SwiftUI
import MessageUI

struct SettingsSheet: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var showMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    var onBuyPremium : () -> Void
    // Dummy Links
    let rateAppLink = "https://apps.apple.com/app/id123456789"
    let termsLink = "https://www.google.com" // Placeholder
    let privacyLink = "https://www.google.com" // Placeholder
    let contactEmail = "alishahzaib02@gmail.com"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack {
                    List {
                        // Premium Section
                        if !viewModel.isPremiumUser {
                            Section {
                                Button(action: {
                                    onBuyPremium()
                                }) {
                                    HStack {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.yellow)
                                        Text("Upgrade to Premium")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        // General Section
                        Section(header: Text("General")) {
                            // Rate App
                            Button(action: {
                                if let url = URL(string: rateAppLink) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                SettingsRow(icon: "star.fill", color: .orange, text: "Rate App")
                            }
                            
                            // Terms of Use
                            Button(action: {
                                showTerms = true
                            }) {
                                SettingsRow(icon: "doc.text.fill", color: .blue, text: "Terms of Use")
                            }
                            .sheet(isPresented: $showTerms) {
                                WebViewSheet(title: "Terms of Use", urlString: termsLink)
                            }
                            
                            // Privacy Policy
                            Button(action: {
                                showPrivacy = true
                            }) {
                                SettingsRow(icon: "hand.raised.fill", color: .green, text: "Privacy Policy")
                            }
                            .sheet(isPresented: $showPrivacy) {
                                WebViewSheet(title: "Privacy Policy", urlString: privacyLink)
                            }
                            
                            // Contact Us
                            Button(action: {
                                if MFMailComposeViewController.canSendMail() {
                                    showMailView = true
                                } else {
                                    // Handle device not configured for email
                                    if let url = URL(string: "mailto:\(contactEmail)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }) {
                                SettingsRow(icon: "envelope.fill", color: .purple, text: "Contact Us")
                            }
                            .sheet(isPresented: $showMailView) {
                                MailView(result: $mailResult, recipients: [contactEmail])
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Footer
                    Text("Developed by Shahzaib Ali")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .cornerRadius(6)
            
            Text(text)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct WebViewSheet: View {
    let title: String
    let urlString: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebView(urlString: urlString)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

// Mail View Helper
struct MailView: UIViewControllerRepresentable {
    @Binding var result: Result<MFMailComposeResult, Error>?
    var recipients: [String]
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(result: Binding<Result<MFMailComposeResult, Error>?>) {
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                controller.dismiss(animated: true)
            }
            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success(result)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
