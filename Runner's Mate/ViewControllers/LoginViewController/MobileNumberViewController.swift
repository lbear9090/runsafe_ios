//
//  ViewController.swift
//  Ceres8
//
//  Created by Lucky on 5/31/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MobileNumberViewController: UIViewController,UITextFieldDelegate,UtilityDelegate
{
    
    
    var Util:UtilityClass=UtilityClass()
    
 //   @IBOutlet var FistView_line_Seprator: UILabel!
    
    @IBOutlet var LoginScrollView: UIScrollView!
    
    @IBOutlet var TextBaseview: UIView!
    
  //  @IBOutlet var Seprator_Right: NSLayoutConstraint!
    
   // @IBOutlet var Seprator_Left: NSLayoutConstraint!
    
    @IBOutlet var txt_MobileNumber: UITextField!
    
  //  @IBOutlet var txt_CountryCode: UITextField!
    
    @IBOutlet var Country_lbl: UILabel!
    
    @IBOutlet var Bottom_View: UIView!
    
    @IBOutlet var Bottom_View_lbl: UILabel!
    
    var TapGesture:UITapGestureRecognizer!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print("load loginview")
        
        //  Util.delegate=self
        
    }
    
    func setStatusBarBackgroundColor(color: UIColor)
    {
        
        let statusBar:UIView = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = color
        }
        
    }
    
    //MARK:- ViewWill Appear
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForCountryCodeViaCurrentLocation), name: NSNotification.Name(rawValue: "CheckForCountryCodeViaCurrentLocation"), object: nil)
        
        self .setStatusBarBackgroundColor(color: UIColor.clear)
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
        }
        
        if (Constant.USERDEFAULT.value(forKey: "Country_name")) != nil
        {
            let Country:NSString = NSString (format:"%@",Constant.USERDEFAULT.value(forKey: "Country_name")as! String)
            
            if Country.length>0
            {
                Country_lbl.text=NSString (format:"%@",Constant.USERDEFAULT.value(forKey: "Country_name")! as! String) as String
            }
            else
            {
                Country_lbl.text=""
            }
        }
        else
        {
            Country_lbl.text=""
        }
        
        
        
        if Constant.APPDELEGATE.LocationEnable==true
        {
            Bottom_View.isHidden=true
            
        }
        else
        {
            Bottom_View.isHidden=false
            
            
            Bottom_View_lbl.text="Please wait while we find you."
            
        }
        
        self.navigationController?.isNavigationBarHidden=true
        
        LoginScrollView.layoutIfNeeded()
        
        LoginScrollView.contentSize=CGSize(width: 0.0, height: 0.0)
        
        LoginScrollView.isScrollEnabled=false
        
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForCountryCodeViaCurrentLocation"), object: nil)
        
    }
    
    //MARK:- NextButton Click
    
    @IBAction func NextButton_Click(sender: UIButton)
    {
        
        txt_MobileNumber .resignFirstResponder()
        
        //        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        //            NSLog(@"Online");
        //        }
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
        if  Country_lbl.text! .isEmptyString()
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please enable your location or check your internet connection.", ViewController: self)
            
            return
        }
        
        if self.txt_MobileNumber.text!.isEmptyString()
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Phone Number can't be blank", ViewController: self)
            
            return
        }
        
        let D_Token=Constant.APPDELEGATE.DeviceToken
        
        if (D_Token == nil)
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please goto settings and enable notifcation ", ViewController: self)
            return
        }
        
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Verifying...")
        
        let MobileNumber=txt_MobileNumber.text
        
        var Country_code = Constant.USERDEFAULT.value(forKey: "Country_code")as! String
        Country_code = Country_code.replacingOccurrences(of: "+", with: "")
        
       
        
        let params:[String : String] = ["device_token":D_Token! as String,"device_type":"ios","country_code": Country_code ,"phone_number": MobileNumber! ]
        
        print(Country_code)
        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/add_user.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                var dict = JSON(response.result.value ?? "").dictionaryValue
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                let Status = dict["status"]?.dictionaryValue["sucess"]?.stringValue
            
                if(Status?.isEqual("1"))!
                {
                    
                    let Data:Array=(dict["status"]?.dictionaryValue["data"]?.array)!
                    
                    let UserID = Data[0].dictionaryValue["user_id"]?.stringValue
                    
                    var PhoneNumber:String=(Data[0].dictionaryValue["phone_number"]?.stringValue)!
                    
                    PhoneNumber = PhoneNumber.replacingOccurrences(of: "\"", with: "")
                    
                    let SelDic:NSDictionary=Data[0].dictionaryValue as NSDictionary
                    
                    let arrkey:NSArray=NSArray(array: SelDic.allKeys)
                    
                    if (arrkey.contains("varification_code"))
                    {
                        let VerificationCode:String=(Data[0].dictionaryValue["varification_code"]?.stringValue)!
                        
                        Constant.USERDEFAULT.setValue(VerificationCode, forKey: "VeriCode")
                        
                        Constant.USERDEFAULT .synchronize()
                    }
                    
                    Constant.USERDEFAULT .setValue(UserID, forKey: "UserID")
                    
                    Constant.USERDEFAULT .setValue(PhoneNumber, forKey: "Number")
                    
                    
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    self.performSegue(withIdentifier: "PushToCode", sender: self)
                    
                    
                    
                    
                    
                }
                else
                {
                    
                    let messageStr=dict["status"]?.dictionaryValue["message"]?.stringValue
                    
                    Constant.AlertViewNew(Title: "Runsafe", Message: messageStr! as NSString, ViewController: self)
                }
                
                break
                
            case .failure(_):
                Constant.APPDELEGATE.hideLoadingHUD()
                Constant.ConnectionFailAlert(ViewController: self)
                break
                
            }
        }
        
        
        
    }
    
    
    //MARK:- BottomView_CloseButton Click
    @IBAction func BottomView_Close_Click(sender: UIButton)
    {
        Bottom_View.isHidden=true
    }
    
    //MARK:- TextFiled Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        TapGesture = UITapGestureRecognizer(target: self, action: #selector(self.resignKeyBoard))
        
        self.view.addGestureRecognizer(TapGesture)
        
        if(Constant.isiPhone_4)
        {
            if(textField==txt_MobileNumber)
            {
                LoginScrollView.contentOffset = CGPoint(x: 0, y: 180)
            }
        }
            
        else if(Constant.isiPhone_5)
        {
            if(textField==txt_MobileNumber)
            {
                LoginScrollView.contentOffset = CGPoint(x: 0, y: 70)
            }
        }
        
        self .setToolBarOnKeyBoard(textField: textField)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //        if(Constant.isiPhone_4)
        //        {
        //            LoginScrollView.contentOffset = CGPointMake(0,-20);
        //        }
        
        if(Constant.isiPhone_4 || Constant.isiPhone_5)
        {
            LoginScrollView.contentOffset = CGPoint(x: 0, y: -20)
        }
        
        self.view.removeGestureRecognizer(TapGesture)
        
    }
    
    func setToolBarOnKeyBoard(textField: UITextField)
    {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0))
        
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(MobileNumberViewController.resignKeyBoard))]
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc func resignKeyBoard()
    {
        txt_MobileNumber.resignFirstResponder()
    }
    
    //MARK:- Utility Delegate
//    func gotResponse(data: AnyObject, forRequest tag: Int)
//    {
//        if(tag==45)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//            
//            let Dic:NSDictionary=data as!NSDictionary
//            
//            let Status:NSString=(Dic .value(forKey: "status") as AnyObject).value(forKey: "sucess") as! NSString
//            
//            if(Status .isEqual(to: "1"))
//            {
//                
//                let Data:NSArray=(Dic.value(forKey: "status") as AnyObject).value(forKey: "data") as! NSArray
//                
//                let UserID=(((Dic.value(forKey: "status") as AnyObject).value(forKey: "data") as AnyObject).object(at: 0) as AnyObject).value(forKey: "user_id")
//                
//                var PhoneNumber:String=(Data.object(at: 0) as AnyObject).value(forKey: "phone_number") as! String
//                PhoneNumber = PhoneNumber.replacingOccurrences(of: "\"", with: "")
//                //                PhoneNumber=PhoneNumber .stringByReplacingOccurrencesOfString("\"", withString: "")
//                
//                
//                //                var CountryCode:String=Data.objectAtIndex(0).valueForKey("country_code") as! String
//                //
//                //                CountryCode=CountryCode .stringByReplacingOccurrencesOfString(" ", withString: "")
//                
//                let arrkey:NSArray=NSArray(array: (Data.object(at: 0) as AnyObject).allKeys)
//                
//                if (arrkey.contains("varification_code"))
//                {
//                    let VerificationCode:String=(Data.object(at: 0) as AnyObject).value(forKey: "varification_code") as! String
//                    
//                    Constant.USERDEFAULT.setValue(VerificationCode, forKey: "VeriCode")
//                    
//                    Constant.USERDEFAULT .synchronize()
//                }
//                
//                Constant.USERDEFAULT .setValue(UserID, forKey: "UserID")
//                
//                Constant.USERDEFAULT .setValue(PhoneNumber, forKey: "Number")
//                
//                // Constant.USERDEFAULT .setValue(CountryCode, forKey: "Country_code")
//                
//                Constant.USERDEFAULT .synchronize()
//                
//                self.performSegue(withIdentifier: "PushToCode", sender: self)
//                
//                //                if Constant.isiPhone_4
//                //                {
//                //                    let viewController = CodeView(nibName: "PasscodeViewController", bundle: NSBundle .mainBundle())
//                //                     self.navigationController?.pushViewController(viewController, animated: true)
//                //
//                //                }
//                //                else
//                //                {
//                //                    let viewController = CodeView(nibName: "PasscodeViewController_5", bundle: NSBundle .mainBundle())
//                //                     self.navigationController?.pushViewController(viewController, animated: true)
//                //
//                //                }
//                
//                
//                
//                
//            }
//            else
//            {
//                Constant.AlertViewNew(Title: "Ceres8", Message:(Dic .value(forKey: "status") as AnyObject).value(forKey: "message") as! NSString , ViewController: self)
//                
//            }
//        }
//    }
//    func failure(data: AnyObject, forRequest tag: Int)
//    {
//        if(tag==45)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//            Constant.ConnectionFailAlert(ViewController: self)
//        }
//    }
//    
    
    @objc func CheckForCountryCodeViaCurrentLocation()
    {
        
        if Constant.APPDELEGATE.LocationEnable==true
        {
            Bottom_View.isHidden=true
        }
        else
        {
            Bottom_View.isHidden=false
            
            Bottom_View_lbl.text="Go to phone setting and ON your location first."
            
        }
        
        if Constant.APPDELEGATE.LocationEnable==true
        {
            
            //   let code:NSString = NSString(format: "%@", Constant.USERDEFAULT .valueForKey("Country_code") as! String)
            
            Country_lbl.text = NSString (format:"%@",Constant.USERDEFAULT.value(forKey: "Country_name")! as! String) as String
            
            // txt_CountryCode.text=code as String
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

