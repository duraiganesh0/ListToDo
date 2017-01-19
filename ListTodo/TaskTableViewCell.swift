//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by nanthakumar on 26/12/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    
  @IBOutlet weak var taskNameLabel: UILabel!
  
  @IBOutlet weak var dueDateLabel: UILabel!
  
  @IBOutlet weak var completeTaskButton: UIButton!
  
  @IBOutlet weak var deleteTaskButton: UIButton!
  
  var task: Task?
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  @IBAction func completeButtonAction(_ sender: AnyObject) {
    if task?.isComplete == true {
      task?.isComplete = false
    } else {
      task?.isComplete = true
    }
    
    do {
      try context.save()
      self.viewController().view.makeToast("Task Completed", duration: 2.0, position: .center)
      self.viewController().viewWillAppear(true)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func deleteButtonAction(_ sender: AnyObject) {
    context.delete(task!)
    
    do {
      try context.save()
      self.viewController().view.makeToast("Task Deleted", duration: 2.0, position: .center)
      self.viewController().viewWillAppear(true)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

}
