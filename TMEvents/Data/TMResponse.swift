//
//  TMResponse.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import Foundation

struct TMResponse<T: Codable>: Codable {
    let embedded: T
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct EventsResponse: Codable {
    let events: [Event]
}

struct Event: Codable {
    let name: String
    let type: String
    let id: String
    let images: [EventImage]
}

struct EventImage: Codable {
    let ratio: Ratio
    let url: String
    let width, height: Int
    let fallback: Bool
}

enum Ratio: String, Codable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

struct Page: Codable {
    let size, totalElements, totalPages, number: Int
}
