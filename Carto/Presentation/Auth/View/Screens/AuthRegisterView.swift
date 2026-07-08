import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: AuthRegisterViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var rememberMe = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    
                    VStack(spacing: 6) {
                        Text("registration_title")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("register_desc")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        AuthTextField(
                            label: "First Name",
                            placeholder: "Enter your First Name",
                            text: $viewModel.firstName,
                            error: viewModel.firstNameErrorMessage
                        ) {
                            viewModel.validateFirstName()
                        }
                        .disabled(viewModel.isLoading)
                        
                        AuthTextField(
                            label: "Last Name",
                            placeholder: "Enter your Last Name",
                            text: $viewModel.lastName,
                            error: viewModel.lastNameErrorMessage
                        ) {
                            viewModel.validateLastName()
                        }
                        .disabled(viewModel.isLoading)
                        
                        AuthTextField(
                            label: "Email",
                            placeholder: "Enter your Email",
                            text: $viewModel.email,
                            error: viewModel.emailErrorMessage
                        ) {
                            viewModel.validateEmail()
                        }
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disabled(viewModel.isLoading)
                        
                        AuthTextField(
                            label: "Password",
                            placeholder: "Create Password",
                            text: $viewModel.password,
                            error: viewModel.passwordErrorMessage,
                            isSecure: true
                        ) {
                            viewModel.validatePassword()
                        }
                        .disabled(viewModel.isLoading)
                        
                        HStack {
                            Toggle(isOn: $rememberMe) {
                                Text("remember_me_checkbox")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            .disabled(viewModel.isLoading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    
                    Button(action: { viewModel.register() }) {
                        Text("create_account_btn")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.systemBackground))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color("PrimaryColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    if let generalErrorMessage = viewModel.generalErrorMessage {
                        Text(generalErrorMessage)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }
                    
                    HStack(spacing: 16) {
                        Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5))
                        Text("or_continue_with")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    HStack(spacing: 12) {
                        Button(action: { viewModel.signInWithGoogle() }) {
                            HStack(spacing: 10) {
                                Image("google_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                Text("Sign in with Google")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary.opacity(0.75))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.15 : 0.05), radius: 4, x: 0, y: 2)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    Button(action: { viewModel.continueAsGuest()}) {
                        Text("continue_as_guest_btn")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.bottom, 16)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("already_have_account")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Button(action: { viewModel.signInTapped()}) {
                        Text("sign_in_link")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemBackground))
            .navigationBarBackButtonHidden(true)
            
            if viewModel.isLoading {
                Color.black.opacity(colorScheme == .dark ? 0.4 : 0.15)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                    .scaleEffect(1.5)
                    .frame(width: 80, height: 80)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 10)
            }
        }
    }
}
