//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//

import Foundation
import SwiftUI

import Foundation



struct DataService {
    // Storing events as encoded JSON data in AppStorage
    @AppStorage("streak", store: UserDefaults(suiteName: "group.net.codexeg.sobertyStreak")) private var eventsData: Data = Data()
//    
//    private var events: [Event] {
//        get {
//            // Decode events from AppStorage
//            guard let decoded = try? JSONDecoder().decode([Event].self, from: eventsData) else {
//                return []
//            }
//            return decoded
//        }
//        set {
//            // Encode and save events to AppStorage
//            if let encoded = try? JSONEncoder().encode(newValue) {
//                eventsData = encoded
//            }
//        }
//    }
    
    
    
    
    // Hardcoded events array
        private var events: [Event] = [
            Event(name: "End of an Era", date: Date(timeIntervalSince1970: 1678752000)),
            Event(name: "No Contact", date: Date(timeIntervalSince1970: 1678934400)),
            Event(name: "Sobriety Journey", date: Date(timeIntervalSince1970: 1681315200)),
            Event(name: "nn", dateString: "2025-03-01")

        ]
    
    
    // Function to log progress (increment days) for a specific event
//    mutating func log(eventName: String) {
//        if let index = events.firstIndex(where: { $0.name == eventName }) {
//            events[index].days += 1
//             self.events = events // Save changes
//        }
//    }

    
    // Function to add a new event
    mutating func addEvent(name: String, date: Date, days: Int = 0) {
        var updatedEvents = events
        updatedEvents.append(Event(name: name, date: date))
        self.events = updatedEvents
    }
    
    // Function to remove an event
    mutating func removeEvent(eventName: String) {
        var updatedEvents = events.filter { $0.name != eventName }
        self.events = updatedEvents
    }
    
    // Function to list all events
    func listEvents() -> [Event] {
        return events
    }
    
    
    func getEvent(eventname: String) -> Event{
        let currendDate: Date = Date()
        return events.first(where: { $0.name == eventname }) ?? Event(name: "-", date: currendDate);


        
    }
}



