//
//  RequestsTableViewCell.swift
//  LanguageOM
//
//  Created by Gian Marco Valentino on 6/18/16.
//  Copyright © 2016 Valentino. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
