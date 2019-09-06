//
//  SupportClassFile.swift
//  Swift WebService
//
//  Created by Apple on 05/04/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import CoreLocation
class SupportClassFile: NSObject,UIScrollViewDelegate,NSLayoutManagerDelegate,CLLocationManagerDelegate
{
    
    
    // MARK: - Set Time Format With Date
    
    func setTimeFormatWithDate(date: String) -> String
    {
        //Date Formatter
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //Time Formatter
        let timeFormat: DateFormatter = DateFormatter()
        let Timezone: String = "\(date)"
        let fetch_date: NSDate = formatter.date(from: Timezone)! as NSDate
        timeFormat.dateFormat = "H:mm a"
        let formattedDate: String = "\(timeFormat.string(from: fetch_date as Date))"
        return formattedDate
    }
    
    // MARK: - Set Day Formate With Date
    
    func setDayFormatWithDate(date: String) -> String {
        //Date Formatter
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Timezone: String = "\(date)"
        let fetch_date: NSDate = formatter.date(from: Timezone)! as NSDate
        formatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate: String = "\(formatter.string(from: fetch_date as Date))"
        return formattedDate
    }
    
    // MARK: - Get AppVersion
    
    func appVersion() -> String
    {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    // MARK: - Get Build Name
    
    func build() -> String
    {
        return Bundle.main.object(forInfoDictionaryKey: String(kCFBundleVersionKey))as! String
    }
    
    //check and return if  version and build number are not same
    
    // MARK: - Get Version Of The Build
    
    func versionBuild() -> String
    {
        let version: String = self.appVersion()
        let build: String = self.build()
        var versionBuild: String = "v\(version)"
        if !(version == build) {
            versionBuild = "\(versionBuild)(\(build))"
        }
        return versionBuild
    }
    
    
    // path for either storing or retrieving image
    // MARK: - Get Image Path For Image that stored in document directory

    func getImagePathFor(imageName: String) -> String {
        
        var paths:[AnyObject]=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [AnyObject]
        
        let documentsDirectory: NSString = paths[0]as! NSString
        
        let temp_str:String=String(stringInterpolation: "/%@",imageName)
        
        let savedImagePath:NSString=documentsDirectory.appendingPathComponent(temp_str) as NSString
        
        return savedImagePath as String
    }
    
    
    // set date formatter
    // MARK: - Set Date Formater MM-dd-yy_HH:mm

    func dateFormatter() -> DateFormatter
    {
        let formatter:DateFormatter=DateFormatter()
        
        if formatter.isProxy()==false
        {
            formatter.dateFormat = "MM-dd-yy_HH:mm"
        }
        return formatter
    }
    
    
    // method to set day formated date from TimeStamp Date
    // MARK: - Set Date Formater dd-MM-yyyy

    func setDateFormat(date: String) -> String
    {
        //Date Formatter
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Timezone: String = "\(date)"
        let fetch_date: NSDate = formatter.date(from: Timezone)! as NSDate
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate: String = "\(formatter.string(from: fetch_date as Date))"
        return formattedDate
    }
    
    // MARK: - Set BorderColor To View

    func add_Border_Color_To(view: UIView, withColor color: UIColor)
    {
        view.layer.borderWidth = 1.0
        view.layer.borderColor = color.cgColor
    }
    
    //Make TextFieldRoundRect
    // MARK: - Make RoundRect TextField

    func MakeTextFieldRoundRect(txtField: UITextField) -> UITextField
    {
        
        txtField.layer.borderColor=UIColor.gray.cgColor
        txtField.layer.borderWidth = 1.0
        txtField.layer.cornerRadius = 10
        txtField.clipsToBounds = true
        return txtField
    }
    
    
    // MARK: - Make Mandatory TextField

    func MandatoryLabel(txtField: UITextField) -> UITextField
    {
        let lbl: UILabel = UILabel(frame: CGRect(x:txtField.frame.size.width - 20,y: 3,width: 20,height: 20))
        lbl.textColor = UIColor.red
        lbl.text = "*"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Helvetica Neue", size: 20)
        txtField.addSubview(lbl)
        return txtField
    }
    
    // MARK: - Make RoundRect Button

    func MakeButtonRoundRect(btn: UIButton) -> UIButton
    {
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        return btn
    }
    
    // MARK: - Make RoundRect TextView

    func MakeTextViewRoundRect(txtView: UITextView) -> UITextView
    {
        txtView.layer.borderColor = UIColor.gray.cgColor
        txtView.layer.borderWidth = 1.0
        txtView.layer.cornerRadius = 10
        txtView.clipsToBounds = true
        return txtView
    }
    
    // MARK: - Make RoundRect Label

    func MakeLabelRoundRect(lbl: UILabel) -> UILabel
    {
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        //   lbl.layer.masksToBounds = YES;
        return lbl
    }
    
    
    // MARK: - Validate Email String

    func validateEmailWithString(email: String) -> Bool {
        if ((email.characters.count > 0) == false) {
            return true
        }
        let emailRegex: String = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    // MARK: - Validate Number

    func validateNumber(number: String) -> Bool {
        if ((number.characters.count > 0) == false)
        {
            return true
        }
        let emailRegex: String = "^(?:[0-9]\\d*)(?:\\.\\d*)?$"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: number)
    }

    
    // MARK: - Remove Null From Html String

    func Remove_Null_From_String(str: String) -> String {
        var strResult: String? = nil
        let obj: NSObject = str as NSObject
        if (obj is NSNull) || (str == "(null)") || (str == "<null>") || str.characters.count <= 0 {
            strResult = ""
        }
        else
        {
            strResult = str
        }
        return strResult!
    }
    
    
    // MARK: - Get Current Date And Time

    func getCurrentDateandTime() -> String {
        let currentTime: NSDate = NSDate()
        var timeFormatter: DateFormatter
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr: String = timeFormatter.string(from: currentTime as Date)
        return dateStr
    }
    
    
    // MARK: - Add PlaceHolder Color And PlaceHolder in TextField

    func addTextFieldPlaceholderColor(textField: UITextField, withPlaceholder placeHolder: NSString)
    {
        var Placeholder=placeHolder
        
        if Placeholder.length == 0
        {
            Placeholder = ""
        }
        if textField.responds(to: #selector(setter: UITextField.attributedPlaceholder)) {
            let color: UIColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1)
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder as String, attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    
    
    // MARK: - Add Effect On TextField

    func Add_Textfield_Effect(textField: UITextField)
    {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .transitionFlipFromTop, animations: {() -> Void in
            textField.layer.shadowColor = UIColor.green.cgColor
            textField.layer.shadowOpacity = 1.0
            textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            textField.layer.shadowRadius = 15.0
            textField.layer.masksToBounds = false
            textField.layer.backgroundColor = UIColor.white.cgColor
            let path: UIBezierPath = UIBezierPath(rect: textField.bounds)
            textField.layer.shadowPath = path.cgPath
            let bounceAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position.y")
            bounceAnimation.duration = 0.1
            bounceAnimation.fromValue = Int(0)
            bounceAnimation.toValue = Int(-3)
            bounceAnimation.repeatCount = 1
            bounceAnimation.autoreverses = true
            bounceAnimation.fillMode = kCAFillModeForwards
            bounceAnimation.isRemovedOnCompletion = false
            bounceAnimation.isAdditive = true
            textField.layer.add(bounceAnimation, forKey: "bounceAnimation")
            }, completion: {(finished: Bool) -> Void in
                textField.layer.shadowColor = UIColor.clear.cgColor
                textField.layer.shadowOpacity = 0.0
                textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                textField.layer.shadowRadius = 0.5
                textField.layer.masksToBounds = false
                textField.layer.backgroundColor = UIColor.white.cgColor
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 1.0
                let path: UIBezierPath = UIBezierPath(rect: textField.bounds)
                textField.layer.shadowPath = path.cgPath
                textField.layer.removeAnimation(forKey: "bounceAnimation")
        })
    }
    
    // MARK: - Remove Effect On TextField

    func Remove_Textfield_Effect(textField: UITextField)
    {
        textField.layer.shadowColor = UIColor.clear.cgColor
        textField.layer.shadowOpacity = 0.0
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        textField.layer.shadowRadius = 0.0
        
        textField.layer.masksToBounds = false
        textField.layer.backgroundColor = UIColor.clear.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0.0
        let path: UIBezierPath = UIBezierPath(rect: textField.bounds)
        textField.layer.shadowPath = path.cgPath
    }
    
    
    // MARK: - Check For Location Service is Enabled

    func checkLocationServicesEnabled() -> Bool
    {
        if (CLLocationManager.locationServicesEnabled() == false) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
}
