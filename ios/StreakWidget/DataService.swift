//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//
import Foundation
import SwiftUI

// Singleton DataService class
class DataService  {
    @AppStorage("events_data", store: UserDefaults(suiteName: "group.net.codexeg.sobertyStreak")) private var eventsData: String = """
    [{"name":"End of an Era","dateString":"2025-03-14"},
    {"name":"No Contact","dateString":"2023-03-16"},
    {"name":"Sobriety Journey","dateString":"2023-05-14"},
    {"name":"nn","dateString":"2025-03-01"}]
    """

    
    
    @Published private(set) var events: [Event] = []
    
    // Singleton instance
    static let shared = DataService()

    private init() {
        self.events = decodeEvents(from: eventsData)
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
    
    // List all events
    func listEvents() -> [Event] {
        return events
    }
    
    // Get event names for display
    func getEventNames() -> [String] {
        return events.map { $0.name }
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
    func getter() -> String{
    //    print(getEventNames())
        return "MENA"
    }
}





class DataServiceNew {
    
   private let jsonString = """
    [
        {"name": "End of an Era", "dateString": "2025-03-14"},
        {"name": "No Contact", "dateString": "2023-03-16"}
    ]
    """
    
    // Create a computed property for UserDefaults with app group
    let userDefaults: UserDefaults? = UserDefaults(suiteName: "group.net.codexeg.sobertyStreak")
    
    // Method to save data
    func saveData(name: String, age: Int) {
        // Check if userDefaults is initialized before using it
        guard let userDefaults = userDefaults else { return }
        
        // Save data to UserDefaults
        userDefaults.set(name, forKey: "username")
        userDefaults.set(age, forKey: "age")
        
        // Optionally print confirmation
        print("Data saved: username = John Doe, age = 25")
        
        
    }
    
   
    // Method to read data
    func loadData() -> (username: String?, age: Int) {
        guard let userDefaults = userDefaults else { return ("", 0) }
        let username = userDefaults.string(forKey: "username")
        let age = userDefaults.integer(forKey: "age")
        return (username, age)
    }
    
    func loadEventData() -> (String){
     
        guard let userDefaults = userDefaults else { return "" }
        guard let eventData = userDefaults.string(forKey: "event_data") else {return "No Events yet"}
        return eventData

    }
    
    
    
    // Decode events from JSON
     func decodeEvents(from jsonString: String) -> [Event] {
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

    
    func getEvents() -> [Event]{
        return decodeEvents(from: jsonString)

    }
    
    // Get event names for display
    func getEventNames() -> [String] {
        return getEvents().map { $0.name }
    }
    
    
    
    func getEvent(eventName: String) -> Event {
        // Use the first matching event or return a default event if not found
        return getEvents().first { $0.name == eventName } ?? Event.defaultEvent
    }
    
    }


