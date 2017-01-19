//
//  Utils.swift
//  ListTodo
//
//  Created by Ganesh on 19/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

import Foundation
import LNRSimpleNotifications

class Utils {
  
  static let sharedInstance = Utils()
  
  let notificationManager = LNRNotificationManager()
  
  class func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()  //stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
      cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))  //substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if ((cString.characters.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  func setNotificationSettings() {
    notificationManager.notificationsPosition = LNRNotificationPosition.top
    notificationManager.notificationsBackgroundColor = Utils.hexStringToUIColor(hex: "#5C0000")
    notificationManager.notificationsTitleTextColor = UIColor.white
    notificationManager.notificationsBodyTextColor = UIColor.white
    notificationManager.notificationsSeperatorColor = UIColor.gray
    //notificationManager.notificationsIcon = UIImage(named: "myna-notify")
  }
  
  func notifyLocally(_ message: String) {
    setNotificationSettings()
    notificationManager.showNotification(title: "Skylark", body: message, onTap: { () -> Void in
      
      self.notificationManager.dismissActiveNotification(completion: { () -> Void in
        print("Notification dismissed")
      })
    })
  }
  
}
