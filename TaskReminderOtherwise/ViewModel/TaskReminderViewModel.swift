//
//  File.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//

import Foundation
import UIKit
import CoreData

struct TaskReminderViewModel{
    let context = {
        let container = NSPersistentContainer(name: "TaskReminderOtherwise")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }().viewContext
    
    var performActionForTaskDetailValueChange: (()->Void)?
    var loadVisibleCellsEveryOneMinute: (()->Void)?
    
    var taskDetails: [TaskDetail] = [] {
        didSet{
            performActionForTaskDetailValueChange?()
        }
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch(let err as NSError){
            fatalError(err.localizedDescription)
        }
    }
    
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
    
    mutating func deleteTaskDetail(at index: Int){
        let taskDetail = self.taskDetails.remove(at: index)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskDetail.id!.uuidString])
        context.delete(taskDetail)
    }
    
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

        return (remainingTime, UIColor.tertiaryLabel)
    }
    
    
    func calculateNextMinuteToStartFireTimer() -> Date{
        let calender = Calendar.current
        let components = calender.dateComponents([ .second], from: Date())
        
        guard let seconds = components.second else{return Date()}
        
        let diff = 60-seconds
        guard let date = calender.date(byAdding: .second, value: diff, to: Date()) else{return Date()}
        return date
    }
}