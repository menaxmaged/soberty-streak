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
            WidgetComponents.NameView(name: event.name)                .minimumScaleFactor(0.5)

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
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(Array(eventList.enumerated()), id: \.element.id) { index, event in
                                       VStack(alignment: .leading, spacing: 5) {
                                           WidgetComponents.NameView(name: event.name)
                                               .font(.system(size: 16))
                                               .lineLimit(1)
                                               .minimumScaleFactor(0.8)
                                               .frame(maxWidth: .infinity, alignment: .leading)
                                           
                                           WidgetComponents.DaysCounter(days: event.days)
                                               .font(.system(size: 24, weight: .bold))
                                               .frame(maxWidth: .infinity, alignment: .leading)
                                           
                                           // Add a Divider if it's not the last item
                                           if index < eventList.count - 1 {
                                               Divider()
                                                   .background(Color.gray.opacity(0.4))
                                                   .padding(.vertical, 5)
                                           }
                                       }
                                       .padding(.vertical, 8)
                                       .padding(.horizontal, 8)
                                       .background(Color(.systemGray6))
                                       .cornerRadius(10)
                                   }
                               }
                               .padding(.horizontal, 10)
                               .frame(width: geometry.size.width, height: geometry.size.height)
                ForEach(eventList) { event in
                    VStack(alignment: .leading, spacing: 5) {
                        WidgetComponents.NameView(name: event.name)
                            .minimumScaleFactor(0.5)
                            
                                               WidgetComponents.DaysCounter(days: event.days)
                            .font(.system(size: 24, weight: .bold))
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct LargeWidgetView: View {
    var event: Event

    var body: some View {
    }

}
