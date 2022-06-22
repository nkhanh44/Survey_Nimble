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
    
    func reset(input: ForgotPasswordRequest) -> Observable<NoReply>
}

final class ForgotPasswordRepository: ForgotPasswordRepositoryType {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }

    func reset(input: ForgotPasswordRequest) -> Observable<NoReply> {
        return api.request(input).map { $0 }
    }
}
