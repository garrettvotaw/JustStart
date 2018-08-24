//
//  AddTaskController.swift
//  Just Start
//
//  Created by Garrett Votaw on 8/9/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData

class AddTaskController: UITableViewController {

    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var completedCell: UITableViewCell!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var project: Project!
    var context: NSManagedObjectContext!
    var isAnEdit = false
    var task: Task?
    var notesIsEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        if let task = task {
            
            completedCell.isHidden = false
            titleTextField.text = task.title
            if task.note == "" {
                notesTextView.text = "Notes"
                notesTextView.textColor = UIColor(white: 0.7, alpha: 1)
            } else {
                notesTextView.text = task.note
                notesTextView.textColor = .black
            }
            
            if task.isDone {
                completedLabel.text = "Yes"
            } else {
                completedLabel.text = "No"
            }
            
            
        } else {
            completedCell.isHidden = true
        }
    }

    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            presentAlert(title: "Whoopsies!", message: "This task needs a title at the very least. Make sure you fill that out and then try again!")
            return
        }
        if let task = self.task {
            task.title = title
            task.note = notesTextView.text
        } else {
            if notesIsEdited {
                let newTask = Task.with(title: title, note: notesTextView.text, isDone: false, project: project, in: context)
                project.addToTasks(newTask)
                
            } else {
                let newTask = Task.with(title: title, note: "", isDone: false, project: project, in: context)
                project.addToTasks(newTask)
            }
            
        }
        do {
            try context.saveChanges()
            dismiss(animated: true, completion: nil)
        } catch {
            presentAlert(title: "Whoopsies!", message: "It looks like we were unable to save the changes this time around!")
        }
        
    }
}


extension AddTaskController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .black
        textView.text = ""
        notesIsEdited = true
    }
    


}







