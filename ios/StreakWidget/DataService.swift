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
        [{"name":"End of an Era","dateString":"2025-03-14","color":"22"}]
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
    
    // Decode events from JSON
    private func decodeEventsDebug(from jsonString: String) -> String {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return("Invalid JSON data.")
        }
        do {
            let decoder = JSONDecoder()
            return try String(describing:decoder.decode([Event].self, from: jsonData))
        } catch {
            return("Error decoding events from JSON: \(error.localizedDescription)")
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
    func addEvent(name: String, dateString: String,color: Int) {
        let newEvent = Event(name: name, dateString: dateString,color:color)
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
    
    
    
    
    func loadEvents() -> [Event]{
        
        
        return decodeEvents(from: eventsData)
        
    }
    
    
    func debug() -> String{
      //  return (eventsData)
    return  decodeEventsDebug(from: eventsData)
        
    }
}



// Function to map ARGB values to SwiftUI system colors
func argbToSwiftUIColor(argb: Int) -> Color {
    switch argb {
    case 0xFFFF4500: // System Orange
        return Color.orange
    case 0xFF007AFF: // System Blue
        return Color.blue
    case 0xFF4CD964: // System Green
        return Color.green
    case 0xFFFFD600: // System Yellow
        return Color.yellow
    case 0xFF5856D6: // System Purple
        return Color.purple
    case 0xFFFF2D55: // System Red
        return Color.red
    case 0xFF34AADC: // System Teal
        return Color.teal
    case 0xFF0CDCFE: // System Cyan
        return Color.cyan
    case 0xFF8E8E93: // System Fill (gray)
        return Color.gray.opacity(0.2)
    case 0xFFC7C7CC: // System Grey2 (light gray)
        return Color.gray.opacity(0.6)
    case 0xFFD1D1D6: // System Grey4 (another light gray)
        return Color.gray.opacity(0.4)
    case 0xFFFF9F0A: // System Pink
        return Color.pink
    default:
        return Color.clear // Default to clear if no match
    }
}



func argbToBuiltInColor(argb: Int) -> Color {
    // Extract ARGB components (though we're not using them in this case)
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0

    // Map ARGB32 values to the corresponding system colors
    switch argb {
    case 4294939904: // Example 1
        return Color.red
    case 4278221567: // Example 2
        return Color.green
    case 4281648985: // Example 3
        return Color.blue
    case 4294953984: // Example 4
        return Color.yellow
    case 4289680094: // Example 5
        return Color.purple
    case 4294916912: // Example 6
        return Color.pink
    case 4284139770: // Example 7
        return Color.teal
    case 4281511398: // Example 8
        return Color.gray
    case 4281648985: // Example 9
        return Color.blue
    case 863533184:  // Example 10
        return Color.orange
    case 4289638066: // Example 11
        return Color.indigo
    case 4291940822: // Example 12
        return Color.gray
    case 4294913365: // Example 13
        return Color.green
    default:
        // Return a default color if no match is found
        return Color.green
    }
}
