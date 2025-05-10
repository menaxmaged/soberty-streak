//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import WidgetKit
import SwiftUI


// Initialize the data service
let dataService = DataServiceNew()


// Provider
struct Provider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        
        var event:Event = Event.defaultEvent
        
        // Safely unwrap the tuple returned by loadData()
        if configuration.selectedEvent != nil{
             event = dataService.getEvent(eventName: configuration.selectedEvent! )
        }
        
        
        // Define the timeline for the widget with the unwrapped data
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date(), configuration: configuration, eventData: dataService.loadEventData(), event: event )
        ]


        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


// Simple Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent 
    var userInfo: String = "" // This will hold the data you want to display in the widget
    var eventData: String = ""
    var event: Event = Event(name: "EVENT", dateString: "2025-05-6")
    var eventList: [Event] = []
}

// Widget View
struct StreakWidgetEntryView: View {
    var entry: Provider.Entry
    
    
    
    
    var currentEvent: Event 
    @Environment(\.widgetFamily) var family // Detect the widget size
    
    
    var body: some View {
        if entry.configuration.selectedEvent != nil {
            // Use the selected event
            VStack {
                switch family {
                case .accessoryCircular:
                    AccessoryWidgetView(event: currentEvent)

                case .accessoryRectangular:
                    AccessoryWidgetRectView(event: currentEvent)

                case .systemSmall:
                    SmallWidgetView(event: currentEvent)
                case .systemMedium:
                 //   MediumWidgetView(eventList: eventList)
                    Text("SSS").foregroundStyle(.cyan)
                case .systemLarge:
                    LargeWidgetView(event: currentEvent)
                default:
                    SmallWidgetView(event: currentEvent)
                }
            }.foregroundStyle(.green)
        } else {
            Text("No event selected")
                .font(.headline).foregroundStyle(.white)
        }
    }
}






// Widget Init
struct StreakWidget: Widget {
    let kind: String = "StreakWidget"
    var body: some WidgetConfiguration {
        
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StreakWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)

        }
    }
}





// For Preview
extension ConfigurationAppIntent {
    fileprivate static var nn: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedEvent = "nn"
        return intent
    }
    
    fileprivate static var end: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedEvent = "End of an Era"

        return intent
    }
    
    fileprivate static var zbi: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedEvent = "AAAA"
        return intent
    }
    
    fileprivate static var none: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
       
        return intent
    }
}

#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    
    
    SimpleEntry(date: .now,configuration: .nn)
    SimpleEntry(date: .now,configuration: .end)
    
    SimpleEntry(date: .now,configuration: .zbi)
    SimpleEntry(date: .now,configuration: .none)
    

}
