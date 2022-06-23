//
//  NoReply.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 22/06/2022.
//

import Foundation

struct Message: Codable {
    let message: String
}

struct NoReply: Codable {
    let meta: Message
}
