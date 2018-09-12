//
//  Project.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/23/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import Foundation

struct Project: Comparable {
    
    var name: String
    var recordings: [Recording]?
    var sortedBy: SortingMethod
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        let alphabetBool = lhs.name < rhs.name
        switch lhs.sortedBy {
        case .alphabet:
            return alphabetBool
        case .dateModified:
            guard let leftRecordings = lhs.recordings else {return alphabetBool}
            guard leftRecordings.count != 0 else {return alphabetBool}
            guard let rightRecordings = rhs.recordings else {return alphabetBool}
            guard rightRecordings.count != 0 else {return alphabetBool}
            
            let leftRecordingsSorted = leftRecordings.sorted()
            let rightRecordingsSorted = rightRecordings.sorted()
            
            var result = alphabetBool
            for index in 0 ..< leftRecordings.count {
                if leftRecordingsSorted[index] != rightRecordingsSorted[index] {
                    result = leftRecordingsSorted[index] < rightRecordingsSorted[index]
                    break
                }
            }
            return result
        }
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        switch lhs.sortedBy {
        case .alphabet:
            return lhs.name == rhs.name
        //not sure what's going on below... had returns for lhs.name < rhs.name
        //.dateModified doesn't really matter for recordings that don't have dates anyways...
        case .dateModified:
            guard let leftRecordings = lhs.recordings else {return false}
            guard leftRecordings.count != 0 else {return false}
            guard let rightRecordings = rhs.recordings else {return false}
            guard rightRecordings.count != 0 else {return false}
            
            return leftRecordings.sorted() == rightRecordings.sorted()
        }
    }
}

enum SortingMethod {
    case alphabet, dateModified
}
