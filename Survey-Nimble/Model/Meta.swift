//
//  Meta.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 21/06/2022.
//

import Foundation

struct Meta: Codable {
    
    let page: Int
    let pages: Int
    let pageSize: Int
    let records: Int
}

extension Meta {
    
    enum CodingKeys: String, CodingKey {
        case page, pages, records
        case pageSize = "page_size"
    }
}
