//
//  User.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/25/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

struct User : CustomStringConvertible {
    var displayName: String!
    var login : String!
    var photo : String!
    var id : Int! = nil
    var code: String!
    var token : String!
    var cursus : [(cursus: NSDictionary, level: Double)]?
    
    var description: String {
        return "\(displayName!), \(login!)"
    }
}
