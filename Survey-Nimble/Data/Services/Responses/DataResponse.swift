//
//  DataResponse.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

struct JapxResponse<T: Codable>: Codable {
    let data: T
}

struct JapxResponseArray<T: Codable>: Codable {
    var data: [T]?
    var meta: Meta
}
