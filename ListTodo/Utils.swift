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
  
  var selectedImageName = ""
  
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
    notificationManager.notificationsBackgroundColor = Utils.hexStringToUIColor(hex: "#3045D4")
    notificationManager.notificationsTitleTextColor = UIColor.white
    notificationManager.notificationsBodyTextColor = UIColor.white
    notificationManager.notificationsSeperatorColor = UIColor.gray
    //notificationManager.notificationsIcon = UIImage(named: "myna-notify")
  }
  
  func notifyLocally(_ message: String, title: String) {
    setNotificationSettings()
    notificationManager.showNotification(title: title, body: message, onTap: { () -> Void in
      
      self.notificationManager.dismissActiveNotification(completion: { () -> Void in
        print("Notification dismissed")
      })
    })
  }
  
  class func getMonthOfDate(dateFromDB: Date) -> String? {
    
    let calendar = Calendar.current
    let month = calendar.component(.month, from: dateFromDB as Date)
    
    switch month {
    case 1:
      return "Jan"
    case 2:
      return "Feb"
    case 3:
      return "Mar"
    case 4:
      return "Apr"
    case 5:
      return "May"
    case 6:
      return "Jun"
    case 7:
      return "Jul"
    case 8:
      return "Aug"
    case 9:
      return "Sep"
    case 10:
      return "Oct"
    case 11:
      return "Nov"
    case 12:
      return "Dec"
    default:
      print("Error fetching days")
      return "Day"
    }
  }
  
  class func getTimeOfDate(dateFromDB: Date) -> String? {
    let formatter: DateFormatter = {
      let tmpFormatter = DateFormatter()
      tmpFormatter.dateFormat = "hh:mm a"
      return tmpFormatter
    }()
    return formatter.string(from: dateFromDB)
  }
  
  class func downloadImageWithURL(_ url: URL, completionBlock: @escaping (_ succeeded: Bool, _ image: UIImage?) -> Void) {
    
    let sessionTask = URLSession.shared
    let request = URLRequest(url: url)
    sessionTask.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
      if (error == nil) {
        let image: UIImage = UIImage(data: data!)!
        completionBlock(true, image)
      }
      else {
        completionBlock(false, nil)
      }
    }).resume()
    
  }
  
}
