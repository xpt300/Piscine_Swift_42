//
//  ThirdViewController.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/26/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

weak var ThirdViewControllerInstance = ThirdViewController()

class ThirdViewController: UIViewController, APIEvents, APIUser, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var API: APIController?
    var user: User?
    var events : Events?
    var allEvents : NSArray! = []
    var eventsChange : NSArray! = []
    var filtre : [String]! = []
    var cursus : [String]!
    var row : Int! = 0
    var eventsId : [(clef: Int, valeur : String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThirdViewControllerInstance = self
        API = APIController(delegate: ViewControllerInstance, delegateEvents: self)
        if let token : String = user?.token {
            self.API?.getEvents(token: token)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.eventsChange.count > 0) {
            return self.eventsChange.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "events") as! EventsTableViewCell
        cell.events = eventsChange[indexPath.row] as! NSDictionary
        return cell
    }
    
    func user(user: User) {
        print(user)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.filtre.count > 0) {
            return self.filtre.count
        } else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.filtre[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func events(events: Events) {
        if (events.allEvents.count > 0) {
            self.allEvents = events.allEvents
            self.eventsChange = events.allEvents
        }
        if (events.filtre.count > 0) {
            self.filtre = events.filtre
        }
        for (clef, value) in events.eventsId {
            for id in events.cursusId {
                if (id == clef) {
                    self.filtre.append(value)
                }
            }
        }
        for cur in events.cursus {
            self.filtre.append(cur)
        }
        self.filtre.append("ALL")
        self.filtre = Array(Set(self.filtre))
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.pickerView.reloadAllComponents()
        }
        self.eventsId = events.eventsId
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row = row
    }
    
    @IBAction func done(_ sender: Any) -> Void {
        print(self.filtre![self.row!])
        let searchText = self.filtre![self.row]
        if ("\(searchText)" == "ALL") {
            self.eventsChange = self.allEvents
            self.tableView.reloadData()
            return
        }
        var verif = false
        var id : Int! = nil
        for (key, value) in self.eventsId! {
            if (value == searchText) {
                verif = true
                id = key
            }
        }
        if (verif == true) {
            var newArray : [NSDictionary]! = []
            for value in self.allEvents.reversed() as! [NSDictionary] {
                if let add : NSArray = value["cursus_ids"] as? NSArray {
                    for lol in add {
                        if ("\(lol)" == "\(id!)") {
                            newArray.append(value)
                        }
                    }
                }
            }
            self.eventsChange = newArray! as NSArray
            self.tableView.reloadData()
            return
        } else {
            var newArray : [NSDictionary]! = []
            for value in self.allEvents.reversed() as! [NSDictionary] {
                print("\(value["kind"]), \(searchText)")
                if ("\(value["kind"]!)" == "\(searchText)") {
                    if (newArray == nil) {
                        newArray = [value]
                    } else {
                        newArray.append(value)
                    }
                } else if ("\(value["themes"]!)" == "\(searchText)") {
                    if (newArray == nil) {
                        newArray = [value]
                    } else {
                        newArray.append(value)
                    }
                }
            }
            self.eventsChange = newArray! as NSArray
            self.tableView.reloadData()
            return
        }

    }
    
}
