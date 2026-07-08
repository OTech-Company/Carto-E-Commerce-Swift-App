import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: AuthLoginViewModel
    @State private var rememberMe = false
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                        VStack(spacing: 6) {
                            Text("Welcome to Carto")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Your premium shopping destination.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    VStack(spacing: 20) {
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
                        
                        VStack(spacing: 12) {
                            AuthTextField(
                                label: "Password",
                                placeholder: "Enter your Password",
                                text: $viewModel.password,
                                error: viewModel.passwordErrorMessage,
                                isSecure: true
                            ) {
                                viewModel.validatePassword()
                            }
                            .disabled(viewModel.isLoading)
                            
                            HStack {
                                
                                Spacer()
                                
                                Button(action: { viewModel.forgotPasswordTapped() }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "FF5A00"))
                                }
                                .disabled(viewModel.isLoading)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Button(action: { viewModel.login() }) {
                        Text("Login")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: "FF5A00"))
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    
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
                    .padding(.vertical, 20)
                    
                    HStack(spacing: 12) {
                        Button(action: { viewModel.signInWithGoogle() }) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 22, height: 22)
                                    Image(systemName: "g.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.blue, .red, .yellow, .green],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                Text("Sign in with Google")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.75))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 24)

                    .padding(.bottom, 20)
                    
                    Button(action: { viewModel.continueAsGuest() }) {
                        Text("Continue as Guest")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                    }
                    .disabled(viewModel.isLoading)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Button(action: { viewModel.signUpTapped()}) {
                            Text("Sign up")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "FF5A00"))
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.bottom, 24)
                }
                .background(Color(hex: "FAFAFA"))
                
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
}
