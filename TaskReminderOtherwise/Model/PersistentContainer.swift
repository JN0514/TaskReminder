//
//  TaskDetailModel.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 07/11/23.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer{
    
//This class is responsible for sharing core data between Application and widget extension.
    
    //Singleton Class
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
    
    //Shared Directory for Widget Extension and Application
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.org.TaskReminderOtherwise.app")!
    }
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
    //Saving changes in context to Persistent store
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
    
    //Fetching only upcoming task in a sorted order.
    //Helpful to create timeline entries for widget.
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
    
    //Implementaion of Importing and Exporting Core Data is in Progress.
    /*
     private let _coreDataBackUp = "CoreDataBackUp.dat"

    func exportCoreData(){
        /*
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appending(path: self._coreDataBackUp)
        let context = PersistentContainer.shared.viewContext
        
        guard let taskDetails = try? context.fetch(TaskDetail.fetchRequest()) else {return}
        
        let listOfTask = taskDetails.map { task in
            let copyTask = TaskModel(
                id: task.id!,
                name: task.taskTitle!,
                description: task.taskDescription!,
                date: task.deadlineDate!)
            return copyTask
        }
        
        let copyListOfTask = TaskModels(list: listOfTask)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do{
            let data = try encoder.encode(copyListOfTask)
            try data.write(to: backupUrl)
        } catch{
            print("Core Data not saved, Error: ", error)
        }
        */
        
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(self._coreDataBackUp + ".sqlite")
        
        let store:NSPersistentStore = PersistentContainer.shared.persistentStoreCoordinator.persistentStores.last!
        do {
            try PersistentContainer.shared.persistentStoreCoordinator.migratePersistentStore(
                store,
                to: backupUrl,
                options: nil,
                withType: NSSQLiteStoreType)
        } catch {
            print("Failed to migrate")
        }
        
    }
    

    func importCoreData(){
        /*
        guard UserDefaults.standard.bool(forKey: "hasLaunchedBefore") else {return}
        
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        
        let backUpFolderUrl = FileManager.default.urls(for: .allApplicationsDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appending(path: self._coreDataBackUp)
        let context = PersistentContainer.shared.viewContext
        
        do{
            let data = try Data(contentsOf: backupUrl)
            let decoder = JSONDecoder()
            let listOfTask = try decoder.decode(TaskModels.self, from: data)
            
            for taskModel in listOfTask.list{
                let newTask = TaskDetail(context: context)
                newTask.id = taskModel.id
                newTask.taskTitle = taskModel.name
                newTask.taskDescription = taskModel.description
                newTask.deadlineDate = taskModel.date
            }
            try context.save()
        } catch{
            print("Core data is not retrieved, Error:", error)
        }
        
        */
        
        let storeUrl = PersistentContainer.defaultDirectoryURL().appending(path: "TaskReminderOtherwise.sqlite")
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(self._coreDataBackUp + ".sqlite")
        
        
        guard let modelURL = Bundle.main.url(forResource: "TaskReminderOtherwise",
                                             withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        let container = PersistentContainer(name: "TaskReminderOtherwise", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription:NSPersistentStoreDescription, error:Error?) in
            let stores = PersistentContainer.shared.persistentStoreCoordinator.persistentStores
            
            for store in stores {
                print(store)
                print(PersistentContainer.shared)
            }
            
            
            do{
                try container.persistentStoreCoordinator.replacePersistentStore(
                    at: storeUrl,
                    destinationOptions: nil,
                    withPersistentStoreFrom: backupUrl,
                    sourceOptions: nil,
                    ofType: NSSQLiteStoreType)
            } catch {
                print("Failed to restore")
            }
        })
        
        PersistentContainer.shared = container
        
    }
    
    struct TaskModels: Codable{
        let list: [TaskModel]
    }
    struct TaskModel: Codable{
        let id: UUID
        let name: String
        let description: String
        let date: Date
    }
    */
}
