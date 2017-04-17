//
//  DetailTweetViewController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/16/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsConstant: UILabel!
    @IBOutlet weak var favoritesConstant: UILabel!
    var tweet:Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        print((tweet?.favoritesCount)!)
        self.retweetsLabel.text = "\((tweet?.retweetCount)!)"
        self.favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        self.imageProfile.setImageWith((self.tweet?.user?.profileUrl)!)
        self.imageProfile.layer.cornerRadius = 5.0
        self.imageProfile.layer.masksToBounds = true
        self.tweetText.text = tweet?.text
        self.screenName.text = "@"+(tweet!.user?.userName)!
        self.nameLabel.text = tweet!.user?.name
        
        var formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        self.dateLabel.text = formatter.string(from: (self.tweet?.timestamp)!)
        if(tweet?.retweeted)!{
           self.retweetButton.setImage(UIImage(named: "retweet-action-on"), for: UIControlState.normal)
        }
        if(tweet?.favorited)!{
            self.likeButton.setImage(UIImage(named: "like-action-on"), for: UIControlState.normal)
        }
//        
//        TwitterAPIClient.sharedInstance?.myRetweets(tweetId: (tweet?.tweetId)!, success: { (response: Any?) in
//            let retweetDict = response as? [NSDictionary]
//            for dict in retweetDict! {
//                if let retweetId = dict["id_str"] as? String {
//                    if(retweetId == self.tweet?.tweetId){
//                        self.retweetButton.setImage(UIImage(named: "retweet-action-on"), for: UIControlState.normal)
//                    }
//                }
//            }
//            
//        }, failure: {
//            print("Not retweeted by me")
//        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        let strId = tweet?.tweetId
        TwitterAPIClient.sharedInstance?.favorite(id: strId!, success: {
            print("Success Liked")
           self.likeButton.setImage(UIImage(named: "like-action-on"), for: UIControlState.normal)
            if(!((self.tweet?.favorited)!)){
            let count = (self.tweet?.favoritesCount)! + 1
                self.favoritesLabel.text = "\(count)" }
        }, failure: { (error: Error) in
            print("Failed retweet: \(error.localizedDescription)")
        })
    }
    
    @IBAction func onTapRetweet(_ sender: Any) {
        let strId = tweet?.tweetId
        TwitterAPIClient.sharedInstance?.retweet(id: strId!, success: {
            print("Success Retweeted")
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), for: UIControlState.normal)
            if(!((self.tweet?.retweeted)!)){
                let count = (self.tweet?.retweetCount)! + 1
                self.retweetsLabel.text = "\(count)" }
            TwitterAPIClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            }, failure: { (error: Error) in
            })
        }, failure: { (error: Error) in
            print("Failed retweet: \(error.localizedDescription)")
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let selectTweetController = navigationController.topViewController as! SelectTweetController
        selectTweetController.replytoMessageId = tweet?.tweetId
        selectTweetController.replytoScreenName = tweet?.user?.userName
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
}
