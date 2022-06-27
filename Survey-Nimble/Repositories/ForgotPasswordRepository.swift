//
//  ForgorPasswordRepository.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation
import RxSwift
import Japx

protocol ForgotPasswordRepositoryType {
    
    func reset(input: ForgotPasswordRequest) -> Observable<Message>
}

final class ForgotPasswordRepository: ForgotPasswordRepositoryType {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }

    func reset(input: ForgotPasswordRequest) -> Observable<Message> {
        return api.request(input, decoder: .jSONDecoder).map { $0 }
    }
}
