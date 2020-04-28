//
//  ViewController.swift
//  D02
//
//  Created by Maxime JOUBERT on 1/17/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue) {
        print(segue.identifier!)
        table.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.deathNote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deathNote") as! deathNoteTableViewCell
        cell.deathNote = Data.deathNote[indexPath.row]
        return cell
    }
}

