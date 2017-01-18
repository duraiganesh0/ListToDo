//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by nanthakumar on 26/12/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
  @IBOutlet weak var taskNameTextField: UITextField!
  @IBOutlet weak var dueDateTextField: UITextField!
  
  var group: Group?

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      
  }
    
    

  func saveTask(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let task = Task(context: managedContext)
    task.name = taskNameTextField.text!
    task.isComplete = false
    task.group = self.group
    do {
        try managedContext.save()
        self.navigationController?.popViewController(animated: true)
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func addButtonAction(_ sender: AnyObject) {
    if taskNameTextField.text != "" {
      saveTask(name: taskNameTextField.text!)
    }
  }
  
  @IBAction func backButtonClicked(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }

}
