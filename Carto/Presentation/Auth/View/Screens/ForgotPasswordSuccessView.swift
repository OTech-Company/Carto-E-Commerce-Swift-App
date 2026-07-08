import SwiftUI

struct ForgotPasswordSuccessView: View {
    private var authRouter: AuthRouter
    
    init(authRouter: AuthRouter) {
        self.authRouter = authRouter
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "envelope.badge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color("PrimaryColor"))

                VStack(spacing: 12) {
                    Text("check_your_email_title")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.primary)

                    Text("password_reset_sent_desc")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                }

                Button(action: { authRouter.popToRoot() }) {
                    Text("back_to_signin_btn")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color("PrimaryColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
