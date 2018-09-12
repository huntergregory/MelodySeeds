//
//  AllRecordingsTableViewCell.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/23/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class AllRecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView?
    
    
    //not working...maybe try setSelected func below
    func includeCheckmark(_ bool: Bool) {
        if bool {
            let image = UIImage(named: "GreenAndBlack")!
            checkmarkImageView = UIImageView(image: image)
        } else {
            checkmarkImageView = nil
        }
    }
    
    func update(with recording: Recording, checkmark bool: Bool) {
        nameLabel.text = recording.name
        dateLabel.text = recording.dateString
        includeCheckmark(bool)
        
        let roundedDuration = round(recording.duration)
        let minutes = floor(roundedDuration / 60)
        let seconds = Int(roundedDuration - 60 * minutes)
        var durationString = "\(seconds) sec"
        if minutes > 0 {
            durationString = "\(Int(minutes)) min \(seconds) sec"
        }
        durationLabel.text = durationString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
