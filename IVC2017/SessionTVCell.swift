//
//  SessionTVCellTableViewCell.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class SessionTVCell: UITableViewCell {

	@IBOutlet weak var speakerLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
