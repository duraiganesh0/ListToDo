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
  
  lazy var formatter: DateFormatter = {
    var tmpFormatter = DateFormatter()
    tmpFormatter.dateFormat = "dd-MM-YYYY"
    return tmpFormatter
  }()

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
  
//////////////////////////////////////////////////////////////////////////////////////////
//
// User Defined Functions
//
//////////////////////////////////////////////////////////////////////////////////////////

  func initialize() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    do {
      let request: NSFetchRequest<Task> = Task.fetchRequest()
      request.predicate = NSPredicate(format: "group.name = %@", (self.group?.name)!)
      let sectionSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
      request.sortDescriptors = [sectionSortDescriptor]
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

//////////////////////////////////////////////////////////////////////////////////////////
//
// Button Actions
//
//////////////////////////////////////////////////////////////////////////////////////////
  
  @IBAction func addButtonActiion(_ sender: AnyObject) {
    let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
    addTaskVC.isForAdding = true
    addTaskVC.group = self.group
    self.navigationController?.pushViewController(addTaskVC, animated: true)
  }
  
  @IBAction func backButtonClicked(_ sender: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Table View Delegates and Data Source
//
//////////////////////////////////////////////////////////////////////////////////////////

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")! as! TaskTableViewCell
    cell.selectionStyle = .none
    let task = tasks[indexPath.row]
    cell.task = task
    cell.taskNameLabel.text = task.name
    cell.cardView.setcardView()
    let calendar = Calendar.current
    if let date = task.dueDate {
      cell.dueDateLabel.text = formatter.string(from: date as Date)
      cell.dayLabel.text = String(calendar.component(.day, from: date as Date))
      cell.monthLabel.text = Utils.getMonthOfDate(dateFromDB: date as Date)
      cell.timeLabel.text = Utils.getTimeOfDate(dateFromDB: date as Date)
    }
    if task.isComplete == true {
      cell.completeTaskButton.setImage(UIImage(named: "AcceptIconinSelectoin"), for: .normal)
    } else {
      cell.completeTaskButton.setImage(UIImage(named: "Accept Icon"), for: .normal)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    let addTaskVC = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
    addTaskVC.isForAdding = false
    addTaskVC.taskFromTasksVC = task
    self.navigationController?.pushViewController(addTaskVC, animated: true)
  }
    
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Table View Empty Data Source
//
//////////////////////////////////////////////////////////////////////////////////////////

extension TasksViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let initialString = "No Tasks"
    let str = NSMutableAttributedString.init(string: initialString)
    return str
  }
}








