//
//  RecordCells.swift
//  Hourglass
//
//  Created by 김문옥 on 06/12/2018.
//  Copyright © 2018 김문옥. All rights reserved.
//

import UIKit

class RecordTitleCell: UITableViewCell {

    @IBOutlet var elapsedTimeLabel: UILabel!
    @IBOutlet var workStartLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class RecordDetailCell: UITableViewCell {
    
    @IBOutlet var successiveGoalAchievementLabel: UILabel!
    @IBOutlet var estimatedWorkTimeLabel: UILabel!
    @IBOutlet var workCompleteLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
