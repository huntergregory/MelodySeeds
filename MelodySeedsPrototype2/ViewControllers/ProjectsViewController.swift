//
//  ProjectsTableViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/19/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit


//FIX   cells get messed up if you cancel a new project
class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var projects: [Project]!
    var recordings: [Recording]!
    var sortingSetting: SortingMethod = .dateModified
    var deleteProjectIndexPath: IndexPath? = nil
    //var noProjectsCell = NoProjectsCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ////// if update this, modify recording VC
        //set up back button that can have segues
        let customBackButton = UIButton(type: .custom)
        customBackButton.setImage(UIImage(named: "BackButtonWhite2"), for: .normal)
        //or just UIView( that image ^)...?
        backButton.customView = customBackButton
        //FIXXX   back Button doesn't go back
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    /*allows pop animation but no prepare for segue characteristics
    @objc func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    } */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sortProjects(by: sortingSetting)
        tableView.reloadData()
        
        //show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //background image for table View
        //if modify this, modify in home VC
        let imageView = UIImageView(image: UIImage(named: "GreenAndBlack"))
        imageView.contentMode = .scaleAspectFill
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    //          class functions         //
    //returns a string "n recording(s)"
    func numberOfRecordings(in project: Project) -> String {
        var recordingsInProject = 0
        if let recordings = project.recordings {
            recordingsInProject = recordings.count
        }
        var word = " recording"
        if recordingsInProject != 1 {
            word = " recordings"
        }
        return String(recordingsInProject) + word
    }
    
    
    func sortProjects(by sortingMethod: SortingMethod) {
        guard projects.count != 0 else {return}
        var someRecordingsAreEmpty: Bool = false
        for index in 0 ..< (projects.count) {
            projects[index].sortedBy = sortingMethod
            if projects[index].recordings == nil {
                someRecordingsAreEmpty = true
            }
        }
        
        switch sortingMethod {
        case .alphabet:
            projects.sort()
        case .dateModified:
            if someRecordingsAreEmpty {
                var projectsWithoutRecordings: [Project] = []
                var lastIndex = projects.count - 1
                while lastIndex >= 0 {
                    if projects![lastIndex].recordings == nil {
                        let removedProject = projects.remove(at: lastIndex)
                        projectsWithoutRecordings.append(removedProject)
                    }
                    lastIndex -= 1
                }
                projectsWithoutRecordings.sort()
                projects.sort()
                for project in projectsWithoutRecordings {
                    projects.append(project)
                }
            } else {
                projects.sort()
            }
        }
    }
    
    //          tableView stuff             //
    func numberOfSections(in tableView: UITableView) -> Int {
        var result = 1
        if projects.count != 0 {
            result = projects.count
        }
        return result
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    //returns NoProjectCell if there are no projects. Else return, a project cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard projects.count != 0 else {
            return tableView.dequeueReusableCell(withIdentifier: "NoProjectsCell", for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        let project = projects[indexPath.section]
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = numberOfRecordings(in: project)
        return cell
    }
    
    //make cells translucent. Could do this in cellForRowAt indexPath
    //doesn't work when I navigate back from individual project vc. (won't be using a nav controller tho so this should be alright
    //if modify this, modify identical code in home VC
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translucent = UIColor(white: 1, alpha: 0.7)
        cell.textLabel?.backgroundColor = translucent
        cell.detailTextLabel?.backgroundColor = translucent
        cell.backgroundColor = translucent
        //cell.changeBackground(to: UIColor(white: 1, alpha: 0.5))
    }
    
    //          editing table View      //
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else {return false}
        if cell is ProjectNameTableViewCell {
            return true
        } else {
            return false
        }
    }

    //inserting managed by segue from + button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if projects.count > 0 {
            if editingStyle == .delete {
                deleteProjectIndexPath = indexPath
                confirmDelete(project: projects[indexPath.section])
            }
        }
    }
    
    //FIX...should make a new cell but not a new project until text field is filled and user hits done on some button. Make a cancel button too, or automatically cancel if back button pressed. Disable selecting other cells during this phase
    /*
    func insertNewProject(name: String, recordings: [Recording]?, sortedBy: SortingMethod) {
        let newProject = Project(name: name, recordings: recordings, sortedBy: sortedBy)
        if projects.count != 0 {
            projects.append(newProject)
        }
        tableView.reloadData()
        //or some type of animation...
    }
    */
    // DELETE ^^
    
    func confirmDelete(project: Project) {
        let alert = UIAlertController(title: "Permanently delete \(project.name)?", message: "The project's recordings won't be deleted", preferredStyle: .alert)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteProject)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteProject)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        // Support display in iPad?? andrewcbancroft
        /*
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        */
        self.present(alert, animated: true, completion: nil)
    }
    
    //a little funky here....
    func handleDeleteProject(alertAction: UIAlertAction!) -> Void {
        let section = deleteProjectIndexPath!.section
        tableView.beginUpdates()
        //fix this if make recordings just a [] instead of an optional
        if let count = (projects[section].recordings?.count) {
            for index in 0 ..< count {
                projects[section].recordings![index].projectName = nil
            }
        }
        projects.remove(at: section)
        tableView.deleteSections([section], with: .automatic)
        deleteProjectIndexPath = nil
            
        tableView.endUpdates()
    }
    
    func cancelDeleteProject(alertAction: UIAlertAction!) {
        deleteProjectIndexPath = nil
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)! is ProjectNameTableViewCell {
            performSegue(withIdentifier: "IndividualProjectSegue", sender: tableView.cellForRow(at: indexPath))
        }
    }
    
    //Segues
    @IBAction func unwindToProjects(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveNewProjectSegue" {
            let source = segue.source as! NewProjectViewController
            /////let projectName = source.containerView.
            let projectName = "YO"
            //FIX......
        
            var projectRecordings: [Recording]?
            for index in 0 ..< recordings.count {
                if source.willJoinNewProject[index] {
                    source.recordings[index].projectName = projectName
                    if projectRecordings == nil {
                        projectRecordings = [recordings[index]]
                    } else {
                        projectRecordings!.append(recordings[index])
                    }
                }
            }
            let newProject = Project(name: projectName, recordings: projectRecordings, sortedBy: sortingSetting)
        
            recordings = source.recordings
            projects.append(newProject)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "NewProjectSegue" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers[0] as! NewProjectViewController
            destination.recordings = self.recordings
            destination.sortingSetting = self.sortingSetting
        }
        
        if segue.identifier == "IndividualProjectSegue" {
            let indexPath = tableView.indexPathForSelectedRow!
            let destination = segue.destination as! IndividualProjectTableViewController
            destination.project = projects[indexPath.section]
        }
    }

}
