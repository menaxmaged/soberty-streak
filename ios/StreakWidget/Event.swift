//
//  DataService.swift
//  SobertyWidgetExtension
//
//  Created by Mena Maged on 08/05/2025.
//

import Foundation


struct Event: Identifiable, Codable ,Hashable{
    var id = UUID() // Unique identifier for each event
    var name: String
    var date: Date
    let days: Int
    let formattedDate: String
    let color: Int
    
    // Custom initializer to calculate days only once
    init(name: String, date: Date,color: Int) {
        self.name = name
        self.date = date
        self.days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        // Create a formatted date string
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "d MMM" // Only Day and Month (e.g., "14 Mar")
        
        self.formattedDate = formatter.string(from: date)
        self.color = color
    }
    
    // Overloaded initializer for String input
    init(name: String, dateString: String,color: Int) {
        self.name = name
        
        // Convert the date string to a Date object
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Expected date format
        self.date = formatter.date(from: dateString) ?? Date() // Default to today if invalid
        
        self.days = Calendar.current.dateComponents([.day], from: self.date, to: Date()).day ?? 0
        
        // Create a formatted date string (Day and Month Only)
        formatter.dateFormat = "d MMM" // Only Day and Month (e.g., "14 Mar")
        self.formattedDate = formatter.string(from: self.date)
        self.color = color

    }
    
    // Custom CodingKeys to map JSON keys
    enum CodingKeys: String, CodingKey {
        case name
        case dateString
        case color
    }
    
    // Custom Decoder for JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let dateString = try container.decode(String.self, forKey: .dateString)
        self.color = try container.decode(Int.self, forKey: .color)
        // Date conversion
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Expected date format
        self.date = formatter.date(from: dateString) ?? Date() // Default to today if invalid
        
        // Calculate days difference
        self.days = Calendar.current.dateComponents([.day], from: self.date, to: Date()).day ?? 0
        
        // Create a formatted date string (Day and Month Only)
        formatter.dateFormat = "d MMM" // Only Day and Month (e.g., "14 Mar")
        self.formattedDate = formatter.string(from: self.date)
        
        // Create The cikir
    }
    
    // Custom Encoder for JSON
      func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(name, forKey: .name)
          
          // Format the date as a string for JSON
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          let dateString = formatter.string(from: date)
          try container.encode(dateString, forKey: .dateString)
      }
    
    
    
    // Default Event
      static var defaultEvent: Event {
          return Event(name: "Default Event", date: Date(),color:33)
      }

    
    
    
}


