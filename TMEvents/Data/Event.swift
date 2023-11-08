//
//  Event.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

struct Event: Codable, Equatable {
    
    let id: String
    let name: String
    let dates: Dates
    let eventData: EventEmbedded?
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, images
        case eventData = "_embedded"
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Dates: Codable {
    let start: StartDate
}

struct StartDate: Codable {
    let dateTime: Date?
}

struct EventImage: Codable {
    let ratio: Ratio?
    let url: String
    let width, height: Int
    let fallback: Bool
}

enum Ratio: String, Codable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
    case the1_1 = "1_1"
}

struct Page: Codable {
    let size, totalElements, totalPages, number: Int
}

struct EventEmbedded: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String?
    let city: City
    let state: State?
}

struct City: Codable {
    let name: String
}

struct State: Codable {
    let name, stateCode: String?
}
