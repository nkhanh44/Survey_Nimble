//
//  SurveyRequest.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Foundation

final class SurveyRequest: BaseRequest {
    
    required init(page: Int, pageSize: Int) {
        let baseURL = Constants.APIs.getAPIURL(enviroment: BuildConfiguration.shared.environment)
        let url = baseURL + "surveys?page[number]=\(page)&page[size]=\(pageSize)"
        super.init(url: url, requestType: .GET)
    }
}
