//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Tummala, Balaji on 4/21/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLeftMargin: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet{
            self.view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldViewController){
            if(oldViewController != nil){
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.didMove(toParentViewController: nil)
            }
            self.view.layoutIfNeeded()
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            UIView.animate(withDuration: 0.3) { 
                self.contentLeftMargin.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Hamburger")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.hamburgerViewController = self
        self.menuViewController = menuViewController

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
           originalLeftMargin = contentLeftMargin.constant
            
        } else if sender.state == UIGestureRecognizerState.changed {
            if(translation.x <= self.view.frame.size.width - 130){
                contentLeftMargin.constant = translation.x + originalLeftMargin
            } else {
                contentLeftMargin.constant = self.view.frame.size.width - 130
            }
        } else if sender.state == UIGestureRecognizerState.ended{
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0{
                    self.contentLeftMargin.constant = self.view.frame.size.width - 130
                } else {
                    self.contentLeftMargin.constant = 0
                }
            })
            self.view.layoutIfNeeded()
            
            
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
