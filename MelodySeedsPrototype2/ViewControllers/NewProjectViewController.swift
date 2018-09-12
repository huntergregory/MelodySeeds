//
//  NewProjectViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/23/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

//NEED TO GRAB NAMETEXT from name table view controller before save is pressed

class NewProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recordingsTableView: UITableView!
    
    var recordings: [Recording] = []
    var isInProjectAlready: [Bool] = []
    var willJoinNewProject: [Bool] = []
    var sortingSetting: SortingMethod!
    var nameText: String?
    //See note above
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBoolArrays()
    }

    func updateBoolArrays() {
        isInProjectAlready = []
        willJoinNewProject = []

        for recording in recordings {
            willJoinNewProject.append(false)
            if recording.projectName != nil {
                isInProjectAlready.append(true)
            } else {
                isInProjectAlready.append(false)
            }
        }
    }
    
    /* //can't connect to text field to apply this func when field changes
    func updateSaveButton() {
        let cell = nameTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProjectNameTableViewCell
        let cellText = cell.nameTextField.text ?? ""
        saveButton.isEnabled = !cellText.isEmpty
    }
 */
    
    //recordings table view stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Recordings (Optional)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordingsTableView.dequeueReusableCell(withIdentifier: "AllRecordingsCell", for: indexPath) as! AllRecordingsTableViewCell
        let row = indexPath.row
        
        let recording = recordings[row]
        let willJoin = willJoinNewProject[row]
        cell.update(with: recording, checkmark: willJoin)
        
        //change to gray if recording can't be selected
        if isInProjectAlready[row] {
            cell.backgroundColor = UIColor(white: 0.6, alpha: 1)
            cell.selectionStyle = .none
        }
        return cell
    }
    
    //On selection, pdates willJoinNewProject if recording isn't grayed out
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if !isInProjectAlready[row] {
            willJoinNewProject[row] = !willJoinNewProject[row]
            recordingsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let sender = sender as? UIBarButtonItem
        guard sender == saveButton else {return}
    }
    
}
