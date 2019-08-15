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
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
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

    func calculatePercentComplete() -> Double {
        guard let tasks = tasks?.allObjects as? [Task] else {return 0.0}
        var completeTasks = 0.0
        let totalTasks = tasks.count
        for task in tasks {
            if task.isDone {
                completeTasks += 1.0
            }
        }
        if totalTasks > 0 {
            return completeTasks/Double(totalTasks)
        } else {
            return 0
        }
        
    }
    
    func numberOfTasks() -> Int {
        guard let tasks = tasks?.allObjects as? [Task] else {return 0}
        return tasks.count
    }
    
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
