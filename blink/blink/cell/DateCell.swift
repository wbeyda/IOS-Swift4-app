//
//  DateCell.swift
//  blink
//
//  Created by Dharmesh Sonani on 09/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
