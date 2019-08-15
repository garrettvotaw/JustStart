//
//  TaskListController.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/7/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData

protocol TaskCellDelegate: class {
    func getCompletedState(state: Bool, indexPath: IndexPath)
}

class TaskListController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var project: Project!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: true)
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectDetailsCell", for: indexPath) as! ProjectDetailsCell
            cell.titleLabel.text = project.title
            cell.subtitleLabel.text = project.subtitle
            let percentComplete = project.calculatePercentComplete()
            cell.percentCompleteLabel.text = "\(Int((percentComplete * 100).rounded()))% Complete"
            
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.delegate = self
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
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var task = project.unsortedTaskList[sourceIndexPath.row]
        context.delete(task)
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let tasks = project.tasks?.allObjects as? [Task] else {return}
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


