//
//  ButtonTableViewCell.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/28/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    
    var horizontalStack = UIStackView()
    var editButton = UIButton()
    var metronomeButton: UIButton?
    //^create if recording.metronome.isOn
    var deleteButton = UIButton()
    var shareButton = UIButton()
    //split bottom row of cell into four parts if wasUsed, into three if not

    //necessary for some stupid reason
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(with recording: Recording) {
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fillEqually
        editButton.setTitle("yo", for: .normal)
        metronomeButton?.setTitle("oh", for: .normal)
        shareButton.setTitle("shur", for: .normal)
        deleteButton.setTitle("delete", for: .normal)
        
        horizontalStack.addArrangedSubview(editButton)
        
        let metronome = recording.metronome
        if metronome.isEnabled {
            metronomeButton = UIButton()
            if metronome.isOn {
                //turn on metronome icon color
            } else {
                //turn color off
            }
            //further CONFIGURE button
            horizontalStack.addArrangedSubview(metronomeButton!)
        } else {
            metronomeButton = nil
        }
        horizontalStack.addArrangedSubview(deleteButton)
        horizontalStack.addArrangedSubview(shareButton)
        view.addSubview(horizontalStack)
    }
    
    func makeTranslucent() {
        backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
}
