//
//  SkillsTableViewCell.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/26/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var localisationLabel: UILabel!
    
    @IBOutlet weak var descriptioLabel: UILabel!
    
    @IBOutlet weak var inscrit: UILabel!
    
    @IBOutlet weak var maxInscrit: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var fin: UILabel!
    
    @IBOutlet weak var debut: UILabel!
    
    var events : NSDictionary? {
        didSet {
            if let user = events {
                nameLabel.text = "\(user["name"]!)"
                localisationLabel.text = "\(user["location"]!)"
                descriptioLabel.text = "\(user["description"]!)"
                inscrit.text = "\(user["nbr_subscribers"]!)"
                maxInscrit.text = "\(user["max_people"]!)"
                type.text = "\(user["kind"]!)"
                debut.text = "\(user["begin_at"]!)"
                fin.text = "\(user["end_at"]!)"
            }
        }
    }
}
