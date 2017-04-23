//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/21/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var totalTweetCount: UILabel!
    @IBOutlet weak var totalFollowing: UILabel!
    @IBOutlet weak var totalFollowers: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var userTweet: Tweet!
     var tweets: [Tweet]!
    var userNameinProfile: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        if userTweet != nil {
           userNameinProfile = (userTweet.user?.userName)!
        } else {
           userNameinProfile = (User.currentUser?.userName)!
        }
        TwitterAPIClient.sharedInstance?.userHomeTimeLine(userNameinUrl: userNameinProfile,success: { (tweets: [Tweet]) in
            self.tweets = tweets
            print(self.tweets.count)
            self.tableView.reloadData()
            print("Im IN Main Page")
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.insertTweet(_notification:)), name: NSNotification.Name(rawValue: "UserTweeted"), object: nil)
        if userTweet != nil {
        userName.text = (userTweet.user?.name)
        screenName.text = "@"+(userTweet.user?.userName)!
       // userStatus.text = userTweet.user?.userDescription
        backgroundImage.setImageWith((userTweet.user?.backGroundImage)!)
        profileImage.setImageWith((userTweet.user?.profileUrl)!)
        totalFollowers.text = "\((userTweet.user?.followersCount)!)"
        totalTweetCount.text = "\((userTweet.user?.tweetsCount)!)"
        totalFollowing.text = "\((userTweet.user?.followingCount)!)"
        } else {
            userName.text = (User.currentUser?.name)
            screenName.text = "@"+(User.currentUser?.userName)!
          //  userStatus.text = User.currentUser?.userDescription
            backgroundImage.setImageWith((User.currentUser?.backGroundImage)!)
            profileImage.setImageWith((User.currentUser?.profileUrl)!)
            totalFollowers.text = "\((User.currentUser?.followersCount)!)"
            totalTweetCount.text = "\((User.currentUser?.tweetsCount)!)"
            totalFollowing.text = "\((User.currentUser?.followingCount)!)"
        }
        self.profileImage.layer.cornerRadius = 5.0
        self.profileImage.layer.masksToBounds = true
        headerView.layer.borderWidth = 0.3
     //   headerView.layer.borderColor = UIColor.black as! CGColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertTweet(_notification: NSNotification){
        //print(_notification.userInfo?["tweetResponse"])
        if let insertTweetinTable = _notification.userInfo?["tweetResponse"] as? NSDictionary
        {
            self.tweets.insert(Tweet(dictionary: insertTweetinTable), at: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section : 0)], with: .automatic)
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func refreshControlAction(_refreshControl:UIRefreshControl){
        TwitterAPIClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            _refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileHomeBtnToHamB"{
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let hamburgerNaviController = segue.destination as! UINavigationController
//            let hamburgerViewController = hamburgerNaviController.topViewController as! HamburgerViewController
//            let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//            menuViewController.hamburgerViewController = hamburgerViewController
//            hamburgerViewController.menuViewController = menuViewController
        }
        if sender is UITableViewCell{
            let cell = sender! as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailTweetViewController
            detailViewController.tweet = tweet
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
