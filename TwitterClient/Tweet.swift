//
//  Tweet.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetId: String?
    var retweeted: Bool?
    var favorited: Bool?
    var user:User?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        tweetId = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
        
        }
    }
    
    class func tweetsArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweetDict = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweetDict.append(tweet)
        }
        return tweetDict
    }
    
}
