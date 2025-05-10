//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import WidgetKit
import SwiftUI


var dataService = DataService();
let currentEvent: Event = dataService.getEvent(eventname: "nn")
let eventList: [Event] = dataService.listEvents()

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent

}



struct StreakWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family // Detect the widget size
    
    var body: some View {
        
        if let selectedEvent = entry.configuration.selectedEvent {
            let event = dataService.getEvent(eventname: selectedEvent)
            
            
            VStack{
                switch family {
                case .accessoryCircular:
                    AccessoryWidgetView(event: event)
                case .accessoryRectangular:
                    AccessoryWidgetRectView(event: event)
                    
                case .systemSmall:
                    SmallWidgetView(event: event)
                case .systemMedium:
                    MediumWidgetView(eventList: eventList)
                case .systemLarge:
                    LargeWidgetView(event: event)
                default:
                    SmallWidgetView(event: event)
                }
            }.foregroundStyle(.green)
        
            
            
            
            
            
        }
        else {
                Text("No event selected")
                    .font(.headline).foregroundStyle(.white)
            }
        }}
    



struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StreakWidgetEntryView(entry: entry)
                .containerBackground(.black, for: .widget)

        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var nn: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedEvent = "nn"
        return intent
    }
    
    fileprivate static var zbi: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedEvent = "End of An Era"

        return intent
    }
    
    fileprivate static var end: ConfigurationAppIntent {
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
