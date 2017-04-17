//
//  DetailTweetViewController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/16/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {
    
    
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
        }, failure: { (error: Error) in
            print("Failed retweet: \(error.localizedDescription)")
        })
    }
    
    @IBAction func onTapRetweet(_ sender: Any) {
        let strId = tweet?.tweetId
        TwitterAPIClient.sharedInstance?.retweet(id: strId!, success: {
            print("Success Retweeted")
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
