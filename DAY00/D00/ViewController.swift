//
//  ViewController.swift
//  D00
//
//  Created by Maxime JOUBERT on 1/15/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var operateur: String = "";
    var number1: Int! = nil;
    var number2: Int! = nil;
    
    @IBOutlet weak var Resultat: UILabel!
    
    func egal() {
        if (number2 != nil && operateur != ""){
            var resultat: Int? = nil;
            var bool: Bool = false
            switch operateur {
            case "+":
                resultat = number1! &+ number2!
            case "/":
                if(number1 == 0 || number2 == 0) {
                    number1 = nil
                    number2 = nil
                    Resultat.text = "Erreur"
                    operateur = ""
                    bool = true
                } else {
                    resultat = number1! / number2!
                }
            case "*":
                resultat = number1! &* number2!
            default:
                resultat = number1! &- number2!
            }
            if (bool == false) {
                number1 = resultat
                number2 = nil
                Resultat.text = String(resultat!)
            }
        }
    }
    
    @IBAction func buttonTapped(TheButton : UIButton){
        let trapped = TheButton.titleLabel!.text!
        print(trapped)
        let isNumberType = Int(trapped)
        if (isNumberType != nil) {
            if (number1 != nil && operateur != "") {
                if (number2 != nil) {
                    number2 =  (number2! &* 10) &+ isNumberType!
                } else {
                    number2 = isNumberType
                }
                Resultat.text = String(number2)
            } else {
                if (number1 != nil) {
                 number1 = (number1! &* 10) &+ isNumberType!
                } else {
                    number1 = isNumberType
                }
                Resultat.text = String(number1)
            }
        } else {
            switch trapped {
            case "NEG":
                if (number2 != nil) {
                    number2 = number2! &* -1
                    Resultat.text = String(number2!)
                } else if (number1 != nil){
                    number1 = number1! &* -1
                    Resultat.text = String(number1!)
                }
            case "AC":
                number1 = nil
                number2 = nil
                operateur = ""
                Resultat.text = "0"
            case "=":
                egal()
            default:
                if (operateur != "") {
                    egal()
                }
                operateur = trapped
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

}

