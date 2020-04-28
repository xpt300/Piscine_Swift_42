//
//  APIController.swift
//  RUSH00
//
//  Created by Maxime JOUBERT on 1/25/20.
//  Copyright © 2020 Maxime JOUBERT. All rights reserved.
//

import UIKit

class APIController {
    
    var UID: String = "6fa921ffe836b95b90e681605c3b61cfb66f2c0da15825a071505feb54c12106"
    var SECRET: String = "ca4aff1100e706e132efd81393c3b415ac4c04c95b8b8dcde9b7a82349011c73"
    var ACCESTOKEN : String!
    var delegate: APIUser?
    var userApi: User?
    var delegateEvents : APIEvents?
    var eventsApi: Events?

    init (delegate: APIUser?, delegateEvents: APIEvents?) {
        self.delegate = delegate
        self.delegateEvents = delegateEvents
    }
    
    func authentification() {
        let redirectUri = "RUSH00://RUSH00".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(UID)&redirect_uri=\(redirectUri!)&response_type=code&scope=public+profile+projects&state=mjoubert"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("url error")
        }
    }
    
    func getToken() {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let token = dic["access_token"] {
                            self.ACCESTOKEN  = (token as! String)
                            print("App token : \(self.ACCESTOKEN!)")
                        }
                    }
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func getAuthorization(code: String) {
        let url = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=authorization_code&client_id=\(UID)&client_secret=\(SECRET)&code=\(code)&redirect_uri=RUSH00://RUSH00")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                        if let token = dic["access_token"] as? String {
                            self.user(code: code,token: token)
                        }
                        
                    }
                } catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func user(code: String, token: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        let cursus : NSArray = dic["cursus_users"] as! NSArray
                        var array : [(cursus: NSDictionary, level: Double)]!
                        for cur in cursus {
                            let user : NSDictionary = cur as! NSDictionary
                            if array != nil {
                                array.append((cursus: user["cursus"] as! NSDictionary, level: user["level"] as! Double))
                            } else {
                                array = [(cursus: user["cursus"] as! NSDictionary, level: user["level"] as! Double)]
                            }
                        }
                        let nom = dic["displayname"] as! String
                        if let log = dic["login"] as? String {
                            let img_url = dic["image_url"] as! String
                            let id = dic["id"] as! Int
                            self.userApi = User(displayName: nom, login: log, photo: img_url, id: id, code: code, token: token, cursus: array)
                        }
                    }
                    if let testDelegate: APIUser = self.delegate {
                        testDelegate.user(user: self.userApi!)
                    }
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func deconnexion() {
        self.userApi = nil
    }

    func getEvents(token: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/events")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        print(dic)
                        var kind : [String]!
                        var themes : [String]!
                        var id : [Int]!
                        for test in dic {
                            let dictionary : NSDictionary = test as! NSDictionary
                            if let add : String = dictionary["kind"] as? String {
                                if kind == nil {
                                    kind = [add]
                                } else {
                                    kind.append(add)
                                }
                            }
                        }
                        for search in dic {
                            let theme : NSDictionary = search as! NSDictionary
                            if let add : NSArray = theme["themes"] as? NSArray {
                                if (add.count > 0) {
                                    if let name : NSDictionary = add[0] as? NSDictionary {
                                        if themes == nil {
                                            themes = [name["name"]!] as? [String]
                                        } else {
                                            themes.append(name["name"]! as! String)
                                        }
                                    }
                                }
                            }
                        }
                        for idevent in dic {
                            let search : NSDictionary = idevent as! NSDictionary
                            if let trouve : NSArray = search["cursus_ids"]! as? NSArray {
                                if (trouve.count > 0) {
                                    if (id == nil) {
                                        id = [trouve[0]] as? [Int]
                                    } else {
                                        id.append(trouve[0] as! Int)
                                    }
                                }
                            }
                        }
                        let kindArray = Array(Set(kind))
                        let themesArray = Array(Set(themes))
                        let idArray = Array(Set(id))
                        self.eventsApi = Events(allEvents: dic, filtre: themesArray + kindArray, cursus: kind, cursusId: idArray, eventsId : nil)
                        var envetsId = self.eventsId(token: token)
                    }
                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
    
    func eventsId(token : String) {
        let url = URL(string: "https://api.intra.42.fr/v2/cursus")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        var array : [(clef: Int, valeur: String)]?
                        for events in dic {
                            let search : NSDictionary = events as! NSDictionary
                            if (array == nil) {
                                array = [(clef: search["id"], valeur: search["name"])] as! [(clef: Int, valeur: String)]
                            } else {
                                array?.append((clef: search["id"], valeur: search["name"]) as! (clef: Int, valeur: String))
                            }
                        }
                        self.eventsApi?.eventsId = array
                        if let testDelegate: APIEvents = self.delegateEvents {
                            testDelegate.events(events: self.eventsApi!)
                        }
                    }

                } catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
}
