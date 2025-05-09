//
//  AppIntent.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import WidgetKit
import AppIntents

// Define an Enum for Menu Options (Dropdown)
enum EventMenuOption: String, AppEnum {
    case sobriety = "Sobriety Journey"
    case workout = "Workout Streak"
    case reading = "Reading Habit"
    case meditation = "Meditation Practice"
    case coding = "Coding Challenge"
    case nn = "nn"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Select Event")

    static var caseDisplayRepresentations: [EventMenuOption: DisplayRepresentation] {
        [
            .sobriety: DisplayRepresentation(title: "End of an Era"),
            .workout: DisplayRepresentation(title: "Workout Streak"),
            .reading: DisplayRepresentation(title: "Reading Habit"),
            .meditation: DisplayRepresentation(title: "Meditation Practice"),
            .coding: DisplayRepresentation(title: "Coding Challenge"),
            .nn: DisplayRepresentation(title: "nn")
        ]
    }
}






struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
        // Dropdown Menu Parameter (Optional)
    @Parameter(title: "Select Event")
    var selectedEvent: EventMenuOption? // Now optional

    
    
}
