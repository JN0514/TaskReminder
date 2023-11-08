//
//  CreateTaskViewModel.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import Foundation
import UIKit

struct CreateUpdateTaskViewModel{
// This View Model is to Create New Task and Update Existing Task.
    let context = PersistentContainer.shared.viewContext

    //This handler is to Notify Objects, upon completion of task creation or updation.
    var notifyAddedOrUpdatedStatus: (()->Void)?
    
    //Set value to this property, during task updation
    //For task creation, leave this property as nil
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
    
    
    //This method is to create or update task.
    func createOrUpdateTask(with title: String, desc: String, date: Date, time: Date, completionHandler: @escaping (Bool, String)->Void?){
        
        //Show Alert, when there is title or description
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
        
        //Show Alert, when choosen deadline date is not upcoming dates
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
//        PersistentContainer.shared.exportCoreData()
        completionHandler(true, "success")
        self.notifyAddedOrUpdatedStatus?()
    }
    
    //This method is schedule Local Notifcation with following parameters.
    private func scheduleNotification(with id: UUID, title: String, subTitle: String, date: Date){
        let unUserNotificationCenter = UNUserNotificationCenter.current()
        //If any notification is pending with this "ID", remove it.
        unUserNotificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        
        //Take differences of current date and date to trigger notifications, in seconds.
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

