//
//  Task+CoreDataProperties.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        let request = NSFetchRequest<Task>(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @nonobjc class func with(title: String, note: String, isDone: Bool, project: Project, in context: NSManagedObjectContext) -> Task {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
        task.title = title
        task.isDone = isDone
        task.project = project
        task.note = note
        return task
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var title: String
    @NSManaged public var note: String?
    @NSManaged public var project: Project

}
