//
//  GroupsViewController.swift
//  ListTodo
//
//  Created by Ganesh on 17/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class GroupsViewController: UIViewController {

  @IBOutlet weak var groupsTableView: UITableView!
  
  var groups = [Group]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    groupsTableView.delegate = self
    groupsTableView.dataSource = self
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
      groups = try managedContext.fetch(Group.fetchRequest())
      if groups.count == 0 {
        self.groupsTableView.emptyDataSetSource = self
        self.groupsTableView.emptyDataSetDelegate = self
        self.groupsTableView.reloadData()
      }
    } catch {
      print("Fetching Tasks Failed..")
    }
    self.groupsTableView.reloadData()
  }
  
//////////////////////////////////////////////////////////////////////////////////////////
//
// Button Actions
//
//////////////////////////////////////////////////////////////////////////////////////////
  
  @IBAction func addButtonActiion(_ sender: AnyObject) {
    
    let alert = UIAlertController(title: "Add a Group", message: "", preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Enter group name"
    }
    alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0]
      let group = Group(context: self.context)
      group.name = textField?.text!
      do {
        try self.context.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
      self.initialize()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
  
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Table View Delegates and Data Source
//
//////////////////////////////////////////////////////////////////////////////////////////

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    cell?.selectionStyle = .none
    let group = groups[indexPath.row]
    cell?.textLabel?.text = group.name
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = groups[indexPath.row]
    let taskVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
    taskVC.group = group
    self.navigationController?.pushViewController(taskVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let group = groups[indexPath.row]
    if editingStyle == .delete {
      context.delete(group)
      
      do {
        try context.save()
        self.viewWillAppear(true)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
  }
  
}

//////////////////////////////////////////////////////////////////////////////////////////
//
// Table View Empty Data Source
//
//////////////////////////////////////////////////////////////////////////////////////////

extension GroupsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let initialString = "No Groups"
    let str = NSMutableAttributedString.init(string: initialString)
    return str
  }
}




