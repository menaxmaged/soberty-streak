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
    
    // Custom initializer to calculate days only once
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        // Create a formatted date string
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "d MMM" // Only Day and Month (e.g., "14 Mar")

        self.formattedDate = formatter.string(from: date)
    }
    
    // Overloaded initializer for String input
    init(name: String, dateString: String) {
        self.name = name
        
        // Convert the date string to a Date object
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Expected date format
        self.date = formatter.date(from: dateString) ?? Date() // Default to today if invalid
        
        self.days = Calendar.current.dateComponents([.day], from: self.date, to: Date()).day ?? 0
        
        // Create a formatted date string (Day and Month Only)
        formatter.dateFormat = "d MMM" // Only Day and Month (e.g., "14 Mar")
        self.formattedDate = formatter.string(from: self.date)
    }
}




