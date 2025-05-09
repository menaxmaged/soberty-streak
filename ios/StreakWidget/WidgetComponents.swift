//
//  WidgetComponents.swift
//  Runner
//
//  Created by Mena Maged on 09/05/2025.
//

import SwiftUI
import Foundation
struct WidgetComponents {
    
    
    //Main Streak
    struct StartDate: View {
        let date: String
        var body: some View {
            

                Text("Started on \(date)")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.5)



        }

    }

    // Month Streak Counter
    struct MonthStreak: View {
        let rows: Int = 2
        let columns: Int = 6
        let days: Int
        var body: some View {
            Grid(horizontalSpacing: 3, verticalSpacing: 3) {
                // Loop through the rows
                ForEach(0..<rows, id: \.self) { row in
                    // Loop through the columns in each row
                    GridRow {
                        ForEach(0..<columns, id: \.self) { col in
                            // Calculate the index for each day in the grid
                            let index = row * columns + col
                            let isFilled = index <= days / 30
                            Rectangle().frame(height: 8).foregroundStyle(
                                isFilled ? .primary : .secondary)
                        }
                    }
                }
            }
        }
    }

    // Days
    struct DaysCounter: View {
        let days: Int
        var body: some View {
            
        // Streak View
            HStack {
                Text("\(days)")
                    .font(.system(size: 35, weight: .heavy).monospacedDigit())
                    .lineLimit(1)

                Text("Days")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.secondary)
            }

        }

    }
    //Name View
    struct NameView: View {
        let name: String
        var body: some View {
            Text(name)
                .font(.system(size: 25, weight: .bold))
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.5)
                .foregroundStyle(.green)
        }
    }

}

