//
//  Project+CoreDataProperties.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        let request = NSFetchRequest<Project>(entityName: "Project")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @nonobjc class func with(title: String, subtitle: String?, in context: NSManagedObjectContext) -> Project {
        let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
        project.title = title
        project.subtitle = subtitle
        return project
    }


    @NSManaged public var subtitle: String?
    @NSManaged public var title: String
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Project {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
