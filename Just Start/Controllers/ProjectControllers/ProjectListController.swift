//
//  ProjectListController.swift
//  Just Start
//
//  Created by Garrett Votaw on 7/26/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData

class ProjectListController: UITableViewController {
    
    let context = CoreDataStack().managedObjectContext
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching the Entries!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /********************************/
    // MARK: - Table view data source
    /********************************/

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {return 0}
        return section.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        let project = fetchedResultsController.object(at: indexPath)
        cell.projectLabel.text = project.title
        cell.subtitleLabel.text = project.subtitle
        if let tasks = project.tasks?.allObjects as? [Task] {
            var incompleteTasks = 0
            for task in tasks {
                if !task.isDone {
                    incompleteTasks += 1
                }
            }
            if incompleteTasks == 0 {
                cell.blueView.isHidden = true
                cell.taskCountLabel.isHidden = true
            } else {
                cell.blueView.isHidden = false
                cell.taskCountLabel.isHidden = false
                cell.taskCountLabel.text = "\(incompleteTasks)"
            }
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProject", sender: nil)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let project = fetchedResultsController.object(at: indexPath)
            context.delete(project)
            do {
                try context.saveChanges()
            } catch {
                print("Error occured while deleting project!")
            }
            
        }
    }

    /********************************/
    // MARK: - Navigation
    /********************************/
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addProject" {
            let nextVC = segue.destination as! UINavigationController
            guard let addProjectController = nextVC.topViewController as? AddProjectController else {return}
            addProjectController.context = context
        } else if segue.identifier == "showProject" {
            let nextVC = segue.destination as! TaskListController
            nextVC.context = context
            nextVC.project = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
        }
        
    }
 

}

extension ProjectListController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move, .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
