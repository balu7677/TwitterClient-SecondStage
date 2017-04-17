//
//  TwitterAPIClient.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPIClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginfailure: ((Error)->())?
    
    static let sharedInstance = TwitterAPIClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "eGkOc1VDr8bvSBJIf87Q9N3tW", consumerSecret: "5jCTWaL7BJEgU0xmSieXNm4kR4qP2GRX5QO4f9GmwMrkHzyg5j")
    
    func homeTimeline(success: @escaping (([Tweet]) -> ()), failure:@escaping ((Error) -> ())){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            for dict in dictionaries {
                print(dict)
                print("**********")
            }
            let tweets = Tweet.tweetsArray(dictionaries: response as! [NSDictionary])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func verifyCredentials(success:@escaping ((User)->()), failure:@escaping ((Error)->())){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dict = response as? NSDictionary
            let user = User(dictionary: dict!)
            print(user.name!)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        })

    }
    
    func postTweet(status: NSDictionary, success:@escaping ((Any?)->()), failure:@escaping ((Error)->())){
        post("https://api.twitter.com/1.1/statuses/update.json", parameters: status, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print(error.localizedDescription)
        })
    }
    
    func retweet(id: String, success:@escaping (()->()), failure: @escaping ((Error)->())){
        let postUrl = "https://api.twitter.com/1.1/statuses/retweet/\(id).json"
        post(postUrl, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print(error.localizedDescription)
        })
    }
    
    func favorite(id: String, success:@escaping (()->()), failure: @escaping ((Error)->())){
        let postUrl = "https://api.twitter.com/1.1/favorites/create.json?id=\(id)"
        post(postUrl, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print(error.localizedDescription)
        })
    }

    
    func login (success:@escaping (()->()), failure:@escaping ((Error)->())) {
        
        self.loginSuccess = success
        self.loginfailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "TwitterClient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token")
            let token = (requestToken?.token)!
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(token)"
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, completionHandler: { (bool: Bool) in
                print(bool)
            })
            
        }, failure: { (error: Error?) in
            print("Error")
            self.loginfailure!(error!)
        })
    }
    
    func handleOpenUrl(url: URL){
        let request = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: request, success: { (accessToken: BDBOAuth1Credential?) in
            self.verifyCredentials(success: { (user: User) in
                self.loginSuccess?()
                User.currentUser = user
            }, failure: { (error:Error) in
                self.loginfailure!(error)
            })
            
            print("Got the token : \(accessToken?.token)")
            
        }, failure: { (error: Error?) in
            print(error?.localizedDescription)
            self.loginfailure!(error!)
        })
    }
    
    func logout(){
        deauthorize()
        User.currentUser = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
    }

}
