//
//  MainTweetsController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class MainTweetsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPIClient.sharedInstance?.logout()
    }
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertTweet(_notification: NSNotification){
        print(_notification.userInfo?["tweetResponse"])
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
