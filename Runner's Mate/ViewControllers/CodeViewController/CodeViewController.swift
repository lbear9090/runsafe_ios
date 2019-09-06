//
//  CodeViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/1/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CodeViewController: UIViewController,UITextFieldDelegate,UtilityDelegate
{
    
    var Util:UtilityClass=UtilityClass()
    
  //  @IBOutlet var FistView_line_Seprator: UILabel!
    
    @IBOutlet var LoginScrollView: UIScrollView!
    
   // @IBOutlet var Seprator_Right: NSLayoutConstraint!
    
   // @IBOutlet var Seprator_Left: NSLayoutConstraint!
    
    @IBOutlet var txt_code1: UITextField!
    
    @IBOutlet var Bottom_View: UIView!
    
    @IBOutlet var Bottom_View_lbl: UILabel!
    
    @IBOutlet var lbl_Number: UILabel!
    
 //   @IBOutlet var TextBaseview: UIView!
    
    @IBOutlet var Resend_button: UIButton!
    
    @IBOutlet var Enter_button: UIButton!
    
    var TapGesture:UITapGestureRecognizer!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Util.delegate=self
        
    }
    
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
    }
    
    @objc func CheckForCode()
    {
        
        
        var Code:String=String(stringInterpolation:"Your verification code is:\(String(describing: Constant.USERDEFAULT.value(forKey: "VeriCode")))")
        Code = Code .replacingOccurrences(of: "Optional", with: "")
        Code = Code .replacingOccurrences(of: ")", with: "")
        Code = Code .replacingOccurrences(of: "(", with: "")
        
        //        Code = Code .stringByReplacingOccurrencesOfString("Optional", withString: "")
        //
        //        Code = Code .stringByReplacingOccurrencesOfString(")", withString: "")
        //
        //        Code = Code .stringByReplacingOccurrencesOfString("(", withString: "")
        
        let AlertView = UIAlertController(title:"Runsafe" as String, message:Code, preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            
            self.txt_code1.text = Constant.USERDEFAULT.value(forKey: "VeriCode") as?String
        })
        
        //        let Cancel:UIAlertAction=UIAlertAction(title: "Cancel", style: .Default, handler: { (UIAlertAction) in
        //            AlertView.dismissViewControllerAnimated(true, completion: nil)
        //        })
        //
        AlertView.addAction(Ok)
        
        //      AlertView.addAction(Cancel)
        
        self.present(AlertView, animated: true, completion: nil)
    }
    
    //MARK:- ViewWill Appear
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForCode), name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
        
        //        TextBaseview .layer.borderWidth=0.8
        //
        //        TextBaseview.layer.borderColor=UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0).CGColor
        
        // Enter_button.enabled=false
        
        self.navigationController?.isNavigationBarHidden=true
        
        Bottom_View.isHidden=true
        
        self.navigationController?.navigationItem.hidesBackButton=true
        self.navigationItem.hidesBackButton=true
        
        let resultString = (Constant.USERDEFAULT.value(forKey:"Country_code")! as AnyObject).appending(" ").appending(Constant.USERDEFAULT.value(forKey: "Number")! as! String)
        
        lbl_Number.text=resultString
        
        LoginScrollView.layoutIfNeeded()
        
        //LoginScrollView.contentSize=CGSizeMake(0, 0)
        LoginScrollView.contentSize=CGSize(width: 0.0, height: 0.0)
        LoginScrollView.isScrollEnabled=false
        
        
        //        if (Constant.isiPhone_6)
        //        {
        //            FistView_line_Seprator .layoutIfNeeded();
        //            Seprator_Left.constant=15
        //            Seprator_Right.constant=15
        //
        //        }
        //        else if (Constant.isiPhone_6_Plus)
        //        {
        //            FistView_line_Seprator .layoutIfNeeded();
        //            Seprator_Left.constant=17
        //            Seprator_Right.constant=17
        //        }
        
        //        self.navigationController!.navigationBar.titleTextAttributes = [
        //            NSForegroundColorAttributeName : UIColor.blackColor(),
        //            NSFontAttributeName : Constant.TitleFont]
        
    }
    
    //MARK:- BottomView_CloseButton Click
    
    @IBAction func BottomView_Close_Click(sender: UIButton)
    {
        Bottom_View.isHidden=true
    }
    
    //MARK:- Resend ButtonClick
    @IBAction func Resend_Click(sender: UIButton)
    {
        txt_code1 .resignFirstResponder()
        txt_code1.text=""
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Loading...")
        
        let User_id=(Constant.USERDEFAULT .value(forKey: "UserID"))!
        
//        let post:String=String(stringInterpolation:"userid=\(String(describing: User_id))")
        
        
        
        let params:[String : String] = ["userid":User_id as! String]
        
        
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

                    
                    
                    let dataarray=dict["status"].dictionaryValue["data"]?.arrayValue
                    
                    let selecteddic=dataarray![0].dictionaryValue
                    
                    let VerificationCode = selecteddic["varification_code"]?.stringValue
                    
                    Constant.USERDEFAULT .setValue(VerificationCode, forKey: "VeriCode")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    
                }
                else
                {
                    Constant.AlertViewNew(Title: "Runsafe", Message:dict["status"].dictionaryValue["message"]?.stringValue as! NSString , ViewController: self)
                    
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
    
    //MARK:- Enter ButtonClick
    @IBAction func Enter_Click(sender: UIButton)
    {
        txt_code1 .resignFirstResponder()
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        if self.txt_code1.text!.isEmptyString()
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Verification Code can't be blank", ViewController: self)
            return
        }
        
        if self.txt_code1.text!.characters.count != 4
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Verification Code can't proper", ViewController: self)
            return
        }
        
        
        if (self.txt_code1.text == Constant.USERDEFAULT.value(forKey: "VeriCode") as?String)
        {
            
            if (Constant.USERDEFAULT.object(forKey: "AllContact") == nil)
            {
                Constant.APPDELEGATE.FetchContacts()
            }
            
            Constant.USERDEFAULT .set(true, forKey: "isLogin")
            Constant.USERDEFAULT .synchronize()
            
            let weatherbview=self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") 
            
            Constant.Push_POP_to_ViewController(destinationVC: weatherbview!, navigationsController: self.navigationController!, isAnimated: true)
            
        }
        else
        {
            txt_code1.text=""
            
            self.performSegue(withIdentifier: "PushToAlert", sender: self)
        }
        
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
            // LoginScrollView.contentOffset = CGPointMake(0,180);
            LoginScrollView.contentOffset = CGPoint(x: 0.0, y: 180.0)
        }
        else if(Constant.isiPhone_5)
        {
            // LoginScrollView.contentOffset = CGPointMake(0,70);
            LoginScrollView.contentOffset = CGPoint(x: 0.0, y: 70.0)
        }
        self .setToolBarOnKeyBoard(textField: textField)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        self.view.removeGestureRecognizer(TapGesture)
        
        if(Constant.isiPhone_4 || Constant.isiPhone_5)
        {
            //  LoginScrollView.contentOffset = CGPointMake(0,-20);
            LoginScrollView.contentOffset = CGPoint(x: 0, y: -20)
        }
        
    }
    
    func setToolBarOnKeyBoard(textField: UITextField)
    {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,width:  UIScreen.main.bounds.size.width, height: 50))
        
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(CodeViewController.resignKeyBoard))]
        textField.inputAccessoryView = toolBar
    }
    
    @objc func resignKeyBoard()
    {
        txt_code1.resignFirstResponder()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text
            else
        {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        //        if newLength >= 4
        //        {
        //            Enter_button.enabled=true
        //
        //            Enter_button .setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        //        }
        //        else
        //        {
        //            Enter_button.enabled=false
        //
        //             Enter_button .setTitleColor(UIColor.lightGrayColor(),forState: UIControlState.Normal)
        //
        //        }
        
        return newLength <= 4
    }
    
    //MARK:- Utility Delegate
 //   func gotResponse(data: AnyObject, forRequest tag: Int)
//    {
//        if(tag==49)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//
//            let Dic:NSDictionary=data as!NSDictionary
//
//            let Status:NSString=(Dic .value(forKey: "status") as AnyObject).value(forKey: "sucess") as! NSString
//
//            if(Status .isEqual(to: "1"))
//            {
//                NSLog("%@", "Your Verification code is succesfully send")
//                //
//                //                let VerificationCode:String=(((Dic.value(forKey: "status") ).value(forKey: "data")).object(0) ).value(forKey: "varification_code") as! String
//
//                let VerificationCode:String=(((Dic.value(forKey:"status") as AnyObject).value(forKey:"data") as AnyObject).object(at:0) as AnyObject).value(forKey:"varification_code") as! String
//
//                Constant.USERDEFAULT .setValue(VerificationCode, forKey: "VeriCode")
//
//                Constant.USERDEFAULT .synchronize()
//
//                // Constant.AlertViewNew("Ceres8", Message:Dic .valueForKey("status")?.valueForKey("message") as! NSString , ViewController: self)
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
//        if(tag==49)
//        {
//            Constant.APPDELEGATE.hideLoadingHUD()
//            Constant.ConnectionFailAlert(ViewController: self)
//        }
//
//    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    
}
