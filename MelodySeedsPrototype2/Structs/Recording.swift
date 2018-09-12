//
//  Recording.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/18/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import Foundation

struct Recording: Comparable, Codable {
    var name: String
    var projectName: String?
    var date: Date
    var metronome: Metronome
    var duration: Double
    var notes: String?
    
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0.0
    var cellIsExpanded: Bool = false
    
    var durationString: String? {
        let roundedDuration = round(duration)
        let minutes = floor(roundedDuration / 60)
        let seconds = Int(roundedDuration - 60 * minutes)
        var string = "\(seconds) sec"
        if minutes > 0 {
            string = "\(Int(minutes)) min \(seconds) sec"
        }
        return string
    }
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    static var archiveURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("recordings").appendingPathExtension("plist")
    }
    
    func loadRecordings() -> [Recording]? {
        guard let recordingData = try? Data(contentsOf: Recording.archiveURL) else { return nil}
        let encodedRecordings = try? PropertyListDecoder().decode(Array<Recording>.self, from: recordingData)
        return encodedRecordings
    }
    
    func saveToFile(recordings: [Recording]) {
        let encodedRecordings = try? PropertyListEncoder().encode(recordings)
        try? encodedRecordings?.write(to: Recording.archiveURL, options: .noFileProtection)
        //change writing options???
    }
    
    
    init(name: String, projectName: String?, date: Date, metronome: Metronome, duration: Double) {
        self.name = name
        self.projectName = projectName
        self.date = date
        self.metronome = metronome
        self.duration = duration
    }
    
    static func < (lhs: Recording, rhs: Recording) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Recording, rhs: Recording) -> Bool {
        return lhs.date == rhs.date
    }
}
