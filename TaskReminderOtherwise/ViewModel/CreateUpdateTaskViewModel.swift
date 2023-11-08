//
//  CreateTaskViewModel.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import Foundation
import UIKit

struct CreateUpdateTaskViewModel{
    
    let context = PersistentContainer.shared.viewContext

    var notifyAddedOrUpdatedStatus: (()->Void)?
    
    let taskDetail: TaskDetail?
    
    var taskTitle: String? {
        taskDetail?.taskTitle
    }
    
    var taskDescription: String? {
        taskDetail?.taskDescription
    }
    
    var date: Date {
        taskDetail?.deadlineDate ?? Date()
    }
    
    var time: Date{
        taskDetail?.deadlineDate ?? Date()
    }
    
    init(taskDetail: TaskDetail? = nil) {
        self.taskDetail = taskDetail
    }
    
    func createOrUpdateTask(with title: String, desc: String, date: Date, time: Date, completionHandler: @escaping (Bool, String)->Void?){
        guard !title.isEmpty && !desc.isEmpty else{
            completionHandler(false, "Please enter task name and task description")
            return
        }
        
        let calender = Calendar(identifier: .gregorian)
        
        let dateComponents = calender.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calender.dateComponents([.hour, .minute], from: time)
        
        let combinedComponents = DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute)
        
        guard let combinedDate = calender.date(from: combinedComponents), combinedDate > Date() else {
            completionHandler(false, "Please set future dates as deadline date")
            return
        }
        
        if let taskDetail = taskDetail{
            taskDetail.taskTitle = title
            taskDetail.taskDescription = desc
            taskDetail.deadlineDate = combinedDate
            self.scheduleNotification(with: taskDetail.id!, title: title, subTitle: desc, date: combinedDate)
        } else{
            let newTask = TaskDetail(context: context)
            newTask.id = UUID()
            newTask.taskTitle = title
            newTask.taskDescription = desc
            newTask.deadlineDate = combinedDate
            self.scheduleNotification(with: newTask.id!, title: title, subTitle: desc, date: combinedDate)
        }
        PersistentContainer.shared.saveContext()
        completionHandler(true, "success")
        self.notifyAddedOrUpdatedStatus?()
    }
    
    private func scheduleNotification(with id: UUID, title: String, subTitle: String, date: Date){
        let unUserNotificationCenter = UNUserNotificationCenter.current()
        unUserNotificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        
        let calender = Calendar.current
        let components = calender.dateComponents([.second], from: Date(), to: date)

        guard let seconds = components.second, seconds > 0 else{
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(
                        timeInterval: TimeInterval(seconds),
                        repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        
        let request = UNNotificationRequest(
                        identifier: id.uuidString,
                        content: content,
                        trigger: trigger)
        
        unUserNotificationCenter.add(request)
    }
    
}

