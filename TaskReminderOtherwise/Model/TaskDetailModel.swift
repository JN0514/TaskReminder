//
//  TaskDetailModel.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 07/11/23.
//

import Foundation
import UIKit
import CoreData

class TaskDetailModel{
    
    class func fetchUpcomingTask() -> [TaskDetail] {
        let context = {
            let container = NSPersistentContainer(name: "TaskReminderOtherwise")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }().viewContext
        
        do {
            let taskDetails = try context.fetch(TaskDetail.fetchRequest())
            let date = Date()
            return taskDetails.filter{$0.deadlineDate! > date}.sorted{ $0.deadlineDate! < $1.deadlineDate!}
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
}
