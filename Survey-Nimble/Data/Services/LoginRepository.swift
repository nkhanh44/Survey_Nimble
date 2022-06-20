//
//  LoginRepository.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation
import RxSwift

protocol LoginRepositoryType {
    
    func login(input: LoginRequest) -> Observable<User>
}

final class LoginRepository: LoginRepositoryType {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }

    func login(input: LoginRequest) -> Observable<User> {
        return api.request(input).map { $0 }
    }
}
