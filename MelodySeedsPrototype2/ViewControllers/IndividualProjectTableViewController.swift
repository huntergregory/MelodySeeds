//
//  IndividualProjectTableViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/28/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

//Change this if you make changes to homeViewVC

class IndividualProjectTableViewController: UITableViewController {

    var project: Project!
    var recordings: [Recording]!
    var selectedRecording: Recording!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = project.name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return recordings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordings[section].cellIsExpanded {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recording = recordings[indexPath.section]
        var returnedCell = UITableViewCell()
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell")! as! RecordingTableViewCell
            cell.update(with: recording, includeProjectName: false)
            returnedCell = cell
        } else if indexPath.row == 2{ //the expanded row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell")! as! ButtonTableViewCell
            cell.update(with: recording)
            returnedCell = cell
        }
        return returnedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let selectedCellIsExpanded = recordings[section].cellIsExpanded
        
        
        var anyAreExpanded = false
        var expandedIndex: Int?
        for index in 0 ..< recordings.count {
            if recordings[index].cellIsExpanded {
                anyAreExpanded = true
                expandedIndex = index
                break
            }
        }
        
        //do nothing if clicked row is the expanded cell (row == 1)
        if indexPath.row == 0 {
            //closes an expanded cell if any other recording cell is tapped
            if anyAreExpanded && expandedIndex != section {
                if indexPath.row == 0 {
                    for index in 0 ..< recordings.count {
                        recordings[index].cellIsExpanded = false
                        //then need to animate this closing...
                    }
                }
            } else if !selectedCellIsExpanded {
                recordings[indexPath.section].cellIsExpanded = true
                //^animate....
                selectedRecording = recordings[section]
            }
        }
    }
    
    //not sure how to fix this.......
    @IBAction func unwindToIndividualProject(segue: UIStoryboardSegue) {
        /*
        if segue.identifier == "UnwindToProject" {
            let source = segue.source as! RecordingViewController
            recordingData.append(source.recordingData)
            var recordings = [Recording]()
            for data in recordingData {
                recordings.append(data.recording)
            }
            project = Project(name: recordingData[0].recording.projectName!, recordings: recordings, sortedBy: .dateModified)
        } */
    }

}
