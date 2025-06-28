//
//  FunFactWidget.swift
//  FunFactWidget
//
//  Created by Justin Glazer on 6/27/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of seven entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct FunFactWidgetEntryView : View {
    var entry: DayEntry

    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(.blue.gradient)
            VStack{
                HStack{
                    Text(entry.date.formatted(.dateTime.weekday(.wide)))
                        .font(.title)
                    Text(entry.date.formatted(.dateTime.month(.wide)))
                        .font(.title)
                    Text(entry.date.formatted(.dateTime.day()))
                        .font(.title)
                    
                }
                Text("Fact Here")
                    .font(.headline)
            
            }
            
        }
        
    }
}

struct FunFactWidget: Widget {
    let kind: String = "FunFactWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FunFactWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Fun Fact Widget")
        .description("Gives a fun fact based on the day.")
        .supportedFamilies([.systemMedium])
    }
}

struct FunFactWidget_Previews: PreviewProvider {
    static var previews: some View {
        FunFactWidgetEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
