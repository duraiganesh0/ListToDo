//
//  ViewController.swift
//  ToDoList
//
//  Created by nanthakumar on 26/12/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

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
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "group.name = %@", (self.group?.name)!)
        tasks = try managedContext.fetch(request)
        if tasks.count == 0 {
          self.tasksTableView.emptyDataSetSource = self
          self.tasksTableView.emptyDataSetDelegate = self
          self.tasksTableView.reloadData()
        }
      } catch {
        print("Fetching Tasks Failed..")
      }
      self.tasksTableView.reloadData()
    }
  
  @IBAction func addButtonActiion(_ sender: AnyObject) {
    let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
    addTaskVC.group = self.group
    self.navigationController?.pushViewController(addTaskVC, animated: true)
  }
  
  @IBAction func backButtonClicked(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
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

extension TasksViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let initialString = "No Tasks"
    let str = NSMutableAttributedString.init(string: initialString)
    return str
  }
}








