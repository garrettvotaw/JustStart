//
//  TaskListController.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData
import SwiftReorder

protocol TaskCellDelegate: class {
    func getCompletedState(state: Bool, indexPath: IndexPath)
}

protocol RowReloadListener: class {
    func reloadRows()
}

class TaskListController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var project: Project!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reorder.delegate = self
        tableView.estimatedRowHeight = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Functions
    

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return project.tasks?.count ?? 0
        case 2: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectDetailsCell", for: indexPath) as! ProjectDetailsCell
            cell.titleLabel.text = project.title
            cell.subtitleLabel.text = project.subtitle
            let percentComplete = project.calculatePercentComplete()
            cell.percentCompleteLabel.text = "\(Int((percentComplete * 100).rounded()))% Complete"
            cell.progressView.progress = Float(percentComplete)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.delegate = self
            cell.rowReloadDelegate = self
            cell.index = indexPath
            cell.taskLabel.text = project.prioritySortedTasks[indexPath.row].title
            cell.notesLabel.text = project.prioritySortedTasks[indexPath.row].note
            if project.prioritySortedTasks[indexPath.row].isDone {
                cell.checkButton.setImage(#imageLiteral(resourceName: "checkMark"), for: .normal)
            } else {
                cell.checkButton.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newTaskCell", for: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "editTask", sender: nil)
        } else if indexPath.section == 2 {
            performSegue(withIdentifier: "addTask", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 1 {
            return .delete
        } else {
            return .none
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let tasks = project.prioritySortedTasks
        project.removeFromTasks(tasks[indexPath.row])
        context.delete(tasks[indexPath.row])
        do {
            try context.saveChanges()
        } catch {
            print(error)
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        reloadRows()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 25
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask" {
            let nextVC = segue.destination as! UINavigationController
            let controller = nextVC.topViewController! as! AddTaskController
            controller.project = project
            controller.context = context
        } else if segue.identifier == "editTask" {
            let nextVC = segue.destination as! UINavigationController
            let controller = nextVC.topViewController! as! AddTaskController
            controller.isAnEdit = true
            controller.task = project.prioritySortedTasks[tableView.indexPathForSelectedRow!.row]
            controller.project = project
            controller.context = context
        }
    }

}

extension TaskListController: TaskCellDelegate {
    func getCompletedState(state: Bool, indexPath: IndexPath) {
        project.prioritySortedTasks[indexPath.row].isDone = state
        
        do {
            try context.saveChanges()
        } catch {
            print(error)
        }
    }
}

extension TaskListController: RowReloadListener {
    func reloadRows() {
        let detailsCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProjectDetailsCell
        let percentComplete = project.calculatePercentComplete()
        detailsCell.percentCompleteLabel.text = "\(Int((percentComplete * 100).rounded()))% Complete"
        UIView.animate(withDuration: 0.7) {
            detailsCell.progressView.setProgress(Float(percentComplete), animated: true)
        }
        
        
    }
}

extension TaskListController: TableViewReorderDelegate {
    
    func tableView(_ tableView: UITableView, targetIndexPathForReorderFromRowAt sourceIndexPath: IndexPath, to proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var prioritySortedTasks = project.prioritySortedTasks
        let movedTask = prioritySortedTasks.remove(at: sourceIndexPath.row)
        prioritySortedTasks.insert(movedTask, at: destinationIndexPath.row)
        
        
        var tempIndex = 0
        for task in prioritySortedTasks {
            task.index = tempIndex
            tempIndex += 1
        }
        
    }
}


