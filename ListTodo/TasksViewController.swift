//
//  ViewController.swift
//  ToDoList
//
//  Created by nanthakumar on 26/12/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var tasks = [Task]()
    
    var group: Group?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialize()
    }

    func initialize() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      
      do {
        tasks = try managedContext.fetch(Task.fetchRequest())
      } catch {
        print("Fetching Tasks Failed..")
      }
      self.tasksTableView.reloadData()
    }
  
  @IBAction func addButtonActiion(_ sender: AnyObject) {
    let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
    self.navigationController?.pushViewController(addTaskVC, animated: true)
  }
  
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")! as! TaskTableViewCell
    let task = tasks[indexPath.row]
    cell.task = task
    cell.taskNameLabel.text = task.name
    if task.isComplete == true {
      cell.completeTaskButton.setImage(UIImage(named: "AcceptIconinSelectoin"), for: .normal)
    } else {
      cell.completeTaskButton.setImage(UIImage(named: "Accept Icon"), for: .normal)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
  }
    
}
