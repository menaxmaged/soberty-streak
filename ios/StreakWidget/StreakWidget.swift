//
//  StreakWidget.swift
//  StreakWidget
//
//  Created by Mena Maged on 09/05/2025.
//

import WidgetKit
import SwiftUI


let data = DataService();
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), days: data.progress())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), days: data.progress())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, days: data.progress())
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
    let days: Int
}

struct StreakWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading,spacing: 1){
            Text("End of An Era").font(.system(size: 20, weight: .bold))
            Text("started on 14 mar").font(.system(size: 15)).foregroundStyle(.secondary)
            
            
            
            
            
            StreakView(days: data.progress())
            MonthStreak(days: data.progress())
     
        }.foregroundStyle(.red)
            }
}

struct StreakView : View {
    let days:Int
    var body: some View{
        HStack{
            Text(String(days)).font(.system(size: 45, weight: .heavy).monospacedDigit())
            Text("Days").font(.system(size: 20,weight: .bold)).foregroundStyle(.secondary)
        }

        
    }
    
}

struct MonthStreak: View {
    let days: Int
    let rows: Int = 2
    let columns: Int = 6

    var body: some View {
        Grid(horizontalSpacing: 3, verticalSpacing: 3) {
            // Loop through the rows
            ForEach(0..<rows, id: \.self) { row in
                // Loop through the columns in each row
                GridRow {
                    ForEach(0..<columns, id: \.self) { col in
                        // Calculate the index for each day in the grid
                        let index = row * columns + col
                        let isFilled = index <= days/30
                        Rectangle().frame(height: 8).foregroundStyle(isFilled ? .primary : .secondary)
                    }
                }
            }
        }
    }
}



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
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    StreakWidget()
} timeline: {
    SimpleEntry(date: .now, days: 29)
    SimpleEntry(date: .now, days: 60)
}
