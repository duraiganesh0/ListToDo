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


extension UIView {
  func roundCorners1(corners:UIRectCorner) {
    let radius = 2
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  func setcardView()
  {
    let cornerRadius: CGFloat = 4
    let shadowOffsetWidth: Int = 0
    let shadowOffsetHeight: Int = 0
    let shadowColor: UIColor? = UIColor.gray
    let shadowOpacity: Float = 0.5
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = false
    layer.shadowColor = shadowColor?.cgColor
    layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
    layer.shadowOpacity = shadowOpacity
  }
  
}
