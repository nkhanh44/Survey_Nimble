//
//  BaseRequest.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 19/06/2022.
//

import Foundation

class BaseRequest: NSObject {
    
    var url = ""
    var requestType = RequestType.GET
    var body: [String: Any]?
    
    init(url: String) {
        super.init()
        self.url = url
    }
    
    init(url: String, requestType: RequestType) {
        super.init()
        self.url = url
        self.requestType = requestType
    }
    
    init(url: String, requestType: RequestType, body: [String: Any]?) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.body = body
    }
}
