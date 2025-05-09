import SwiftUI
import WidgetKit

// Accessory Widget Size  "Apple Watch and Lock Screen"

struct AccessoryWidgetView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .center) {
            // Streak View
            HStack {
                Text("\(event.days)")
                    .font(.system(size: 35, weight: .heavy).monospacedDigit()).truncationMode(
                        .tail
                    )  // Add "..." for overflow
                    .minimumScaleFactor(0.5)  // Scale down if needed

            }
            .foregroundStyle(.green)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }

    }
}

// Rectangle Lockscreen
struct AccessoryWidgetRectView: View {
    var event: Event

    var body: some View {
        WidgetComponents.DaysCounter(days: event.days)

    }
}

// Original Widget Size
struct SmallWidgetView: View {
    var event: Event

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            WidgetComponents.NameView(name: event.name)
            WidgetComponents.DaysCounter(days: event.days)
            WidgetComponents.StartDate(date: event.formattedDate)
            WidgetComponents.MonthStreak(days: event.days)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

    }
}

struct MediumWidgetView: View {
    var eventList: [Event]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geometry in
                    LazyVGrid(columns: columns, spacing: geometry.size.height * 0.05) {
                        ForEach(eventList) { event in
                            VStack(alignment: .leading){
                                WidgetComponents.NameView(name: event.name)
                                WidgetComponents.DaysCounter(days: event.days)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
                }
    }
}
struct LargeWidgetView: View {
    var event: Event

    var body: some View {
    }

}
