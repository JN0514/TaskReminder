//
//  TaskDetail+CoreDataProperties.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 06/11/23.
//
//

import Foundation
import CoreData


extension TaskDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskDetail> {
        return NSFetchRequest<TaskDetail>(entityName: "TaskDetail")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var deadlineDate: Date?

}

extension TaskDetail : Identifiable {

}
