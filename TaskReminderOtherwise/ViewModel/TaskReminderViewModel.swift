//
//  File.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import Foundation
import UIKit
import CoreData
import WidgetKit

struct TaskReminderViewModel{
// ViewModel to list fetch and delete tasks
    let context = PersistentContainer.shared.viewContext

    //This handler is to notify table view to reload
    var performActionForTaskDetailValueChange: (()->Void)?
    
    //When this property changes table view will be notified.
    var taskDetails: [TaskDetail] = [] {
        didSet{
            performActionForTaskDetailValueChange?()
        }
    }
    
    //Fetching Tasks in Core data and list them in sorted order.
    //Completed Tasks will be after upcoming tasks.
    mutating func getTaskDetails(){
        do{
            let tasks = try context.fetch(TaskDetail.fetchRequest())
            let overDueTasks = tasks.filter{$0.deadlineDate!<=Date()}.sorted { $0.deadlineDate! > $1.deadlineDate! }
            let upcomingTasks = tasks.filter{$0.deadlineDate!>Date()}.sorted { $0.deadlineDate! < $1.deadlineDate! }
            self.taskDetails = upcomingTasks+overDueTasks
        } catch(let err as NSError){
            fatalError(err.localizedDescription)
        }
    }
    
    //Delete and remove the task at this index from taskdetails list and coredata.
    mutating func deleteTaskDetail(at index: Int){
        let taskDetail = self.taskDetails.remove(at: index)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskDetail.id!.uuidString])
        context.delete(taskDetail)
        PersistentContainer.shared.saveContext()
//        PersistentContainer.shared.exportCoreData()
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskReminderWidget")
    }
    
    //This is to get the time difference in days, hours and minutes of a task at this index in taskdetails.
    //When the difference is negative, displaying task is overdue.
    //
    func getRemainingTimeFromTaskDetail(at index: Int) -> (String, UIColor){
        let curDate = Date()
        var remainingTime = ""
        guard let deadlineDate = self.taskDetails[index].deadlineDate else {return ("", UIColor.tertiaryLabel)}
        guard deadlineDate > curDate else {return ("Overdue", UIColor.systemRed)}
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: curDate, to: deadlineDate)
        if let days = components.day, days != 0{
            remainingTime = "\(days) \(days == 1 ? "day":"days"), "
        }
        if let hrs = components.hour, hrs != 0{
            remainingTime += "\(hrs) \(hrs == 1 ? "hr":"hrs"), "
        }
        var addPlusOneToMin = false
        if let seconds = components.second, seconds != 0{
            addPlusOneToMin = true
        }
        if var mins = components.minute{
            mins = addPlusOneToMin ? mins+1 : mins
            remainingTime += "\(mins) \(mins == 1 ? "min":"mins")"
        }

        return (remainingTime, UIColor.secondaryLabel)
    }
    
    //This is to calculate when to start firing timer.
    //This is helpful, to be in sync with system clock.
    func calculateNextMinuteToStartFireTimer() -> Date{
        let calender = Calendar.current
        let components = calender.dateComponents([ .second], from: Date())
        
        guard let seconds = components.second else{return Date()}
        
        let diff = 60-seconds
        guard let date = calender.date(byAdding: .second, value: diff, to: Date()) else{return Date()}
        return date
    }
}
