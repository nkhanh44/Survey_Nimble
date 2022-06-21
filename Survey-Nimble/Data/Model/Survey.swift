//
//  Survey.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import Japx

struct Survey: JapxCodable {
    
    let id: String
    let type: String
    let title: String
    let description: String
    let coverImageURL: String
}

extension Survey {
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case title = "title"
        case description = "description"
        case coverImageURL = "cover_image_url"
    }
}
