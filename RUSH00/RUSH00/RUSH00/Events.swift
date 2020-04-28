//
//  Events.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/27/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

struct Events : CustomStringConvertible {
    
    var allEvents : NSArray!
    var filtre : [String]!
    var cursus : [String]!
    var cursusId : [Int]!
    var eventsId : [(clef: Int, valeur: String)]!
    
    var description: String {
        return "Events"
    }
}
