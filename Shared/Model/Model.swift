//
//  File.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/14/21.
//

import Foundation
import LoremIpsum


struct Festival: Identifiable, Hashable {
    let id: String
    let imageName: String
    let date: Date
    let title: String
    let details: [Detail]
}

struct Detail: Identifiable, Hashable {
    let id: String
    let title: String
    let fromDate: Date
    let toDate: Date
    let fromTime: Date
    let toTime: Date
    let description: String
    let lat: Double
    let long: Double
    let price: Double
    let people: [People]
}

struct People: Identifiable, Hashable {
    let id: String
    let imageName: String
}

struct MockData {
    static let festivals = [
        
        Festival(id: UUID().uuidString, imageName: "festival", date: Date(), title: "Tomorrowland",
                 details: [.init(id: UUID().uuidString, title: "Tomorrowland", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival2", date: Date(), title: "Dekmantel",
                 details: [.init(id: UUID().uuidString, title: "Dekmantel", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival3", date: Date(), title: "Primavera Sound",
                 details: [.init(id: UUID().uuidString, title: "Primavera Sound", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival4", date: Date(), title: "Let It Roll",
                 details: [.init(id: UUID().uuidString, title: "Let It Roll", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival5", date: Date(), title: "Coachella Music & Arts Festival",
                 details: [.init(id: UUID().uuidString, title: "Coachella Music & Arts Festival", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival6", date: Date(), title: "Meadows in the Mountains",
                 details: [.init(id: UUID().uuidString, title: "Meadows in the Mountains", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival7", date: Date(), title: "Montreux Jazz Festival",
                 details: [.init(id: UUID().uuidString, title: "Montreux Jazz Festival", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival8", date: Date(), title: "Hellfest Open Air Festival",
                 details: [.init(id: UUID().uuidString, title: "Hellfest Open Air Festival", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival9", date: Date(), title: "AFROPUNK",
                 details: [.init(id: UUID().uuidString, title: "AFROPUNK", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
        
        Festival(id: UUID().uuidString, imageName: "festival10", date: Date(), title: "SXSW: South by Southwest",
                 details: [.init(id: UUID().uuidString, title: "SXSW: South by Southwest", fromDate: Date(), toDate: Date(), fromTime: Date(),
                                 toTime: Date(), description: LoremIpsum.sentence, lat: 24.7136, long: 46.6753, price: 234.32,
                                 people: people)]),
    ]
}

let  people = [ People(id: UUID().uuidString, imageName: "person"),
                People(id: UUID().uuidString, imageName: "person1"),
                People(id: UUID().uuidString, imageName: "person3"),
                People(id: UUID().uuidString, imageName: "person4"),
                People(id: UUID().uuidString, imageName: "person5"),
                People(id: UUID().uuidString, imageName: "person6"),
                People(id: UUID().uuidString, imageName: "person7"),
                People(id: UUID().uuidString, imageName: "person8"),
                People(id: UUID().uuidString, imageName: "person9"),
]
