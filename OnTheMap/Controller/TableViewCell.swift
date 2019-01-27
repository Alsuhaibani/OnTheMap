//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Alsuhaibani on 13/01/2019.
//  Copyright © 2019 Alsuhaibani. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var StudentName: UILabel!
    @IBOutlet weak var studentUrl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
