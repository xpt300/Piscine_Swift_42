//
//  ViewController.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/25/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

weak var ViewControllerInstance = ViewController()

class ViewController: UIViewController, APIUser {
    
    var API : APIController!
    var userApi : User?
    
    @IBOutlet weak var connexionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API = APIController(delegate: self, delegateEvents: ThirdViewController())
        connexionButton.isEnabled = false
        ViewControllerInstance = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Alert", message: "Vous allez etre redirigé sur l'API de 42", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            switch action.style{
            case .default:
                self.API.getToken()
                self.API.authentification()
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default:
                print("fatal error")
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func user(user: User) {
        self.userApi = user
        print(user)
        DispatchQueue.main.async {
            self.connexionButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "connexion") {
            let dvc = segue.destination as! UINavigationController
            let tableVC = dvc.viewControllers.first as! SecondViewController
            tableVC.user = self.userApi
        }
    }
    
    @IBAction func connexion(_ sender: Any) {
        self.performSegue(withIdentifier: "connexion", sender: "coucou")
    }
    
}

