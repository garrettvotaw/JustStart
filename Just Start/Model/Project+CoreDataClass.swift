//
//  Project+CoreDataClass.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//
//

import Foundation
import CoreData


public class Project: NSManagedObject {

    var sortedTasks: [Task] {
        guard var tasks = tasks?.allObjects as? [Task] else {return []}
        tasks.sort { $0.title.lowercased() < $1.title.lowercased() }
        return tasks
    }
    
}
