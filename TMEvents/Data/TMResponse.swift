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
    let id: String
    let name: String
    let dates: Dates
    let eventData: EventEmbedded
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id, name, dates, images
        case eventData = "_embedded"
    }
}

struct Dates: Codable {
    let start: StartDate
}

struct StartDate: Codable {
    let localDate, localTime: String
    let dateTime: Date
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

struct EventEmbedded: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String
    let city: City
    let state: State
    let country: Country
}

struct City: Codable {
    let name: String
}

struct State: Codable {
    let name, stateCode: String
}

struct Country: Codable {
    let name: String
    let countryCode: String
}
