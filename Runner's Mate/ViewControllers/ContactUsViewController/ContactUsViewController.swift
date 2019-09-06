//
//  ContactUsViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/9/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ContactUsViewController: UIViewController,MFMailComposeViewControllerDelegate {

    
    @IBOutlet var TapButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        TapButton.layer.cornerRadius=5
        TapButton.layer.masksToBounds=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //MARK:- ViewWill Disappear
    override func viewWillDisappear( _ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
//        NotificationCenter.defaultCenter.removeObserver(self, name: "CheckForNotification", object: nil)
    }
    
    @IBAction func FeedBackClick(sender: UIButton)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            mailer.setToRecipients(["info@ceres8.com"])
            mailer.setSubject("Feedback")
            self.present(mailer, animated: true, completion: {})
//            self.presentViewController(mailer, animated: true, completion: { _ in })
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Configure Your Mail Account In Device Settings", ViewController: self)
        }

    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func CheckForNotification()
    {
        Constant.APPDELEGATE.ReceiveNotification=true
        
        let tabBarController = (UIApplication.shared.keyWindow!.rootViewController as! UITabBarController)
        
        tabBarController.selectedIndex = 0;
        
        
    }
}
