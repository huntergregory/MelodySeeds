//
//  RecordingTableViewCell.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/18/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class RecordingTableViewCell: UITableViewCell {
   
    @IBOutlet weak var seedNameTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pausePlayButton: UIButton!
    var recording: Recording!
    
    var isPlaying = false
    
    func update(with recording: Recording, includeProjectName bool: Bool) {
        //initialize cell's recording variable
        self.recording = recording
        
        seedNameTextField.text = recording.name
        dateLabel.text = recording.dateString
        durationLabel.text = recording.durationString
        
        if !bool {
            projectNameTextField = nil
        } else {
            if let projectName = recording.projectName {
                projectNameTextField!.text = projectName
            } else {
                projectNameTextField!.text = "(Project)"
                //apply a different hue to the text if project not assigned
            }
        }
    }
    
    func makeTranslucent() {
        let translucent = UIColor(white: 1, alpha: 0.7)
        seedNameTextField.backgroundColor = translucent
        projectNameTextField?.backgroundColor = translucent
        dateLabel.backgroundColor = translucent
        durationLabel.backgroundColor = translucent
        pausePlayButton.backgroundColor = translucent
        backgroundColor = translucent
    }
    
    @IBAction func pausePlayPressed(_ sender: UIButton) {
        if isPlaying {
            
            //begin or continue playback
            //check to see if there's an audioSession. if there is, see if it matches the recordin associated with this  cell
            
            pausePlayButton.setImage(UIImage(named: "pause button1"), for: .normal)
        } else {
            pausePlayButton.setImage(UIImage(named: "play button4"), for: .normal)
            
            //pause playback
            //
        }
        isPlaying = !isPlaying
    }
    
    
}
