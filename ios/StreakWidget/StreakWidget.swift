//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import SwiftUI
import WidgetKit

// Initialize the data service
let dataService = DataService.shared

// Provider
struct Provider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async
        -> SimpleEntry
    {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<
        SimpleEntry
    > {

        var event: Event = Event.defaultEvent

        // Safely unwrap the tuple returned by loadData()
        if let selectedEvent = configuration.selectedEvent {
            event = dataService.getEvent(named: selectedEvent)!
        }

        // Define the timeline for the widget with the unwrapped data
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date(), configuration: configuration, event: event)
        ]

        return Timeline(entries: entries, policy: .atEnd)
    }
}

// Simple Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    var configuration: ConfigurationAppIntent = ConfigurationAppIntent()
    var event: Event = Event.defaultEvent
    var eventList: [Event] = []
}

// Widget View
struct StreakWidgetEntryView: View {
    var entry: Provider.Entry

    var currentEvent: Event {
        entry.event
    }

    @Environment(\.widgetFamily) var family  // Detect the widget size

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
                //                case .systemMedium:
                //                    Text("SSS").foregroundStyle(.cyan) // Placeholder for system medium
                //                case .systemLarge:
                //                    LargeWidgetView(event: currentEvent)
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
        AppIntentConfiguration(
            kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()
        ) { entry in
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
    SimpleEntry(date: .now, event: .defaultEvent)
}
