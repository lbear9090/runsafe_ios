//
//  AppDelegate.swift
//  Ceres8
//
//  Created by Lucky on 5/31/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import CoreLocation
import CoreTelephony
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import Contacts
import ContactsUI
import UserNotifications
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,WXApiDelegate,UNUserNotificationCenterDelegate
{
    
    var locationManager:CLLocationManager?
    
    var FacebookLoginManager:FBSDKLoginManager?
    
    var NotificationContent:AnyObject?
    
    var ReceiveNotification:Bool?
    
    var scence:WXScene?
    //  var iBeacon:Bool?
    var Notification:Bool?
    var SettingLocation:Bool?
    var FaceBookSharing:Bool?
    var WeChatSharing:Bool?
    var WhatsAppSharing:Bool?
    var LineSharing:Bool?
    
    var location:CLLocation?
    var window: UIWindow?
    
    var DeviceToken:NSString?
    
    var  CountryArray:NSMutableArray!
    
    var LocationEnable:Bool?
    
    //Bluetooth Mode Variable Nirman
    //    var centralManager: CBCentralManager?
    //    var peripherals: Array<CBPeripheral> = Array<CBPeripheral>()
    //    var UUID :CBUUID!
    //    var scanOptions: [String : AnyObject]?
    
    //var Country_code:NSString!
    var Country_name:NSString!
    // var Country_Image_Code:NSString!
    
    var HUD:MBProgressHUD=MBProgressHUD()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        ReceiveNotification=false
        
        self.registerForRemoteNotification()
        
        // registerForPushNotifications(application: application)
        
        
        if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) == nil
        {
            
            
            if (Constant.USERDEFAULT.array(forKey: "CustomMessageArray") != nil)
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
            //
            Constant.USERDEFAULT.setValue("I am out for run/walk, not feeling safe. I need you on the phone/help.", forKey: "CustomMessage")
            Constant.USERDEFAULT.synchronize()
        }
        
        
        if (Constant.USERDEFAULT.value(forKey: "BluetoothSwitch")) == nil
        {
            Constant.USERDEFAULT.setValue("false", forKey: "BluetoothSwitch")
            Constant.USERDEFAULT.synchronize()
        }
        
        
        self .parseJSON()
        scence=WXSceneSession
        self.LocationManagerSetup()
        
        SettingLocation=true
        FaceBookSharing=true
        WeChatSharing=true
        WhatsAppSharing=true
        LineSharing=true
        
        if (Constant.USERDEFAULT.value(forKey: "Notification")) == nil
        {
            Constant.USERDEFAULT.set(true, forKey: "Notification")
            Constant.USERDEFAULT.synchronize()
            Notification=Constant.USERDEFAULT.bool(forKey: "Notification")
        }
        else
        {
            Notification=Constant.USERDEFAULT.bool(forKey: "Notification")
        }
        
        // iBeacon=false
        
        
        FBSDKApplicationDelegate .sharedInstance() .application(application, didFinishLaunchingWithOptions:launchOptions)
        
        WXApi .registerApp("wxd930ea5d5a258f4f")
        
        FacebookLoginManager=FBSDKLoginManager()
        FacebookLoginManager?.logOut()
        
        //isLogin
        
       UIApplication.shared.applicationIconBadgeNumber = 0
        
        if Constant.USERDEFAULT.bool(forKey: "isLogin")==true
        {
            
            window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController")
            
            if (Constant.USERDEFAULT.object(forKey: "AllContact") == nil)
            {
                self.FetchContacts()
            }
        }
        
        return true
    }
    
    
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if (url.scheme!.hasPrefix("fb"))
        {
            return FBSDKApplicationDelegate .sharedInstance() .application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        }
        if (url.scheme == "we")
        {
            return WXApi .handleOpen(url as URL!, delegate: self)
        }
        return false
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    {
        if (url.scheme == "we")
        {
            return WXApi .handleOpen(url as URL!, delegate: self)
        }
        return false
        
    }
    
    //MARK:- Push Notification
    
    //MARK:- Push Notification
    func registerForRemoteNotification()
    {
        //        if #available(iOS 10.0, *)
        //        {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
                
                DispatchQueue.main.async(execute: {() -> Void in
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
        //        }
        //        else
        //        {
        //            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        //            UIApplication.shared.registerForRemoteNotifications()
        //        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        DeviceToken = deviceTokenString as NSString?
        
        print(deviceToken)
        
        print(deviceTokenString)
        
        //        Constant.USERDEFAULT .setValue(DeviceToken, forKey: Constant.kDeviceToken)
        //        Constant.USERDEFAULT.synchronize()
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        let mainaps:NSMutableDictionary=NSMutableDictionary(dictionary: userInfo)
        
        print(mainaps)
        
        let aps:NSDictionary=NSDictionary(dictionary: mainaps.value(forKey: "aps") as! Dictionary)
        
        print(aps)
        if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive
        {
            if Constant.USERDEFAULT.bool(forKey: "isLogin")==true
            {
                
                
                NotificationContent=nil
                NotificationContent=aps.value(forKey: "alert") as AnyObject
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                
            }
            else
            {
                
                var Code:NSString=(aps.value(forKey: "alert") as? String)! as NSString
                
                Code = Code .replacingOccurrences(of: "Runnermate :", with:"") as NSString
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                
                
                //  let alt:UIAlertView=UIAlertView(title: "Ceres8", message: Code as String, delegate: nil, cancelButtonTitle: "Ok")
                
                //   alt.show()
                
            }
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void)
    {
        
        
        
        if notification.request.identifier == "WeatherUpdate"
        {
            
        }
        else
        {
            
            let mainaps:NSMutableDictionary=NSMutableDictionary(dictionary: notification.request.content.userInfo)
            
            print(mainaps)
            
            let aps:NSDictionary=NSDictionary(dictionary: mainaps.value(forKey: "aps") as! Dictionary)
            
            if Constant.USERDEFAULT.bool(forKey: "isLogin")==true
            {
                
                
                NotificationContent=nil
                NotificationContent=aps.value(forKey: "alert") as AnyObject
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                
            }
            else
            {
                
                var Code:NSString=(aps.value(forKey: "alert") as? String)! as NSString
                
                Code = Code .replacingOccurrences(of: "Runnermate :", with:"") as NSString
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                
                
                //  let alt:UIAlertView=UIAlertView(title: "Ceres8", message: Code as String, delegate: nil, cancelButtonTitle: "Ok")
                
                //   alt.show()
                
            }
        }
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        completionHandler()
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        
        if response.notification.request.identifier == "WeatherUpdate"
        {
            
        }
        else
        {
            let mainaps:NSMutableDictionary=NSMutableDictionary(dictionary: response.notification.request.content.userInfo)
            print(mainaps)
            
            let aps:NSDictionary=NSDictionary(dictionary: mainaps.value(forKey: "aps") as! Dictionary)
            
            if Constant.USERDEFAULT.bool(forKey: "isLogin")==true
            {
                
                
                NotificationContent=nil
                
                NotificationContent=aps.value(forKey: "alert") as AnyObject
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
                
            }
            else
            {
                
                var Code:NSString=(aps.value(forKey: "alert") as? String)! as NSString
                
                Code = Code .replacingOccurrences(of: "Runnermate :", with:"") as NSString
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCode"), object: nil)
                
                
                //  let alt:UIAlertView=UIAlertView(title: "Ceres8", message: Code as String, delegate: nil, cancelButtonTitle: "Ok")
                
                //   alt.show()
                
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            DeviceToken = "3f24e65d8bffc916031d022674932561a229cff0"
        #endif
        
        print("Failed to register:", error)
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        FBSDKAppEvents .activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        FacebookLoginManager!.logOut()
        
        let cookies: HTTPCookieStorage = HTTPCookieStorage.shared
        
        let FBCookie=HTTPCookieStorage.shared.cookies(for: NSURL(string:"https://www.facebook.com/")! as URL)
        
        for cookie: HTTPCookie in FBCookie!
        {
            cookies.deleteCookie(cookie)
        }
    }
    
    //MARK:- MBProgressHud Delegate
    func showLoadingHUD(navigation: UIViewController)
    {
        
        if (self.HUD.superview == nil)
        {
            self.HUD = MBProgressHUD(view: navigation.view!)
            navigation.view!.addSubview(self.HUD)
            self.HUD.show(true)
        }
        else {
            
        }
    }
    
    func showLoadingHUD(navigation: UIViewController, withText text: String)
    {
        if (self.HUD.superview == nil)
        {
            self.HUD = MBProgressHUD(view: navigation.view!)
            self.HUD.labelText = text
            navigation.view!.addSubview(self.HUD)
            self.HUD.show(true)
        }
        else {
            
        }
    }
    
    func hideLoadingHUD()
    {
        self.HUD.removeFromSuperview()
    }
    
    
    //MARK:- CLLocation Manager Setup
    
    func LocationManagerSetup()
    {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
    }
    
    //MARK:- CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation])
    {
        location=manager.location!
        
        //        Constant.USERDEFAULT.setValue(location, forKey: "location")
        //        Constant.USERDEFAULT .synchronize()
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, e) -> Void in
            if e != nil
            {
                print("Error:  \(e!.localizedDescription)")
                
                self.LocationEnable=false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCountryCodeViaCurrentLocation"), object: nil)
            }
            else
            {
                let placemark = placemarks!.last! as CLPlacemark
                let userInfo =
                    [
                        "city":     placemark.locality ?? "",
                        "state":    placemark.administrativeArea ?? "",
                        "country":  placemark.country ?? "",
                        "Code":   placemark.postalCode ?? ""
                ]
                
                self.LocationEnable=true
                print("Location:  \(userInfo)")
                self.Country_name=placemark.country! as NSString
                
                Constant.USERDEFAULT.setValue(self.Country_name!, forKey: "Country_name")
                
                Constant.USERDEFAULT .synchronize()
                
                self.GetCountryCodeViaCountryName(Country: self.Country_name!)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCountryCodeViaCurrentLocation"), object: nil)
                
                
                if Constant.USERDEFAULT.bool(forKey: "isLogin")==true
                {
                    self.locationManager!.distanceFilter=1000;
                }
            }
        })
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let  Status:CLAuthorizationStatus=CLLocationManager .authorizationStatus()
        
        
        if (Status == .notDetermined || Status == .restricted || Status == .denied)
        {
            LocationEnable=false
            
        }
        else
        {
            
            LocationEnable=false
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForCountryCodeViaCurrentLocation"), object: nil)
        
    }
    
    func parseJSON()
    {
        
        let path = Bundle.main.path(forResource: "countries", ofType: "json")
        
        let jsonData:NSData = try! NSData(contentsOfFile: path!, options:.alwaysMapped)
        
        CountryArray = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableArray
        
    }
    
    
    func GetCountryCodeViaCountryName(Country:NSString)
    {
        
        for i in 0 ..< CountryArray.count
        {
            if (((CountryArray.object(at: i) as AnyObject).value(forKey: "name")! as AnyObject) .isEqual(Country as String))
            {
                Constant.USERDEFAULT .setValue((CountryArray.object(at: i) as AnyObject).value(forKey:"dial_code") as? NSString, forKey: "Country_code")
                
                Constant.USERDEFAULT .setValue((CountryArray.object(at: i) as AnyObject).value(forKey:"code") as? NSString, forKey: "Country_Image_Code")
                
                Constant.USERDEFAULT .synchronize()
                
            }
        }
    }
    
    func FetchContacts()
    {
        
        let contactStore = CNContactStore()
        let arySelectedContacts:NSMutableArray=NSMutableArray()
        let words2:NSMutableArray=NSMutableArray()
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus
        {
        case .authorized:
            
            DispatchQueue.global().async(execute: {
                do {
                    try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor,CNContactFamilyNameKey as CNKeyDescriptor])) {
                        (contact, cursor) -> Void in
                        
                        if (!contact.phoneNumbers.isEmpty)
                        {
                            arySelectedContacts.add(contact)
                        }
                    }
                }
                catch{
                    print("Handle the error please")
                }
                
                
                //  if self.contactTemp.phoneNumbers.count > 1
                //  {
                for i in 0 ..< arySelectedContacts.count
                {
                    let dictContact:NSMutableDictionary=NSMutableDictionary()
                    
                    if let actualNumber = (arySelectedContacts.object(at: i) as AnyObject).phoneNumbers.first?.value
                    {
                        //See if we can get A frist name
                        
                        if (arySelectedContacts.object(at:i) as AnyObject).givenName != ""
                        {
                            let Name:NSString=NSString(format: "%@ %@ %@",(arySelectedContacts.object(at: i) as AnyObject).givenName,(arySelectedContacts.object(at: i) as AnyObject).middleName,(arySelectedContacts.object(at: i) as AnyObject).familyName)
                            
                            print(Name)
                            
                            if actualNumber.isProxy()
                            {
                                
                            }
                            else
                            {
                                _ = actualNumber.stringValue
                                
                                for num in (arySelectedContacts.object(at: i) as AnyObject).phoneNumbers
                                {
                                    let numVal = num.value
                                    
                                    if num.label == CNLabelPhoneNumberMobile
                                    {
                                        if numVal.stringValue == ""
                                        {
                                            
                                        }
                                        else
                                        {
                                            let numStr:String=numVal.stringValue
                                            
                                            dictContact.setValue(Name, forKey: "name")
                                            
                                            dictContact.setValue(numStr, forKey: "number")
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        let dicTemp:NSMutableDictionary = dictContact as NSMutableDictionary
                        
                        if dicTemp["name"] != nil
                        {
                            print(dicTemp)
                            
                            words2.add(dicTemp)
                            
                        }
                    }
                }
                
                if (words2.count>0)
                {
                    Constant.USERDEFAULT.set(words2, forKey: "AllContact")
                    
                    Constant.USERDEFAULT.synchronize()
                }
                
            })
            
            //            dispatch_async(DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),{
            //                do {
            //                    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactMiddleNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey,CNContactFamilyNameKey])) {
            //                        (contact, cursor) -> Void in
            //
            //                        if (!contact.phoneNumbers.isEmpty)
            //                        {
            //                            arySelectedContacts.addObject(contact)
            //                        }
            //                    }
            //                }
            //                catch{
            //                    print("Handle the error please")
            //                }
            //
            //
            //                //  if self.contactTemp.phoneNumbers.count > 1
            //                //  {
            //                for i in 0 ..< arySelectedContacts.count
            //                {
            //                    let dictContact:NSMutableDictionary=NSMutableDictionary()
            //
            //                    if let actualNumber = arySelectedContacts.objectAtIndex(i).phoneNumbers.first?.value as? CNPhoneNumber
            //                    {
            //                        //See if we can get A frist name
            //
            //                        if arySelectedContacts.objectAtIndex(i).givenName != ""
            //                        {
            //                            let Name:NSString=NSString(format: "%@ %@ %@",arySelectedContacts.objectAtIndex(i).givenName,arySelectedContacts.objectAtIndex(i).middleName,arySelectedContacts.objectAtIndex(i).familyName)
            //
            //                            print(Name)
            //
            //                            if actualNumber.isProxy()
            //                            {
            //
            //                            }
            //                            else
            //                            {
            //                                _ = actualNumber.stringValue
            //
            //                                for num in arySelectedContacts.objectAtIndex(i).phoneNumbers
            //                                {
            //                                    let numVal = num.value as! CNPhoneNumber
            //
            //                                    if num.label == CNLabelPhoneNumberMobile
            //                                    {
            //                                        if numVal.stringValue == ""
            //                                        {
            //
            //                                        }
            //                                        else
            //                                        {
            //                                             let numStr:String=numVal.stringValue
            //
            //                                            dictContact.setValue(Name, forKey: "name")
            //
            //                                            dictContact.setValue(numStr, forKey: "number")
            //                                        }
            //                                    }
            //                                }
            //                            }
            //                        }
            //
            //
            //                        let dicTemp:NSMutableDictionary = dictContact as NSMutableDictionary
            //
            //                        if dicTemp["name"] != nil
            //                        {
            //                            print(dicTemp)
            //
            //                            words2.addObject(dicTemp)
            //
            //                        }
            //                    }
            //                }
            //
            //                if (words2.count>0)
            //                {
            //                    Constant.USERDEFAULT.setObject(words2, forKey: "AllContact")
            //
            //                    Constant.USERDEFAULT.synchronize()
            //                }
            //
            //            });
            
        case .denied, .notDetermined:
            contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access
                {
                    self.FetchContacts()
                }
                else
                {
                    //                if authorizationStatus == CNAuthorizationStatus.Denied {
                    //                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                        let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                    //                        self.showMessage(message)
                    //                    })
                    //                }
                }
            })
        default: break
        }
        
    }
    
    
}

