//
//  SecondViewController.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/25/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var API : APIController?
    var connexion: String = ""
    var user:  User?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user : User = user {
            if let image : String = user.photo {
                let url = URL(string: image)
                let data = try? Data(contentsOf: url!)
                imageView.image = UIImage(data: data!)
            }
            if let name : String = user.displayName {
                nameLabel.text = name
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user?.cursus!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skills") as! SkillsTableViewCell
        cell.cursus = user?.cursus![indexPath.row]
        return cell
    }
    
    
    @IBAction func deconnexion(_ sender: Any) {
        self.deconnexionSegue()
    }
    
    func deconnexionSegue() {
        self.API?.deconnexion()
        performSegue(withIdentifier: "deconnexion", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "events") {
            let dvc = segue.destination as! ThirdViewController
            dvc.user = self.user
        }
    }
}
