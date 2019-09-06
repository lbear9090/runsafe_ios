//
//  Constant.swift
//  INTELLIMIND
//
//  Created by Hemant on 27/04/16.
//  Copyright © 2016 Hemant. All rights reserved.
//

import UIKit
class Constant: NSObject,UIActionSheetDelegate {
    
    static var AppName : String = "Runsafe"

    static var USERDEFAULT = UserDefaults.standard
    
    @available(iOS 9.0, *)
    static var APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    static var kScreenBounds     :   CGRect = UIScreen.main.bounds
    static var isiPhone_4       :   Bool   = 480 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_5       :   Bool   = 568 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_6       :   Bool   = 667 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_6_Plus  :   Bool   = 736 == UIScreen.main.bounds.size.height ? true:false
  
     static var TitleFont:UIFont = UIFont(name:"OpenSans-Bold", size: 18)!
    
    //MARK:- AlertViewController Macro
    static func InternetNewAlert(ViewController:UIViewController)
    {
        let AlertView = UIAlertController(title: AppName, message: "Please check and verify that you have Internet access.", preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Ok)
        
        ViewController.present(AlertView, animated: true, completion: nil)
    }
    
    static func FunctionalityAlert(ViewController:UIViewController)
    {
        let AlertView = UIAlertController(title: AppName, message: "This Functionality is under construction.", preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Ok)
        
        ViewController.present(AlertView, animated: true, completion: nil)
        
    }
    
    static func ConnectionFailAlert(ViewController:UIViewController)
    {
        let AlertView = UIAlertController(title: AppName, message: "Please Make a Connection And Try Again.", preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Ok)
        
        ViewController.present(AlertView, animated: true, completion: nil)
    }
    
    
    static func ServerBusyAlert(ViewController:UIViewController)
    {
        let AlertView = UIAlertController(title: AppName, message: "Our server is being updated at the moment.  We apologize for the inconvenience.  It should be up shortly.  Please try again later.", preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Ok)
        
        ViewController.present(AlertView, animated: true, completion: nil)
        
    }
    
    static func AlertViewNew(Title:NSString,Message:NSString,ViewController:UIViewController)
    {
        let AlertView = UIAlertController(title:Title as String, message:Message as String, preferredStyle: .alert)
        
        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Ok)
        
        ViewController.present(AlertView, animated: true, completion: nil)
        
    }
    
    static func Push_POP_to_ViewController(destinationVC:UIViewController,navigationsController :UINavigationController,isAnimated:Bool){
        var VCFound:Bool = false
        let viewControllers:NSArray = (navigationsController.viewControllers as NSArray)
        var indexofVC:NSInteger = 0
        for  vc  in viewControllers  {
            if (vc as AnyObject).nibName == (destinationVC.nibName){
                VCFound = true
                break
            }else{
                indexofVC += 1;
            }
        }
        if VCFound == true {
            navigationsController .popToViewController(viewControllers.object(at: indexofVC) as! UIViewController, animated: isAnimated)
        }else{
            navigationsController .pushViewController(destinationVC , animated: isAnimated)
        }
    }
    
    //MARK:- Toast Message Method
    static func showToastMessage(withTitle Title: String, message Message: String, in view: UIView, animation animate: Bool)
    {
        let hud=GIFProgressHUD .show(withTitle: Title, detailTitle: Message, addedTo: view, animated: animate)
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            hud?.titleFont = UIFont(name: "HelveticaNeue", size: 12)
        }
        else
        {
            hud?.titleFont = UIFont(name: "HelveticaNeue", size:22)
            hud?.detailTitleFont = UIFont(name: "HelveticaNeue", size: 18)
        }

       DispatchQueue.global().async(execute: {
        hud? .wait()
        DispatchQueue.main.async(execute: {() -> Void in
            hud? .hide(withAnimation: true)
        })
//        dispatch_async(dispatch_get_main_queue(),
//                       {
//                        hud? .hideWithAnimation(true)
//        });
        
       })
        
        
 //       dispatch_async(DispatchQueue.global(Int(QOS_CLASS_USER_INITIATED.rawValue), 0),
//                       {
//                        hud .wait()
//                        dispatch_async(dispatch_get_main_queue(),
//                            {
//                                hud .hideWithAnimation(true)
//                        });
//                  });
    }

}
