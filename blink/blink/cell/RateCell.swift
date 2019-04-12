//
//  RateCell.swift
//  blink
//
//  Created by Dharmesh Sonani on 09/04/19.
//  Copyright © 2019 Deedcoin Office. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var rateView : HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
