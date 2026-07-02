import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: AuthRegisterViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var rememberMe = false
    
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
                        Text("Registration")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Enter the fields below to get started")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
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
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            .disabled(viewModel.isLoading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    
                    Button(action: { viewModel.register() }) {
                        Text("Create Account")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: "FF5A00"))
                            .cornerRadius(12)
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
                        Text("Or continue with")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    HStack(spacing: 24) {
                        SocialIconButton(iconName: "g.circle.fill", isSystem: true) { viewModel.signInWithGoogle() }
                            .disabled(viewModel.isLoading)
                        SocialIconButton(iconName: "applelogo", isSystem: true) {}
                            .disabled(viewModel.isLoading)
                        SocialIconButton(iconName: "f.circle.fill", isSystem: true) {}
                            .disabled(viewModel.isLoading)
                    }
                    .padding(.bottom, 16)
                    
                    Button(action: { viewModel.continueAsGuest()}) {
                        Text("Continue as Guest")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.bottom, 16)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button(action: { viewModel.signInTapped()}) {
                        Text("Sign in")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "FF5A00"))
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.bottom, 24)
            }
            .background(Color(hex: "FAFAFA"))
            .navigationBarBackButtonHidden(true)
            
            if viewModel.isLoading {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FF5A00")))
                    .scaleEffect(1.5)
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
            }
        }
    }
}
