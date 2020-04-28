//
//  deathNoteTableViewCell.swift
//  D02
//
//  Created by Maxime JOUBERT on 1/17/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class deathNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var deathNote : (String, String, String)? {
        didSet {
            if let note = deathNote {
                nameLabel?.text = note.0
                descriptionLabel?.text = note.1
                dateLabel?.text = note.2
            }
        }
    }
    
}
