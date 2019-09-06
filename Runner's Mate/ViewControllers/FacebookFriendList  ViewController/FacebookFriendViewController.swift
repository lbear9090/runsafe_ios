//
//  FacebookFriendViewController.swift
//  Ceres8
//
//  Created by Lucky on 7/27/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Accounts
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Bolts

class FacebookFriendViewController: UIViewController,UITableViewDelegate
{
    
    @IBOutlet var FBListTable: UITableView!
    
    var Cell:FacebookFriendCell!
    
    var FriendArray:NSMutableArray=NSMutableArray()
    
    var SelectedFriend:NSMutableArray=NSMutableArray()
    
    var selectedIndex:NSMutableArray=NSMutableArray()
    
    
      override func viewDidLoad()
    {
        super.viewDidLoad()
      
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if  (FBSDKAccessToken .current() != nil)
        {
            let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "friends.limit(1000){id,name,picture}"], httpMethod: "GET")
            
            request.start(completionHandler: { (connection:FBSDKGraphRequestConnection?, Friendresult:AnyObject!, error:NSError?) in
                if error != nil
                {
                    
                    print(error?.localizedDescription as Any)

                    Constant.AlertViewNew(Title: "Runsafe", Message: "You can not able to access your Facebook Friends", ViewController: self)
                    
                    Constant.APPDELEGATE.hideLoadingHUD()
                    
                }
                else
                {
                    let ResultDic:NSDictionary = Friendresult as! NSDictionary
                    
                    print(ResultDic)
                    print(Friendresult)
                    
                    self.FriendArray=((ResultDic.object(forKey: "friends") as AnyObject).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    Constant.APPDELEGATE.hideLoadingHUD()
                    
                    self.FBListTable.reloadData()
                }
                } as! FBSDKGraphRequestHandler)
        }
        else
        {
            Constant.APPDELEGATE.FacebookLoginManager!.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) in
                if (error != nil)
                {
                    print(error?.localizedDescription as Any)

                    NSLog("%@", "There is an error")
                }
                else if result.isCancelled
                {
                    NSLog("%@", "Login cancelled")
                    
                    let AlertView = UIAlertController(title:"Login Cancelled", message:"You have cancelled Login", preferredStyle: .alert)
                    
                    let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        AlertView.dismiss(animated: true, completion: nil)
                        self.Cancel_Click(sender: self.navigationItem.leftBarButtonItem!)
                    })
                    
                    AlertView.addAction(Ok)
                    
                    self.present(AlertView, animated: true, completion: nil)
                    
                }
                else
                {
                    
                    let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "friends.limit(1000){id,name,picture}"], httpMethod: "GET")
                    
                    request.start(completionHandler: { (connection:FBSDKGraphRequestConnection?, Friendresult:AnyObject!, error:NSError?) in
                        if error != nil
                        {
                            
                            print(error?.localizedDescription as Any)
                            
                            Constant.AlertViewNew(Title: "Runsafe", Message: "You can not able to access your Facebook Friends", ViewController: self)
                            
                            Constant.APPDELEGATE.hideLoadingHUD()
                            
                        }
                        else
                        {
                            let ResultDic:NSDictionary = Friendresult as! NSDictionary
                            
                            
                            print("Friend Result::")
                            
                            print(Friendresult)
                             print(ResultDic)
                            self.FriendArray=((ResultDic.object(forKey: "friends") as AnyObject).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                            
                      
                            Constant.APPDELEGATE.hideLoadingHUD()
                            
                            self.FBListTable.reloadData()
                        }
                        } as! FBSDKGraphRequestHandler)
                    
                }
                } as! FBSDKLoginManagerRequestTokenHandler)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
        UIApplication.shared .setStatusBarHidden(false, with: .slide)
    }
    
    
    
    @objc func CheckForNotification()
    {
        
        Constant.APPDELEGATE.ReceiveNotification=true

        let tabBarController = (UIApplication.shared.keyWindow!.rootViewController as! UITabBarController)
        
        tabBarController.selectedIndex = 0;
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
        UIApplication .shared .setStatusBarHidden(true, with: .slide)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Cancel Click
    @IBAction func Cancel_Click(sender: UIBarButtonItem)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
        UIApplication .shared .setStatusBarHidden(true, with: .slide)
    
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Share Message Click
    @IBAction func SendClick(sender: UIBarButtonItem)
    {
        if SelectedFriend.count>0
        {
            
            let FinalPeopleIDArray:NSMutableArray=NSMutableArray()
            
            for i in 0 ..< SelectedFriend.count
            {
                FinalPeopleIDArray.add((SelectedFriend.object(at: i) as AnyObject).value(forKey: "id")!)
            }
            
            
            print(SelectedFriend)
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentTitle = "Runsafe Runner’s mate"
            
          
            if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) != nil
            {
                print("messageFromUserdefault== \(String(describing: Constant.USERDEFAULT.value(forKey: "CustomMessage"))) ")
                
                content.contentDescription  = Constant.USERDEFAULT.value(forKey: "CustomMessage") as? String
            }
            else
            {
                content.contentDescription = "I am out for run/walk, not feeling safe. I need you on the phone/help"
            }

            
            
          //  content.contentDescription = "I am in danger please find me and save me."
            
            content.contentURL = NSURL(string: String(format:"http://www.ceres8.com/"))! as URL!
            
            content.peopleIDs = FinalPeopleIDArray as [AnyObject]
            
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please Select friend which you want to share!", ViewController: self)
        }
        
    }
    
    //MARK:- Random Color
    
    func getRandomColor() -> UIColor
    {
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    //MARK:- TableView Delegate
    private func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
        let Identifire:String="FriendCell"
        
        Cell = self.FBListTable.dequeueReusableCell(withIdentifier: Identifire)as! FacebookFriendCell
        
        //        let img_url:String=String(FriendArray.objectAtIndex(indexPath.row).valueForKey("picture")?.valueForKey("data")?.valueForKey("url"))
        
        
        // Cell.FriendImageView.imageURL=NSURL(string: img_url)
        
        
        Cell.NameLbl.text=(FriendArray.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
        
        Cell.Colorlable.layer.cornerRadius=25
        Cell.Colorlable.clipsToBounds=true
        
        Cell.Colorlable.backgroundColor = self.getRandomColor()
        
        let MainArr:NSArray = (Cell.NameLbl.text?.components(separatedBy: " "))! as NSArray
        
        var Charstr:String?
        
        if MainArr.count>1
        {
//            let Charstr1:NSString=(MainArr.objectAtIndex(0) as AnyObject).substring(1) as NSString
//
//
//            let Charstr2:NSString=(MainArr.objectAtIndex(1) as AnyObject).substring(1) as NSString
//
//            Charstr=String(stringInterpolation:Charstr1 as String,Charstr2 as String)
        }
        else if (MainArr.count==1)
        {
//            let Charstr1:NSString=(MainArr.objectAtIndex(0) as AnyObject).substring(1) as NSString
            
           // Charstr=String(stringInterpolation:Charstr1 as String)
            
        }
        else if (MainArr.count==0)
        {
            Charstr=String(stringInterpolation:"FB")
        }
        
        Cell.Colorlable.text = Charstr
        
        
        if selectedIndex .contains(indexPath)
        {
            Cell.accessoryType = .checkmark
            
        }
        else
        {
            Cell.accessoryType = .none
        }
        
        return Cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("Selected Row Number is:: %ld", indexPath.row)
        
        Cell=FBListTable.cellForRow(at: indexPath as IndexPath)as! FacebookFriendCell
        
        print(FriendArray)
        
        print(SelectedFriend)
        
        if Cell.accessoryType == .none
        {
            Cell.accessoryType = .checkmark
            
            selectedIndex .add(indexPath)
            
            SelectedFriend .add(FriendArray .object(at: indexPath.row))
        }
        else
        {
            print(SelectedFriend)
            
            Cell.accessoryType = .none
            
            selectedIndex.remove(indexPath)
            
            print(FriendArray.object(at: indexPath.row))
            
            if SelectedFriend.count>0
            {
                for i in 0 ..< SelectedFriend.count
                {
                    if(((SelectedFriend.object(at: i) as AnyObject).value(forKey: "id") as!NSString) .isEqual(to: ((FriendArray.object(at: indexPath.row) as AnyObject).value(forKey: "id"))as! NSString as String))
                    {
                        SelectedFriend.removeObject(at: i)
                        break
                    }
                }
            }
        }
        
        FBListTable .deselectRow(at: indexPath as IndexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  FriendArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
}
