//
//  User.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var userName: String?
    var profileUrl: URL?
    var userDescription: String?
    var userDictionary: NSDictionary?
    init(dictionary: NSDictionary) {
        self.userDictionary = dictionary
        name = dictionary["name"] as? String
        userName = dictionary["screen_name"] as? String
        userDescription = dictionary["description"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileString = profileUrlString {
            profileUrl = URL(string: profileString)
        }
        
    }
    
    static var _currentUser : User?
    class var currentUser: User? {
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            } else {
                print("Hi")
            }
            return _currentUser
        }
        set(user){
            
        _currentUser = user
        let defaults = UserDefaults.standard
            if let user = user {
                
                let data = try! JSONSerialization.data(withJSONObject: user.userDictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                //defaults.set(nil, forKey: "currentUserData")
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
            
            }
        }
    }

