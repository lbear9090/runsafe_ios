//
//  SettingViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/9/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Alamofire
import SwiftyJSON


@available(iOS 9.0, *)

class SettingViewController: UIViewController,UITableViewDelegate,CNContactPickerDelegate
{
    
    @IBOutlet var btnSave: UIButton!
    
    var hasEdited:Bool=false
    
    @IBOutlet var imgChkmrkForCustomMsg: UIImageView!
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet var btnAddContacts: UIButton!
    
    
    // @IBOutlet var txtCustomMsg: UITextField!
    
    @IBOutlet var LocationBaseView: UIView!
    
    @IBOutlet var Location_Switch: UISwitch!
    
    @IBOutlet var FaceBook_Switch: UISwitch!
    
    @IBOutlet var WhatsApp_Switch: UISwitch!
    
    @IBOutlet var WeChat_Switch: UISwitch!
    
    @IBOutlet var Line_Switch: UISwitch!
    
    @IBOutlet var iBeacon_Switch: UISwitch!
    
    var isCheckMark:Bool=false
    
    @IBOutlet var Nofifications_Switch: UISwitch!
    var store = CNContactStore()
    var arySelectedContacts:NSMutableArray=NSMutableArray()
    var words2:NSMutableArray=NSMutableArray()
    var contactTemp:CNContact=CNContact()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius=5
        btnAddContacts.layer.borderWidth=1
        btnAddContacts.layer.borderColor = UIColor(red: 221.0/255, green: 221.0/255, blue: 221.0/255, alpha: 1.0).cgColor
    }
    
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    @IBAction func btn_Save_clicked(sender: AnyObject)
    {
       // self.performSegue(withIdentifier: "PushtoMessage", sender: self)
       
        let message = self.storyboard?.instantiateViewController(withIdentifier: "CustomMessageViewController")as! CustomMessageViewController
        
        Constant.Push_POP_to_ViewController(destinationVC: message, navigationsController: (self.navigationController)!, isAnimated: true)
        
        //self.navigationController?.pushViewController(message, animated: true)
       
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) == nil
        {
            // if (Constant.USERDEFAULT.arrayForKey("CustomMessageArray")?.count>0)
            if ((Constant.USERDEFAULT.array(forKey: "CustomMessageArray")?.count) != nil)
            {
                let  MArray:NSMutableArray =  NSMutableArray(array: (Constant.USERDEFAULT.array(forKey: "CustomMessageArray"))!)
                
                MArray.add("I am out for run/walk, not feeling safe. I need you on the phone/help.")
                
                Constant.USERDEFAULT.set(MArray, forKey: "CustomMessageArray")
                Constant.USERDEFAULT.synchronize()
                
            }
            else
            {
                let  MArray:NSMutableArray =  NSMutableArray()
                
                MArray.add("I am out for run/walk, not feeling safe. I need you on the phone/help.")
                
                Constant.USERDEFAULT.set(MArray, forKey: "CustomMessageArray")
                Constant.USERDEFAULT.synchronize()
            }
            
            Constant.USERDEFAULT.setValue("I am out for run/walk, not feeling safe. I need you on the phone/help.", forKey: "CustomMessage")
            Constant.USERDEFAULT.synchronize()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            Location_Switch.setOn(true, animated: true)
        }
        else
        {
            Location_Switch.setOn(false, animated: true)
            
        }
        
        
        if  Constant.APPDELEGATE.FaceBookSharing==true
        {
            FaceBook_Switch.setOn(true, animated: true)
        }
        else
        {
            FaceBook_Switch.setOn(false, animated: true)
            
        }
        
        if  Constant.APPDELEGATE.WhatsAppSharing==true
        {
            WhatsApp_Switch.setOn(true, animated: true)
        }
        else
        {
            WhatsApp_Switch.setOn(false, animated: true)
            
        }
        
        if  Constant.APPDELEGATE.WeChatSharing==true
        {
            WeChat_Switch.setOn(true, animated: true)
        }
        else
        {
            WeChat_Switch.setOn(false, animated: true)
            
        }
        
        if  Constant.APPDELEGATE.LineSharing==true
        {
            Line_Switch.setOn(true, animated: true)
        }
        else
        {
            Line_Switch.setOn(false, animated: true)
            
        }
        
        
        if  Constant.APPDELEGATE.Notification==true
        {
            Nofifications_Switch.setOn(true, animated: true)
        }
        else
        {
            Nofifications_Switch.setOn(false, animated: true)
            
        }
        
        if (Constant.USERDEFAULT.value(forKey: "BluetoothSwitch")) == nil || ((Constant.USERDEFAULT.value(forKey: "BluetoothSwitch"))! as AnyObject) .isEqual("false")
        {
            Constant.USERDEFAULT.setValue("false", forKey: "BluetoothSwitch")
            iBeacon_Switch.setOn(false, animated: true)
        }
        else
        {
            Constant.USERDEFAULT.setValue("true", forKey: "BluetoothSwitch")
            iBeacon_Switch.setOn(true, animated: true)
        }
        
        Constant.USERDEFAULT.synchronize()
        
        
        
        self.navigationItem.rightBarButtonItem = nil;
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
    }
    
    //---------------------------------sank----
    
    func setViewMovedUp(movedUp: Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        // if you want to slide up the view
        var rect = self.view.frame
        
        if movedUp {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= 100
            // rect.size.height += kOFFSET_FOR_KEYBOARD
        }
        else {
            // revert back to the normal state.
            rect.origin.y += 100
            //  rect.size.height -= kOFFSET_FOR_KEYBOARD
        }
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        hasEdited=true
        setViewMovedUp(movedUp: true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        setViewMovedUp(movedUp: false)
        return true
    }
    
   
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Done_Click(sender: UIBarButtonItem)
    {
        
    }
    
    //MARK:- Location Click
    
    @IBAction func Location_Click(sender: UISwitch)
    {
        if  Location_Switch.isOn==true
        {
            Constant.APPDELEGATE.SettingLocation=true
        }
        else
        {
            Constant.APPDELEGATE.SettingLocation=false
        }
    }
    
    //MARK:- Facebook Click
    
    @IBAction func FaceBook_Click(sender: UISwitch)
    {
        
        // Constant.FunctionalityAlert(self)
        
        if  FaceBook_Switch.isOn==true
        {
            Constant.APPDELEGATE.FaceBookSharing=true
        }
        else
        {
            Constant.APPDELEGATE.FaceBookSharing=false
        }
        
        
    }
    
    //MARK:- WhatsApp Click
    
    @IBAction func WhatsApp_Click(sender: UISwitch)
    {
        // Constant.FunctionalityAlert(self)
        if  WhatsApp_Switch.isOn==true
        {
            Constant.APPDELEGATE.WhatsAppSharing=true
        }
        else
        {
            Constant.APPDELEGATE.WhatsAppSharing=false
        }
    }
    
    //MARK:- WeChat Click
    
    @IBAction func WeChat_Click(sender: UISwitch)
    {
        // Constant.FunctionalityAlert(self)
        if  WeChat_Switch.isOn==true
        {
            Constant.APPDELEGATE.WeChatSharing=true
        }
        else
        {
            Constant.APPDELEGATE.WeChatSharing=false
        }
    }
    
    //MARK:- iBeacon_Switch_clicked
    @IBAction func iBeacon_Switch_clicked(sender: AnyObject)
    {
        if  iBeacon_Switch.isOn==false
        {
            Constant.USERDEFAULT.setValue("false", forKey: "BluetoothSwitch")
            
            iBeacon_Switch.setOn(false, animated: true)
        }
        else
        {
            Constant.USERDEFAULT.setValue("true", forKey: "BluetoothSwitch")
            
            iBeacon_Switch.setOn(true, animated: true)
            
        }
        Constant.USERDEFAULT.synchronize()
        
    }
    //MARK:-Notification_Switch_clicked
    @IBAction func Notification_Switch_clicked(sender: AnyObject) {
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            if  Nofifications_Switch.isOn==true
            {
                 Nofifications_Switch.setOn(false, animated: true)
            }
            else
            {
                 Nofifications_Switch.setOn(true, animated: true)
            }
            
            Constant.InternetNewAlert(ViewController: self)
        }
        else
        {
            if  Nofifications_Switch.isOn==true
            {
                self .webServiceCallForNotificationStatus(Status: "1")
                
            }
            else
            {
                self .webServiceCallForNotificationStatus(Status: "0")
            }
        }
       
    }
    
    func webServiceCallForNotificationStatus(Status:NSString)
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Please wait...")
        
        let User_id=(Constant.USERDEFAULT.value(forKey: "UserID"))!
        

        let params:[String : String] = ["user_id":User_id as! String,"notification_status":Status as String]
        
        
        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/notification_status.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                var dict = JSON(response.result.value ?? "")
                
                
                
                
                
                let str = dict["status"].dictionaryValue["sucess"]?.stringValue
                if (str? .isEqual("1"))!
                {
                    

                    
                    
                    if( Status .isEqual(to: "1"))
                    {
                        Constant.USERDEFAULT.set(true, forKey: "Notification")
                        
                        self.Nofifications_Switch.setOn(true, animated: true)
                        Constant.USERDEFAULT.synchronize()
                        
                        Constant.APPDELEGATE.Notification=Constant.USERDEFAULT.bool(forKey: "Notification")
                    }
                    else
                    {
                        Constant.USERDEFAULT.set(false, forKey: "Notification")
                        
                        Constant.USERDEFAULT.synchronize()
                        
                        self.Nofifications_Switch.setOn(false, animated: true)
                        
                        Constant.APPDELEGATE.Notification=Constant.USERDEFAULT.bool(forKey: "Notification")
                    }
                    Constant.showToastMessage(withTitle: Constant.AppName, message: "Notification status updated successfully", in: self.view, animation: true)
                }
                else
                {
                    Constant.showToastMessage(withTitle: "Runsafe", message: "Notification status not updated", in: self.view, animation: true)
                }
                
                break
                
            case .failure(_):
                Constant.APPDELEGATE.hideLoadingHUD()
                
                Constant.ConnectionFailAlert(ViewController: self)
                break
                
            }
        }

    }
    
    //MARK:- Line Click
    @IBAction func Line_Click(sender: UISwitch)
    {
        //Constant.FunctionalityAlert(self)
        if  Line_Switch.isOn==true
        {
            Constant.APPDELEGATE.LineSharing=true
        }
        else
        {
            Constant.APPDELEGATE.LineSharing=false
        }
    }
    
    
    @IBAction func btn_AddContact_clicked(sender: AnyObject)
    {
        
    }
    
    @objc func CheckForNotification()
    {
        Constant.APPDELEGATE.ReceiveNotification=true
        
        let tabBarController = (UIApplication.shared.keyWindow!.rootViewController as! UITabBarController)
        
        tabBarController.selectedIndex = 0;
    }
}
