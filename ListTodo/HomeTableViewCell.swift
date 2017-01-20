//
//  HomeTableViewCell.swift
//  ListTodo
//
//  Created by Ganesh on 20/01/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var groupName: UILabel!
  
  @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
