//
//  Extensions.swift
//  ListTodo
//
//  Created by Ganesh on 17/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
  
  public func viewController() -> UIViewController {
    var view = self as UIView
    while !view.superview!.isKind(of: UITableView.self) {
      view = view.superview!
    }
    let tableView = view.superview as! UITableView
    let viewController = tableView.dataSource as! UIViewController
    
    return viewController
  }
  
  public func tableView() -> UITableView {
    var view = self as UIView
    while !view.superview!.isKind(of: UITableView.self) {
      view = view.superview!
    }
    let tableView = view.superview as! UITableView
    
    return tableView
  }
  
  
}
