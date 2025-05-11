//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//
import Foundation
import SwiftUI

// Singleton DataService class
class DataService {
    @AppStorage("events_data", store: UserDefaults(suiteName: "group.net.codexeg.sobertyStreak"))
    private var eventsData: String =  """
        [{"name":"End of an Era","dateString":"2025-03-14"},]
        """

    @Published private(set) var events: [Event] = []

    // Singleton instance
    static let shared = DataService()

    private init() {
        
        self.events = decodeEvents(from: eventsData)
        print("Decoded events: \(events)")  // Prints the events to verify
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
            print("Error decoding events: \(error)")
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
            print("Error encoding events: \(error)")
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
        return events.first { $0.name == eventName }
    }
    // List all events
    func listEvents() -> [Event] {
        return events
    }

    // Get event names for display
    func getEventNames() -> [String] {
        return events.map { $0.name }
    }

    
}
