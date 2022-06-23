//
//  SurveyRepository.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Foundation
import RxSwift

protocol SurveyRepositoryType {
    
    func getSurveyList(input: SurveyRequest) -> Observable<([Survey], Meta)>
    func refreshToken(input: RefreshTokenRequest) -> Observable<User>
}

final class SurveyRepository: SurveyRepositoryType {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }

    func getSurveyList(input: SurveyRequest) -> Observable<([Survey], Meta)> {
        return api.requestList(input).map { $0 }
    }
    
    func refreshToken(input: RefreshTokenRequest) -> Observable<User> {
        return api.request(input)
    }
}
