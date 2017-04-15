//
//  MainTweetsController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/15/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class MainTweetsController: UIViewController {
    
    
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterAPIClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
        self.tweets = tweets
        print("Im IN Main Page")
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
