//
//  OtherStructs.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/28/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import Foundation
import UIKit

extension Recording {
    struct Metronome: Codable {
        //blue metronome top right was clicked when recording created
        var isEnabled: Bool
    
        //can be flicked off after recording finishes recording. Triggers destructive interference
        var isOn: Bool
        //^ visible if time sig is used
        var timeSig: TimeSig?
        //var sound: Sound?
    
        init(isEnabled: Bool, isOn: Bool, timeSig: TimeSig?) {//, sound: Sound?) {
            self.isEnabled = isEnabled
            self.isOn = isOn
            self.timeSig = timeSig
            //self.sound = sound
        }
    }
}

extension Recording.Metronome {
    //make it so this can only be an even number 2-16 in denominator; all ints 1-8 in numerator?
    struct TimeSig: Codable {
        var numerator: Int
        var denominator: Int
    }
    /*
    enum Sound {
        case one, two
    }
 */
}

