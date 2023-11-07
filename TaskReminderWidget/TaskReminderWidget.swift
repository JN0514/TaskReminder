//
//  TaskReminderWidget.swift
//  TaskReminderWidget
//
//  Created by JAYA$URYA on 07/11/23.
//

import WidgetKit
import CoreData
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> TaskReminderEntry {
        TaskReminderEntry(date: Date(), title: "Task Name", deadlineDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskReminderEntry) -> ()) {
        let entry: TaskReminderEntry
        
        if let taskDetail = TaskDetailModel.fetchUpcomingTask().first{
            entry = TaskReminderEntry(date: Date(), title: taskDetail.taskTitle!, deadlineDate: taskDetail.deadlineDate!)
        }
        else{
            entry = TaskReminderEntry(date: Date(), title: "Task Name", deadlineDate: Date())
        }

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TaskReminderEntry] = []
        var currentDate = Date()
        let taskDetails = TaskDetailModel.fetchUpcomingTask()
        
        for taskDetail in taskDetails {
            let entry = TaskReminderEntry(date: currentDate, title: taskDetail.taskTitle!, deadlineDate: taskDetail.deadlineDate!)
            currentDate = taskDetail.deadlineDate!
            entries.append(entry)
        }
        let entry = TaskReminderEntry(date: Date(), title: "Task Name", deadlineDate: Date(timeIntervalSinceNow: 1000))
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .after(entries.last?.deadlineDate ?? Date(timeIntervalSinceNow: 60*15)))
        completion(timeline)
    }
}

struct TaskReminderEntry: TimelineEntry {
    let date: Date
    let title: String
    let deadlineDate: Date
}

struct TaskReminderWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center) {
            Text(entry.title)
            HStack{
                Text("Remaining time: ")
                Text(timerInterval: entry.date...entry.deadlineDate, countsDown: true, showsHours: true)
            }
        }

    }
}

struct TaskReminderWidget: Widget {
    let kind: String = "TaskReminderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Task Reminder")
        .description("This will inform your task deadline")

    }
}

struct TaskReminderWidget_Previews: PreviewProvider {
    static var previews: some View {
        TaskReminderWidgetEntryView(entry: TaskReminderEntry(date: Date(), title: "", deadlineDate: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
