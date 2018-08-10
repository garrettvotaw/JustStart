//
//  AddProjectController.swift
//  Just Start
//
//  Created by Garrett Votaw on 7/30/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import UIKit
import CoreData

class AddProjectController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cancelPushed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savePushed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text else {return}
        let _ = Project.with(title: title, subtitle: subtitleTextField.text, in: context)
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            presentAlert(title: "Error", message: "We were unable to save the Project. Please try again later or contact support if the issue continues.")
        }
    }
    
}
