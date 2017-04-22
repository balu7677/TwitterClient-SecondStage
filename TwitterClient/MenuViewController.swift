//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/21/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var profileViewController: UIViewController! = nil
    private var mentionsViewController: UIViewController! = nil
    private var homeViewController: UIViewController! = nil
    
    var hamburgerViewController: HamburgerViewController!
    var titles = ["Home","Profile","Mentions"]
    var viewcontrollers=[UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = storyBoard.instantiateViewController(withIdentifier: "MainTweetsNavigationController")
        profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsViewController = storyBoard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewcontrollers.append(homeViewController)
        viewcontrollers.append(profileViewController)
        viewcontrollers.append(mentionsViewController)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuViewCustomCell", for: indexPath) as! MenuViewCustomCell
        
        cell.menuItemLabel.text = titles[indexPath.row] 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //self.tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewcontrollers[indexPath.row]
        print("\(indexPath.row)******\(indexPath.section)")
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
