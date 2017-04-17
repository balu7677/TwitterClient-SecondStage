//
//  SelectTweetController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class SelectTweetController: UIViewController, UITextViewDelegate {

 
    @IBOutlet weak var remainingCharLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    var replytoMessageId: String?
    var replytoScreenName: String?
    let Max_Characters = 140
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = User.currentUser?.name
        self.screenName.text = "@"+(User.currentUser?.userName)!
        self.imageProfile.setImageWith((User.currentUser?.profileUrl)!)
        self.imageProfile.layer.cornerRadius = 5.0
        self.imageProfile.layer.masksToBounds = true
        self.tweetText.becomeFirstResponder()
        if let replytoMessageId1 = replytoMessageId{
            if let replyName = replytoScreenName{
                self.tweetText.text = "@"+replyName
            }
        }
        self.remainingCharLabel.text = "\(Max_Characters)"
        tweetText.delegate = self
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var length = self.tweetText.text.characters.count
        var remainCount = self.Max_Characters - length
        var redux = self.tweetText.text
        self.remainingCharLabel.text = "\(remainCount)"
        if(length > (self.Max_Characters-1)) {
            let index = redux?.index((redux?.startIndex)!, offsetBy: 139)
            tweetText.text = tweetText.text?.substring(to: index!)
        }
    }
    
    @IBAction func onPostTweet(_ sender: Any) {
        let tweet = tweetText.text
        if tweet?.characters.count == 0 {
            return
        } else {
            if let replytoMessageId = replytoMessageId {
                print("Reply")
                var tweetDict: NSDictionary = ["status":tweet,"in_reply_to_status_id":replytoMessageId]
                
                TwitterAPIClient.sharedInstance?.postTweet(status: tweetDict, success: { (response: Any?) in
                    print("Success Posting a reply")
                    var tweetResponse : NSDictionary = ["tweetResponse": response as? NSDictionary]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserTweeted"), object: nil, userInfo: tweetResponse as! [AnyHashable : Any])
                    self.onCancel(Any)
                }, failure: { (error: Error) in
                    print("Failed posting a reply \(error.localizedDescription)")
                })
            } else {
                print("Posting")
                let tweetDict: NSDictionary = ["status":tweet]
                TwitterAPIClient.sharedInstance?.postTweet(status: tweetDict, success: { (response: Any?) in
                    print("Success Posting")
                    var tweetResponse : NSDictionary = ["tweetResponse": response as? NSDictionary]
                   // let tweetUserinfo: NSDictionary = ["tweetInfo":tweetDict]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserTweeted"), object: nil, userInfo: tweetResponse as! [AnyHashable : Any])
                    self.onCancel(Any)
                }, failure: { (error: Error) in
                    print("Failed posting a tweet \(error.localizedDescription)")
                })
            }
        }
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
