//
//  AddPinViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/28/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddPinViewController: UIViewController,UIPickerViewDelegate,UtilityDelegate,URLSessionDelegate,UITextFieldDelegate
{
    var pickerDataSoruce:NSMutableArray?
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var lblSelection: UILabel!
    
    @IBOutlet var lblTitleTeller: UILabel!
    @IBOutlet var OtherTextField: UITextField!
    var receivedData:NSMutableData?
    var Cord:CLLocationCoordinate2D?
    
    var TapGesture:UITapGestureRecognizer!
    var TapGesture2:UITapGestureRecognizer!
    
    var Util:UtilityClass=UtilityClass()
    
    
    @IBOutlet var viewForPicker: UIView!
    @IBOutlet var textFieldLeading: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        OtherTextField.isHidden=true
        viewForPicker.isHidden=true
        lblTitleTeller.isHidden=true
        
        
        pickerDataSoruce = ["Robbery","Assault","Arson","Rape","Violet Crime Murder","Poor Roads","Poor Lighting","Unsafe Neighborhoods","Other"]
        
        self.view .bringSubview(toFront: viewForPicker)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        TapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.HidePicker))
        
        self.view.addGestureRecognizer(TapGesture2)
        
        self.navigationItem.hidesBackButton=true
        
        self.navigationItem.title="Select Crime Type"
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- PickerView Delegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerDataSoruce!.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        lblSelection.text=pickerDataSoruce?.object(at: row) as? String
        
        if lblSelection.text=="Other" {
            
            OtherTextField.isHidden=false
            lblTitleTeller.isHidden=false
        }
        else
        {
            OtherTextField.isHidden=true
            lblTitleTeller.isHidden=true
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = pickerDataSoruce?.object(at: row) as? String
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "OpenSans", size: 14) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    
    //MARK:- Save Button Click
    
    @IBAction func SaveClick(sender: UIButton)
    {
        
        self.HidePicker()
        self.resignKeyBoard()
        
        if(AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
        self.viewForPicker.isHidden=true
        
        if lblSelection.text=="Select Crime Type"
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please Select Crime Type", ViewController: self)
            return
        }
        
        if lblSelection.text=="Other"
        {
            if ((OtherTextField.text?.isEmpty) == true)
            {
                Constant.AlertViewNew(Title: "Runsafe", Message: "Please Enter Title for Other Crime", ViewController: self)
                return
            }
            
        }
        
        
        let u_id=(Constant.USERDEFAULT .value(forKey: "UserID"))!
        
        let crimeType:String=lblSelection.text!
        
        let OtherText:String=OtherTextField.text!
        var params:[String : String]
        
        if lblSelection.text=="Other"
        {
            let Latt = String(format: "%f", (Cord?.latitude)!)
            
            let longg = String(format: "%f", (Cord?.longitude)!)

            
             params = ["user_id":u_id as! String,"latitude":Latt,"longitude": longg ,"crime_type": (crimeType) ,"crime_name":OtherText]
            
        }
        else
        {
            let Latt = String(format: "%f", (Cord?.latitude)!)
            
            let longg = String(format: "%f", (Cord?.longitude)!)

             params = ["user_id":u_id as! String,"latitude":Latt,"longitude": longg ,"crime_type": (crimeType)]
            
            
        }
        
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Please wait...")
        
       
        
        
        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/add_crime.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
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
                    
                    let AlertView = UIAlertController(title:"Runsafe", message:dict["status"]?.dictionaryValue["message"]?.stringValue, preferredStyle: .alert)
                    
                        let cancel:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            AlertView.dismiss(animated: true, completion: nil)
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                    
                        AlertView.addAction(cancel)
                    
                        self.present(AlertView, animated: true, completion: nil)
                    
                    }
                    else
                    {
                        Constant.AlertViewNew(Title: "Runsafe", Message:dict["status"]?.dictionaryValue["message"]?.stringValue as! NSString, ViewController: self)
                    }
                break
                
            case .failure(_):
                Constant.ConnectionFailAlert(ViewController:self)
                break
                
            }
        }
        
        
//        post3 = post3!.replacingOccurrences(of: "Optional", with: "")
//        post3 = post3!.replacingOccurrences(of: ")", with: "")
//        post3 = post3!.replacingOccurrences(of: "(", with: "")
//        post3 = post3!.replacingOccurrences(of: "\n", with: "")
//        post3 = post3!.replacingOccurrences(of: "\"", with: "")
//
//
//        let postData: NSData = post3!.data(using: String.Encoding.ascii, allowLossyConversion: true)! as NSData
//
//        let postLength: String = "\(UInt(postData.length))"
//
//        let request: NSMutableURLRequest = NSMutableURLRequest()
//        request.url = NSURL(string:"http://webprojectdevelopment.website/runner_mate/webservice/add_crime.php?")! as URL
//
//        request.httpMethod = "POST"
//        request.timeoutInterval = 60
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//        request.httpBody = postData as Data
        
//        let SessionConfiguration:URLSessionConfiguration=URLSessionConfiguration.default
//
//        let defaultSession:URLSession = URLSession(configuration: SessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
//
//        receivedData = NSMutableData()
//        let dataTask: URLSessionDataTask = defaultSession.dataTask(with: request as URLRequest)
//        dataTask.resume()
    }
    
    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
           
        }
    }
    
//    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
//    {
//        completionHandler(URLSession.ResponseDisposition.allow)
//    }

    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData)
    {
        receivedData!.append(data as Data)
    }
    
    
//    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?)
//    {
//
//        Constant.APPDELEGATE.hideLoadingHUD()
//        if error == nil
//        {
//            NSLog("Download is Succesfull")
//            do
//            {
//                let post:NSDictionary = try JSONSerialization.jsonObject(with: receivedData! as Data,options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//
//                if post .isProxy()
//                {
//                    Constant.ConnectionFailAlert(ViewController: self)
//                }
//                else
//                {
//
//
//                    let Status:NSString=(post .value(forKey: "status") as AnyObject).value(forKey: "sucess") as! NSString
//
//                    if(Status .isEqual(to: "1"))
//                    {
//
//                        let AlertView = UIAlertController(title:"Ceres8", message:(post .value(forKey: "status") as AnyObject).value(forKey: "message") as? String, preferredStyle: .alert)
//
//                        let cancel:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
//                            AlertView.dismiss(animated: true, completion: nil)
//
//                            self.navigationController?.popViewController(animated: true)
//
//                        })
//
//                        AlertView.addAction(cancel)
//
//                        self.present(AlertView, animated: true, completion: nil)
//
//                    }
//                    else
//                    {
//                        Constant.AlertViewNew(Title: "Ceres8", Message:(post .value(forKey: "status") as AnyObject).value(forKey: "message") as! NSString , ViewController: self)
//                    }
//                }
//            }
//            catch
//            {
//             //   print("error trying to convert data to JSON")
//                Constant.ConnectionFailAlert(ViewController: self)
//
//                return
//            }
//
//        }
//        else
//        {
//            Constant.ConnectionFailAlert(ViewController:self)
//
//        }
//    }
    
    
    
    
    //    func gotResponse(data: AnyObject, forRequest tag: Int)
    //    {
    //        if(tag==58)
    //        {
    //            Constant.APPDELEGATE.hideLoadingHUD()
    //
    //            let Dic:NSDictionary=data as!NSDictionary
    //
    //            let Status:NSString=Dic .valueForKey("status")?.valueForKey("sucess") as! NSString
    //
    //            if(Status .isEqualToString("1"))
    //            {
    //
    //            }
    //            else
    //            {
    //                Constant.AlertViewNew("Ceres8", Message:Dic .valueForKey("status")?.valueForKey("message") as! NSString , ViewController: self)
    //
    //            }
    //        }
    //    }
    //    func failure(data: AnyObject, forRequest tag: Int)
    //    {
    //        if(tag==58)
    //        {
    //            Constant.APPDELEGATE.hideLoadingHUD()
    //            Constant.ConnectionFailAlert(self)
    //        }
    //    }
    //MARK:- Cancel Button Click
    
    @IBAction func CancelClick(sender: UIButton)
    {
        
        //self.AddTextField()
        self.HidePicker()
        self.resignKeyBoard()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- TextField Animations
    
    func AddTextField()
    {
        OtherTextField.isHidden=false
        lblTitleTeller.isHidden=false
        
        
        // OtherTextField.center.x += view.bounds.width
        //        UIView.animateWithDuration(1.5, delay: 0.5,
        //                                   usingSpringWithDamping: 0.3,
        //                                   initialSpringVelocity: 0.5,
        //                                   options: [], animations: {
        //
        //                                    self.OtherTextField.center.x += self.view.bounds.width
        //
        //                                 //   self.textFieldLeading.constant=40
        //            }, completion: nil)
    }
    
    func RemoveTextField()
    {
        OtherTextField.isHidden=true
        lblTitleTeller.isHidden=true
        //        OtherTextField.center.x -= view.bounds.width
        //
        //        UIView.animateWithDuration(1.5, delay: 0.5,
        //                                   usingSpringWithDamping: 0.3,
        //                                   initialSpringVelocity: 0.5,
        //                                   options: [], animations: {
        //                                    self.textFieldLeading.constant-=1000
        //
        //            }, completion: nil)
    }
    
    @IBAction func btn_dropdown_clicked(sender: AnyObject) {
        
        if viewForPicker.isHidden==true {
            
            viewForPicker.isHidden=false
        }
        else
        {
            viewForPicker.isHidden=true
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing( _ textField: UITextField)
    {
        self.view.removeGestureRecognizer(TapGesture2)
        
        TapGesture = UITapGestureRecognizer(target: self, action: #selector(self.resignKeyBoard))
        
        self.view.addGestureRecognizer(TapGesture)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        TapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.HidePicker))
        
        self.view.addGestureRecognizer(TapGesture2)
        
        self.view.removeGestureRecognizer(TapGesture)
        
    }
    
    @objc func resignKeyBoard()
    {
        OtherTextField.resignFirstResponder()
        
    }
    @objc func HidePicker()
    {
        
        self.viewForPicker.isHidden=true
    }
    
    
    
    
    
}
