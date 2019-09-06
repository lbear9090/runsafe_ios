//
//  CodeView.swift
//  Ceres8
//
//  Created by Lucky on 6/28/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CodeView: UIViewController,UtilityDelegate
{
    @IBOutlet var Btn0: UIButton!
    @IBOutlet var Btn1: UIButton!
    @IBOutlet var Btn2: UIButton!
    @IBOutlet var Btn3: UIButton!
    @IBOutlet var Btn4: UIButton!
    @IBOutlet var Btn5: UIButton!
    @IBOutlet var Btn6: UIButton!
    @IBOutlet var Btn7: UIButton!
    @IBOutlet var Btn8: UIButton!
    @IBOutlet var Btn9: UIButton!
    @IBOutlet var NextBtn: UIButton!
    @IBOutlet var CancelBtn: UIButton!
    @IBOutlet var PickerViewBtn: UIButton!
    @IBOutlet var ClearBtn: UIButton!
    @IBOutlet var ResendBtn: UIButton!
    @IBOutlet var BackBtn: UIButton!
    @IBOutlet var PassCodeTxtField: UITextField!
    @IBOutlet var pickerview: UIPickerView!
    
    var PStr: NSString?
    
    @IBOutlet var TitelLblHeder: UILabel!
    
    var Util:UtilityClass=UtilityClass()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        
        Util.delegate=self
        
        self .Clear_allPhoneNumber(sender: self)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationItem.hidesBackButton=true
        self.navigationItem.hidesBackButton=true
        self.navigationController?.isNavigationBarHidden=false
        
        self.navigationItem.title = "Verify";

        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
        
        PStr=""
    }
    
    
    @IBAction func Clear_allPhoneNumber(sender: AnyObject)
    {
        PStr = nil
        PStr = String() as NSString
        PassCodeTxtField.text = PStr as String?

    }
    
    @IBAction func SelectPhoneNumber(sender: AnyObject)
    {
        let tempBtn: UIButton = (sender as! UIButton)
        let Str: String = "\(Int(tempBtn.tag))"
        if (PStr?.length)! < 4
        {
            PStr=PStr?.appending(Str) as! NSString
        }
        
        let newLength: NSInteger = (PStr?.length)!
        
        if newLength > 4
        {
            
        }
        else
        {
            PassCodeTxtField.text = PStr as String?
        }

    }
    
    @IBAction func Go_MapView(sender: AnyObject)
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        if PassCodeTxtField.text!.characters.count == 0
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Enter Your Passcode", ViewController: self)
            return
        }
        if PassCodeTxtField.text!.characters.count < 4
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please enter 4 digit valid passcode.", ViewController: self)

           
            return
        }
        
        if (self.PassCodeTxtField.text == Constant.USERDEFAULT.value(forKey: "VeriCode") as?String)
        {
            
            Constant.APPDELEGATE.window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
            
            
            Constant.USERDEFAULT .set(true, forKey: "isLogin")
            Constant.USERDEFAULT .synchronize()
            
            
        }
        else
        {
            PassCodeTxtField.text=""
            
           
            let story : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = story.instantiateViewController(withIdentifier: "VSuccessViewController") as! VSuccessViewController
//
//            self.presentViewController( self.storyboard!.instantiateViewControllerWithIdentifier("VSuccessViewController") as! VSuccessViewController, animated:true, completion:nil)
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
  
        }

    }
    
    @IBAction func cancel_View(sender: AnyObject)
    {
        PStr = PStr! .replacingOccurrences(of: "Optional", with: "") as NSString
        PStr = PStr! .replacingOccurrences(of: ")", with: "") as NSString
        PStr = PStr! .replacingOccurrences(of: "(", with: "") as NSString
        PStr = PStr! .replacingOccurrences(of: "\n", with: "") as NSString
        PStr = PStr! .replacingOccurrences(of: "\"", with: "") as NSString as NSString
//        PStr = PStr! .stringByReplacingOccurrencesOfString("Optional", withString: "")
//
//        PStr = PStr!
//            .stringByReplacingOccurrencesOfString(")", withString: "")
//
//        PStr
//            = PStr! .stringByReplacingOccurrencesOfString("(", withString: "")
//
//        PStr = PStr! .stringByReplacingOccurrencesOfString("\n", withString:"")
//
//        PStr = PStr! .stringByReplacingOccurrencesOfString("\"", withString:"")

        if PStr != nil
        {
            PStr = PStr! .replacingOccurrences(of: "Optional", with: "") as NSString
            PStr = PStr! .replacingOccurrences(of: ")", with: "") as NSString
            PStr = PStr! .replacingOccurrences(of: "(", with: "") as NSString
            PStr = PStr! .replacingOccurrences(of: "\n", with: "") as NSString
            PStr = PStr! .replacingOccurrences(of: "\"", with: "") as NSString
//            PStr = PStr! .stringByReplacingOccurrencesOfString("Optional", withString: "")
//
//            PStr = PStr!
//                .stringByReplacingOccurrencesOfString(")", withString: "")
//
//            PStr
//                = PStr! .stringByReplacingOccurrencesOfString("(", withString: "")
//
//            PStr = PStr! .stringByReplacingOccurrencesOfString("\n", withString:"")
//
//            PStr = PStr! .stringByReplacingOccurrencesOfString("\"", withString:"")
            
            PStr = PStr!.substring(to: (PStr?.length)! - 1) as NSString


            
//          let range = NSMakeRange(PStr!.length-1,1)
//
//            PStr?.stringByReplacingCharactersInRange(range, withString:"")
            
            
            PassCodeTxtField.text = PStr  as String?
            
        }
        else
        {
            //no characters to delete... attempting to do so will result in a crash
        }

    }
    
//    func removeOption(str:String)
//    {
//        str = str.stringByReplacingOccurrencesOfString("Optional", withString: "")
//        
//        str = str!
//            .stringByReplacingOccurrencesOfString(")", withString: "")
//        
//        str
//            = str! .stringByReplacingOccurrencesOfString("(", withString: "")
//        
//        str = str! .stringByReplacingOccurrencesOfString("\n", withString:"")
//        
//        str = str! .stringByReplacingOccurrencesOfString("\"", withString:"")
//        
//    }
    @IBAction func Resend_Sms(sender: AnyObject)
    {
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Loading...")
        
        let User_id=(Constant.USERDEFAULT .value(forKey: "UserID"))!
        
//        let post:String=String(stringInterpolation:"userid=\(String(describing: User_id))")
        
        
        let params:[String : String] = ["user_id":User_id as! String]
        
        
        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/resend_code.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                var dict = JSON(response.result.value ?? "")
                
                
                
                
                
                let str = dict["status"].dictionaryValue["sucess"]?.stringValue
                if (str? .isEqual("1"))!
                {
                    
                     let VerificationCode = ((dict["status"].dictionaryValue["data"]as AnyObject).object(at: 0) as AnyObject).value(forKey: "varification_code")
                   
                    
                   
                    
                    Constant.USERDEFAULT .setValue(VerificationCode, forKey: "VeriCode")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    
                    
                    Constant.AlertViewNew(Title: "Runsafe", Message: dict["status"].dictionaryValue["message"]?.stringValue as! NSString, ViewController: self)
                }
                else
                {
                    Constant.AlertViewNew(Title: "Runsafe", Message: dict["status"].dictionaryValue["message"]?.stringValue as! NSString, ViewController: self)
                    
                }
                
                break
                
            case .failure(_):
                Constant.APPDELEGATE.hideLoadingHUD()
                Constant.ConnectionFailAlert(ViewController: self)
                break
                
            }
        }
        
        
        
//        Util.webServiceCallMethod(QueryString: post, forWebServiceCall:"http://webprojectdevelopment.website/runner_mate/webservice/resend_code.php?", setHTTPMethod: "POST", withTag: 49)
    }

    //MARK:- Utility Delegate
//    func gotResponse(data: AnyObject, forRequest tag: Int)
//    {
//        if(tag==49)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//
//            let Dic:NSDictionary=data as!NSDictionary
//
//            let Status: String? = ((Dic.value(forKey: "status") as? NSDictionary)?.value(forKey: "sucess") as? String)
//
//            if(Status? .isEqual("1"))!
//            {
//                NSLog("%@", "Your Verification code is succesfully send")
//
//                let VerificationCode:String = (((Dic.value(forKey: "status") as! NSDictionary).value(forKey: "data")as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "varification_code") as! String
//
//                // let status: String? = ((Dic.value(forKey: "status") as? NSDictionary)?.value(forKey: "sucess") as? String)
//
//                Constant.USERDEFAULT .setValue(VerificationCode, forKey: "VeriCode")
//
//                Constant.USERDEFAULT .synchronize()
//
//
//
//                Constant.AlertViewNew(Title: "Ceres8", Message: (Dic.value(forKey: "status") as! NSDictionary).value(forKey: "message") as! NSString, ViewController: self)
//            }
//            else
//            {
//                Constant.AlertViewNew(Title: "Ceres8", Message: (Dic.value(forKey: "status") as! NSDictionary).value(forKey: "message") as! NSString, ViewController: self)
//
//            }
//        }
//    }
//
//    func failure(data: AnyObject, forRequest tag: Int)
//    {
//        if(tag==49)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//            Constant.ConnectionFailAlert(ViewController: self)
//        }
//
//    }

}
