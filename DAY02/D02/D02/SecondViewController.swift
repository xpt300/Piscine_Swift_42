//
//  SecondViewController.swift
//  D02
//
//  Created by Maxime JOUBERT on 1/17/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        descriptionLabel.layer.borderWidth = 1.0
        super.viewDidLoad()
        nameLabel.delegate = self
        let currentDate = NSDate()  //get the current date
        datePicker.minimumDate = currentDate as Date  //set the current date/time as a minimum
        datePicker.date = currentDate as Date //defaults to current time but shows how to use it.
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor.lightGray
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" && nameLabel.textColor != UIColor.lightGray && nameLabel.text != "" {
            if let vc = segue.destination as? ViewController {
                let time = convertDateFormater(date: datePicker!.date)
                let order = Calendar.current.compare(NSDate() as Date, to: datePicker!.date, toGranularity: .minute)
                switch order {
                case .orderedDescending:
                    print("False")
                case .orderedAscending:
                    Data.deathNote.append((nameLabel.text!, descriptionLabel.text!, time))
                case .orderedSame:
                    Data.deathNote.append((nameLabel.text!, descriptionLabel.text!, time))
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "Name"
            textField.textColor = UIColor.lightGray
        }
    }
    
    func convertDateFormater(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "CET") as TimeZone?
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "CET") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    @IBAction func doneButton(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: "Done")
    }
}
