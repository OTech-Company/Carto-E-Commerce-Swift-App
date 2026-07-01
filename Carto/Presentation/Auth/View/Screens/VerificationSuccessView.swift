//
//  VerificationSuccessView.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation
import SwiftUI

struct VerificationSuccessView: View {
    @StateObject var viewModel: VerificationSuccessViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "FAFAFA")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(hex: "FF5A00").opacity(0.08))
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(hex: "FF5A00"))
                }
                
                VStack(spacing: 12) {
                    Text("Verification Successful")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Your account details are confirmed. Welcome to your premier shopping platform.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                }
                
                Spacer()
                
                Button(action: {
                    Task { await viewModel.onGetStartedClicked() }
                }) {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(hex: "FF5A00"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
