//
//  AboutUsView.swift
//  Carto
//
//  Created by Nadin Ahmed on 08/07/2026.
//

import SwiftUI

struct AboutUsView: View {
    let teamMembers = [
        "Nadin Ahmed Amin",
        "Menna Allah Mohamed Ali",
        "Mohamed Ayman Hassan",
        "Osama Hosam Fawzy"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Logo
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding(.top, 20)
                
                // Title
                Text("About Us")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                
                // Summary
                Text("We are a passionate iOS development team dedicated to crafting exceptional mobile experiences. Welcome to WearDear, our latest project combining sleek design with seamless functionality.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Team Section
                VStack(spacing: 12) {
                    Text("Meet the Team")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                    
                    ForEach(teamMembers, id: \.self) { member in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color("PrimaryColor"))
                                .font(.title2)
                            
                            Text(member)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("CardBGColor"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                
                // GitHub Link
                Link(destination: URL(string: "https://github.com/OTech-Company/WearDear")!) {
                    HStack {
                        Image(systemName: "link.circle.fill")
                        Text("View Project on GitHub")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer(minLength: 40)
                
                // Copyright
                Text("© 2026 Carto. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
