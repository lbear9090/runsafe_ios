//
//  AboutUsViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/9/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet var Logo_TO_TextBottom: NSLayoutConstraint!
    
    
    @IBOutlet var Term_top: NSLayoutConstraint!
    
    @IBOutlet var VersionLbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        let version:NSString=NSString(format: "v - %@",Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        VersionLbl.text=version as String
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        if (Constant.isiPhone_5==true)
        {
            Logo_TO_TextBottom.constant=50
            Term_top.constant=15
            
        }
        else if(Constant.isiPhone_6==true)
        {
            Logo_TO_TextBottom.constant=60
            Term_top.constant=25
        }
        else if(Constant.isiPhone_6_Plus==true)
        {
            Logo_TO_TextBottom.constant=75
            Term_top.constant=35
        }
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Terms_Condition_Click(sender: UIButton)
    {
        // Constant.FunctionalityAlert(self)
        
        if let TermsConditionUrl:NSURL = NSURL(string:"http://www.ceres8.com/terms-condition/")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(TermsConditionUrl as URL))
            {
                application.openURL(TermsConditionUrl as URL);
            }
            else
            {
                Constant.AlertViewNew(Title: "Runsafe", Message: "You Can't open this url please check your internet settings.", ViewController: self)
            }
        }
    }
    
    @IBAction func About_App_Click(sender: UIButton)
    {
        // Constant.FunctionalityAlert(self)
        
        if let PrivacyPolicyURL:NSURL = NSURL(string:"http://www.ceres8.com/privacy-policy/")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(PrivacyPolicyURL as URL))
            {
                application.openURL(PrivacyPolicyURL as URL);
            }
            else
            {
                Constant.AlertViewNew( Title: "Runsafe", Message: "You Can't open this url please check your internet settings.", ViewController: self)
            }
        }
        
        
    }
    
    @IBAction func Logo_Click(sender: UIButton)
    {
        
        if let WebSiteURL:NSURL = NSURL(string:"http://www.ceres8.com")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(WebSiteURL as URL))
            {
                application.openURL(WebSiteURL as URL);
            }
            else
            {
                Constant.AlertViewNew(Title: "Runsafe", Message: "You Can't open this url please check your internet settings.", ViewController: self)
            }
        }
    }
    
    
    @IBAction func Help_Click(sender: UIButton)
    {
        Constant.FunctionalityAlert(ViewController: self)
    }
  
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    @objc func CheckForNotification()
    {
       Constant.APPDELEGATE.ReceiveNotification=true
        
        let tabBarController = (UIApplication.shared.keyWindow!.rootViewController as! UITabBarController)
        
        tabBarController.selectedIndex = 0;
        
    }
    
}
