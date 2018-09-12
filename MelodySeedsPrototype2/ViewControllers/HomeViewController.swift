//
//  ViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/18/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var metronomeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordings: [Recording] = [Recording(name: "1", projectName: nil, date: Date(), metronome: Recording.Metronome(isEnabled: false, isOn: false, timeSig: nil), duration: 1.2), Recording(name: "2", projectName: nil, date: Date(), metronome: Recording.Metronome(isEnabled: false, isOn: false, timeSig: nil), duration: 2.3)]
    var projects: [Project] = []
   
    //communicates with upper right blue button
    var currentMetronome = Recording.Metronome(isEnabled: false, isOn: false, timeSig: nil)//, sound: nil)
    var selectedRecording: Recording?
    //include sortingSetting variable?
    //OR make all sorting just by date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        //background image for table View
        //if modify this, modify in projects VC
        let imageView = UIImageView(image: UIImage(named: "GreenAndBlack"))
        imageView.contentMode = .scaleAspectFill
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        recordButton.backgroundColor = UIColor.green
        
        //one-size row height
        tableView.rowHeight = 50.0
        
        //recordings = recordings.sorted()
    }

    //Table View stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordings[section].cellIsExpanded {
            return 2
        } else {
            return 1
        }
    }
    
    //make cells translucent. Could do this in cellForRowAt indexPath
    //doesn't work when I navigate back from individual project vc. (won't be using a nav controller tho so this should be alright
    //if modify this, modify identical code in projects VC
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = cell as! RecordingTableViewCell
            cell.makeTranslucent()
        } else {
            let cell = cell as! ButtonTableViewCell
            cell.makeTranslucent()
        }
        //cell.changeBackground(to: UIColor(white: 1, alpha: 0.5))
    }
    
    //FIX   can't dismiss cell if tap outside of table view altogether
    //FIX   button cell not showing stuff...probs just the UIbutton config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recording = recordings[indexPath.section]
        var returnedCell = UITableViewCell()
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as! RecordingTableViewCell
            
            cell.update(with: recording, includeProjectName: true)
            returnedCell = cell
        } else if indexPath.row == 1 { //the expanded row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.update(with: recording)
            returnedCell = cell
        }
        return returnedCell
    }
    
    
    // FIX  breaking if click one section to close another section
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let selectedCellIsExpanded = recordings[section].cellIsExpanded
        
        //do nothing if clicked row is the expanded cell (row == 1)
        if indexPath.row == 0 {
        //closes an expanded cell if any other recording cell is tapped
            //probably just need the selectedRecording. Find stuff from that
            //FIX
            if selectedRecording != nil {
                if indexPath.row == 0 {
                    var array: [Int] = []
                    for index in 0 ..< recordings.count {
                        recordings[index].cellIsExpanded = false
                        array.append(index)
                    }
                    let removedIndexPath = IndexPath(row: 1, section: section)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [removedIndexPath], with: .bottom)
                    tableView.endUpdates()
                    //FIX   text isn't animating with cell
                    selectedRecording = nil
                }
            } else if !selectedCellIsExpanded {
                recordings[section].cellIsExpanded = true
                let newIndexPath = IndexPath(row: 1, section: section)
                tableView.beginUpdates()
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.endUpdates()
                //FIX   text isn't animating with cell
                //tableView.reloadSections(IndexSet([section]), with: .bottom)
                selectedRecording = recordings[section]
            }
        }
        
    }
    
    //              Segues      //
    //unwind from projects
    //allow unwind from recording VC??
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        if let source = segue.source as? RecordingViewController {
            recordings.append(source.recording)
        } else if let source = segue.source as? ProjectsViewController {
            recordings = source.recordings
            projects = source.projects
        }
        //FIX ^^ Stuck on projects vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ProjectsSegue" {
            performProjectsSegue(segue)
        }
        
        if segue.identifier == "EditingFromHomeSegue" {
            performEditingSegue(segue)
        }
        
        if segue.identifier == "RecordingSegue" {
            performNewRecordingSegue(segue)
            recordButton.backgroundColor = UIColor.gray
        }
    }
    
    //sends projects and recordings variables
    func performProjectsSegue(_ segue: UIStoryboardSegue) {
        let destination = segue.destination as! ProjectsViewController
        destination.projects = self.projects
        destination.recordings = self.recordings
    }
    
    //Sends selectedRecording to the RecordingVC, and that it came from home. Tells RVC this isn't a new recording
    func performEditingSegue(_ segue: UIStoryboardSegue) {
        let destination = segue.destination as! RecordingViewController
        destination.recording = selectedRecording!
        destination.isNewRecording = false
        destination.cameFromHome = true
    }
    
    //Tells RVC that it's receiving a new recording, and that it came from home. Function creates a new Recording object and sends it to RVC
    func performNewRecordingSegue(_ segue: UIStoryboardSegue) {
        var seedNumber = 0
        for int in 0...30 {
            var hasIt: Bool = false
            for recording in recordings {
                if recording.name == "Melody Seed #\(int)" {
                    hasIt = true
                }
            }
            //or do something like if any recording in allRecordings has it, continue, else break
            if !hasIt {
                seedNumber = int
                break
            }
        }
        
        let recording = Recording(name: "Melody Seed \(seedNumber)", projectName: nil, date: Date(), metronome: currentMetronome, duration: 0.0)
        
        let destination = segue.destination as! RecordingViewController
        destination.recording = recording
        destination.isNewRecording = true
        destination.cameFromHome = true
    }
    
}

