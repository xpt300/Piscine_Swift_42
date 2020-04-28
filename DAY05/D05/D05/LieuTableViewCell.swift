//
//  LieuTableViewCell.swift
//  D05
//
//  Created by Maxime JOUBERT on 1/24/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class LieuTableViewCell: UITableViewCell {

    @IBOutlet weak var lieuLabel: UILabel!
    
    var listData: (String, Double, Double, String, String)? {
        didSet {
            if let lieu = listData {
                lieuLabel.text = lieu.0
            }
        }
    }
}
