//
//  FunFactWidget.swift
//  FunFactWidget
//
//  Created by Justin Glazer on 6/30/25.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct FunFactWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(.green.gradient)
            VStack{
                HStack{
                    Text(entry.date.formatted(.dateTime.weekday(.wide)))
                        .font(.title)
                    Text(entry.date.formatted(.dateTime.month(.wide)))
                        .font(.title)
                    Text(entry.date.formatted(.dateTime.day()))
                        .font(.title)
                    
                }
                Text("Fact Goes Here")
                    .font(.headline)
            
            }
            
        }
        
    }
}

struct FunFactWidget: Widget {
    let kind: String = "FunFactWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FunFactWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Fun Fact Widget")
        .description("Gives a fun fact based on the day.")
        .supportedFamilies([.systemMedium])
    }
}

struct FunFactWidget_Previews: PreviewProvider {
    static var previews: some View {
        FunFactWidgetEntryView(entry: DayEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
