//
//  StringExtentions.swift
//  INTELLIMIND
//
//  Created by Hemant on 27/04/16.
//  Copyright © 2016 Hemant. All rights reserved.
//

import Foundation

extension String{

    func  trim() -> String{
      //  return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func isEmptyString() -> Bool{
        if self.characters.count == 0{
            return true
        }
        else if trim().characters.count == 0{
            return true
        }
        else{
            return false
        }
    }
    func isPasswordStrLengthSmall() -> Bool
    {
        if self.trimmingCharacters(in: NSCharacterSet.whitespaces).characters.count == 0{
            return true
        }else if self.characters.count == 0{
            return true
        }else if self.characters.count < 8{
            return true
        }else{
            return false
        }
    }
}
extension String {
    var asDate:NSDate! {
        let styler = DateFormatter()
        styler.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        return styler.date(from: self)! as NSDate
    }
    func asDateFormattedWith(format:String) -> NSDate! {
        let styler = DateFormatter()
        styler.dateFormat = format
        return styler.date(from: self)! as NSDate
    }
    
}

extension NSDate {
    var formatted:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self as Date)
    }
    func formattedWith(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
}

extension NSDate {
    var Time:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self as Date)
    }
    func timeformattedWith(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
}

//extension UIImage
//{
//    func toBase64() -> String{
//        let imageData = UIImagePNGRepresentation(self)!
//        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//    }
//}
