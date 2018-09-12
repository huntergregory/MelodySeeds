//
//  NameTableViewController.swift
//  MelodySeedsPrototype2
//
//  Created by Hunter Gregory on 8/28/18.
//  Copyright © 2018 Hunter Gregory. All rights reserved.
//

import UIKit

class NameTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var nameText: String?
    
    //make a func that updates nameText whenever name cell's nameTextField is edited
    //or set up an observer for the func in nametableviewcell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NameTableViewCell()
        return cell
    }
    
}
