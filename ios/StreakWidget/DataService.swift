//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//
import Foundation
import SwiftUI
import Combine

class DataService: ObservableObject {
    // Use @Published to observe changes to the stored event data
    @AppStorage("events_data", store: UserDefaults(suiteName: "group.net.codexeg.sobertystreaker"))
    
    private var eventsData: String = """
        [{"name":"End of an Era","dateString":"2025-03-14"}]
        """ {
            didSet {
                // Manually update the events array whenever eventsData changes
                self.events = decodeEvents(from: eventsData)
            }
        }
    
    @Published private(set) var events: [Event] = []
    
    @AppStorage("streak", store: UserDefaults(suiteName: "group.net.codexeg.sobertystreaker"))
    private var streak: Int = 0
    
    
    // Singleton instance
    static let shared = DataService()
    
    private init() {
        //        self.events = decodeEvents(from: eventsData)
        print("Decoded events: \(events)")
    }
    
    // Decode events from JSON
    private func decodeEvents(from jsonString: String) -> [Event] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Invalid JSON data.")
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Event].self, from: jsonData)
        } catch {
            print("Error decoding events from JSON: \(error.localizedDescription)")
            return []
        }
    }
    
    // Save events to AppStorage
    private func saveEvents() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(events)
            eventsData = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Error encoding events: \(error.localizedDescription)")
        }
    }
    
    // Add a new event
    func addEvent(name: String, dateString: String) {
        let newEvent = Event(name: name, dateString: dateString)
        events.append(newEvent)
        saveEvents()
    }
    
    // Remove an event by name
    func removeEvent(named eventName: String) {
        events.removeAll { $0.name == eventName }
        saveEvents()
    }
    
    // Get a specific event by name
    func getEvent(named eventName: String) -> Event? {
        return loadEvents().first { $0.name == eventName }
    }
    
    // Get event names for display
    func getEventNames() -> [String] {
        return loadEvents().map { $0.name }
    }
    
    func getStreak() -> String {
        return String(describing: streak)
    }
    
    let hcEvents: [Event] = [Event.defaultEvent,Event(name: "MENA", dateString: "2002-08-07"),Event(name: "NANA", dateString: "2003-12-13")]
    
    func gethardcodedEvents() -> [Event]{return  loadEvents() + hcEvents}
    
    
    
    func loadEvents() -> [Event]{
       
        
        return decodeEvents(from: eventsData)

    }
}
