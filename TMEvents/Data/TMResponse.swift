//
//  TMResponse.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import Foundation

struct TMResponse<T: Codable>: Codable {
    let embedded: T?
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct EventsResponse: Codable {
    let events: [Event]
}
