//
//  SkillsTableViewCell.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/26/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cursusLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    var cursus : (cursus: NSDictionary, level: Double)? {
        didSet {
            if let user = cursus {
                cursusLabel.text = "\(user.cursus["name"]!)"
                levelLabel.text = "\(user.level)"
            }
        }
    }
}
