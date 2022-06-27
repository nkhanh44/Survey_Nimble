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
    
    func transformToURLRequest() -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        var headerParams: [String: String]? = [
            "Content-Type": "application/json"
        ]
        
        if let accessToken = KeychainAccess.userInfo?.accessToken,
           !accessToken.isEmpty,
           requestType == .GET {
            print("accessToken: ", accessToken)
            headerParams = ["Authorization": "Bearer \(accessToken)"]
        }
        
        if requestType == .POST {
            let payloadData = try? JSONSerialization.data(withJSONObject: body ?? [:], options: [])
            
            request.httpBody = payloadData
        }
        
        request.httpMethod = requestType.rawValue
        request.allHTTPHeaderFields = headerParams
        
        return request
    }
}

