//
//  ViewController.swift
//  D07
//
//  Created by Maxime JOUBERT on 1/30/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit
import DarkSkyKit
import RecastAI

class ViewController: UIViewController {
    
    let forecastClient = DarkSkyKit(apiToken: "941ae94104e91e502c1a58efc4177baa")
    
    var bot : RecastAIClient?

    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var getText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bot = RecastAIClient(token : "46679084ad498e0988b71041b09929cb", language: "en")
    }
    
    @IBAction func getRecast(_ sender: Any) {
        makeRequest(text: getText.text!)
    }
    
    func makeRequest(text : String) {
        if (text != "") {
            print("hihih")
            self.bot?.textRequest(text, successHandler: recastRequestDone(_:), failureHandle: recastRequestError(_:))
        } else {
            DispatchQueue.main.async {
                self.responseLabel.text = "Error"
            }
        }
    }
    
    func recastRequestDone(_ response : Response) {
        let location = response.get(entity: "location")
        if let loc = location {
            var lng : Double!
            var lat : Double!
            if let doubleValue = loc["lng"] as? Double {
                lng = doubleValue
            }
            if let doubleValue = loc["lat"] as? Double {
                lat = doubleValue
            }
            darkSky(lat: lat!, lng: lng!)
        } else {
            DispatchQueue.main.async {
                self.responseLabel.text = "Pas de coordonnees"
            }
        }
    }
    
    func darkSky(lat : Double!, lng : Double!) {
        forecastClient.current(latitude: lat, longitude: lng) { result in
            switch result {
            case .success(let value) :
                if let icon = value.currently?.icon {
                    DispatchQueue.main.async {
                        self.responseLabel.text = icon
                    }
                }
            case .failure(let err) :
                print("error darksky", err)
            }

        }
    }
    
    func recastRequestError(_ error : Error) {
        print(error)
    }

}

