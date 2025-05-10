//
//  AppIntent.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import WidgetKit
import AppIntents







struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
        // Dropdown Menu Parameter (Optional)
    @Parameter(title: "Select Event",
                   optionsProvider: EventsOptionsProvider())
        var selectedEvent: String?
    
    
    
   
    
    private struct EventsOptionsProvider: DynamicOptionsProvider{
        func results() async throws -> [String] {
            dataService.getEvents()
            
        }
        
        
        
    }
    
    
}
