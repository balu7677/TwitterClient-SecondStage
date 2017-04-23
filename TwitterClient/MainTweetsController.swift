//
//  MainTweetsController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class MainTweetsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CustomCellDelegate {
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPIClient.sharedInstance?.logout()
    }
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
    var profileViewNumber:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 200
        TwitterAPIClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
        self.tweets = tweets
        print(self.tweets.count)
        self.tweetsTableView.reloadData()
        print("Im IN Main Page")
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.insertTweet(_notification:)), name: NSNotification.Name(rawValue: "UserTweeted"), object: nil)
        // Do any additional setup after loading the view.
//        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
//        tap.delegate = self
//        tap.numberOfTapsRequired = 1
//        tap.numberOfTouchesRequired = 1
//        self.tweetsTableView.addGestureRecognizer(tap)
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
            self.tweetsTableView.beginUpdates()
            self.tweetsTableView.insertRows(at: [IndexPath(row: 0, section : 0)], with: .automatic)
            self.tweetsTableView.endUpdates()
            self.tweetsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.tweet = tweets[indexPath.row]
        cell.rowNum = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func refreshControlAction(_refreshControl:UIRefreshControl){
        TwitterAPIClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            _refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
//    func onTap(_ sender: UITapGestureRecognizer) {
//        if sender.state == UIGestureRecognizerState.ended {
//            var tableView = sender.view as! UITableView
//            var point = sender.location(in: tableView)
//            var indexPath = tableView.indexPathForRow(at: point)
//            var cell = tableView.cellForRow(at: indexPath!) as! CustomCell
//            
//            // get associated tweet
//            var thisTweet = self.tweets[indexPath!.row]
//            var pointInCell = sender.location(in: cell)
//            if(cell.profileImage.frame).contains(pointInCell){
//            self.performSegue(withIdentifier: "tapImageProfileTimeline", sender: cell.profileImage)
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tapImageProfileTimeline"{
            let profilenavigationController = segue.destination as! UINavigationController
            let profileViewController = profilenavigationController.topViewController as! ProfileViewController
            profileViewController.userTweet = self.tweets[profileViewNumber]
        }
        
        if sender is UITableViewCell{
            let cell = sender! as! UITableViewCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
        
            let detailViewController = segue.destination as! DetailTweetViewController
            detailViewController.tweet = tweet
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tweetsTableView.indexPathForSelectedRow{
            self.tweetsTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func CustomCellDelegate(number: Int) {
        self.profileViewNumber = number
        self.performSegue(withIdentifier: "tapImageProfileTimeline", sender:nil)
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
