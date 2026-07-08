//
//  ProfileViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 07/07/2026.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    private var authRepo: AuthenticationRepositoryProtocol
    
    init(authRepo: AuthenticationRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    
    func signOut() async {
        await authRepo.signOut()
    }
    
    func login() async {
        await authRepo.signOut()
    }
}
