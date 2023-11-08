//
//  TaskDetailModel.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 07/11/23.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer{
    
    static let shared: PersistentContainer = {
        guard let modelURL = Bundle.main.url(forResource: "TaskReminderOtherwise",
                                             withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        let container = PersistentContainer(name: "TaskReminderOtherwise", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription:NSPersistentStoreDescription, error:Error?) in
            if let error = error as NSError?{
                fatalError("UnResolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.org.TaskReminderOtherwise.app")!
        
    }
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
    func saveContext () {
        let context = PersistentContainer.shared.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchUpcomingTask() -> [TaskDetail] {
        let context = PersistentContainer.shared.viewContext
        
        do {
            let taskDetails = try context.fetch(TaskDetail.fetchRequest())
            let date = Date()
            return taskDetails.filter{$0.deadlineDate! > date}.sorted{ $0.deadlineDate! < $1.deadlineDate!}
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
