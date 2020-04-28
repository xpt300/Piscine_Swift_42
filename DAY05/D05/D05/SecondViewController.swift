//
//  SecondViewController.swift
//  D05
//
//  Created by Maxime JOUBERT on 1/24/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.lieu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listeCell") as! LieuTableViewCell
        cell.listData = Data.lieu[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "returnMap") {
            let map = segue.destination as! FirstViewController
            var number : Int = sender as! Int
            map.currentLatitude = Data.lieu[number].1
            map.currentLongitude = Data.lieu[number].2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "returnMap", sender: indexPath.row)
    }
}

