//
//  NRCircularButton.swift
//  Finder
//
//  Created by Ganesh on 13/07/16.
//  Copyright © 2016 crystaldelta. All rights reserved.
//

import Foundation
import UIKit

class NRCircularButton: UIButton {
  
  var borderColor: UIColor = UIColor.white
  var borderWidth: CGFloat = 0.0
  
  var setBorderWidth:CGFloat = 0.0{
    didSet{
      borderWidth = setBorderWidth
    }
  }
  
  override func draw(_ rect: CGRect) {
    self.clipsToBounds = true
    
    //half of the width
    self.layer.cornerRadius = rect.size.width/2.0
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    self.contentMode = UIViewContentMode.scaleToFill
    self.imageView?.contentMode = UIViewContentMode.scaleToFill
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
    self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    //self.layer.shadowColor = UIColor(hexString: "#E87975").cgColor
    self.clipsToBounds = true
    
  }
}



