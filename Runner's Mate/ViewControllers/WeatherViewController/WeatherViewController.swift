//
//  WeatherViewController.swift
//  Runners Mate
//
//  Created by mac on 10/30/17.
//  Copyright © 2017 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications

class WeatherViewController: UIViewController,CLLocationManagerDelegate,FeedPhotoViewDelegate
{
    
    var popUpPhotoViewer: KLCPopup?
    
    func closeFeedPhotoViewer()
    {
        //closed here
        print("closed here PhotoViewer")
        Constant.USERDEFAULT .set(true, forKey: "weathervisited")
        Constant.USERDEFAULT.synchronize()

        
    }
    
    
    func closeFeedPhotoViewerAfterDeleteFeed()
    {
        //closed here
        print("closed here AfterDeleteFeed")

    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.descriptionabel.textColor = UIColor.black

        // Do any additional setup after loading the view.
    }
    
    var locationManager:CLLocationManager?
 
    var CurrentLocation=CLLocation()
    
    
    
    let AppidStr = "86c793e72e9295059f6d19c37c010534"
    
    var lat = CLLocationDegrees()
    
    var long = CLLocationDegrees()
   
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var descriptionabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var UVIndexLabel: UILabel!

    @IBOutlet var UVIndexStausLbl: UILabel!
    
    var PushTimer=Timer()
    
    
    
    

    override func viewWillAppear(_ animated: Bool)
    {
        let todayDate = Date() //Get todays date
        
        let dateFormatter = DateFormatter()  // here we create NSDateFormatter object for change the Format of date.
        
        dateFormatter.dateFormat = "EEEE, d LLLL"   //Here we can set the format which we need  dd/MM/yyyy
        
        let convertedDateString: String = dateFormatter.string(from: todayDate)     // Here convert date in NSString
        
        print("Today formatted date is \(convertedDateString)")
        
        self.DateLabel.text = "\(convertedDateString)"

        ScrollView.isScrollEnabled = true

        locationManager = CLLocationManager()
        
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
        
        initNotificationSetupCheck()
        
        runTimer()
        
        
        
       
        
        
         if Constant.USERDEFAULT.bool(forKey: "weathervisited")==false
         {
                toturial()
         }
         else
         {
            
         }
        
    }
    
    
    func toturial()
    {
        var topLevelObjects = [Any]()
        
        topLevelObjects = Bundle.main.loadNibNamed("FeedPhotoView", owner: nil, options: nil) ?? [Any]()
        
        let popView = topLevelObjects[0] as? FeedPhotoView
        
        popView?.delegate = self
        
        popView?.photoImageView.image = UIImage(named: "weatherOverlay")
        
        let layout: KLCPopupLayout = KLCPopupLayoutMake(.center, .bottom)
        
        popUpPhotoViewer = KLCPopup(contentView: popView, showType: .growIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: true)
 
        popView?.frame = view.frame
        
        popUpPhotoViewer?.show(with: layout)
        
        
    }
   
    
    
    func runTimer()
    {
        
        PushTimer = Timer.scheduledTimer(timeInterval: 30, target: self,   selector: (#selector(self.invalidateTimerAndPush)), userInfo: nil, repeats: false)
    }
    
    @objc func invalidateTimerAndPush()
    {
        
        popUpPhotoViewer?.dismiss(true)
        
       
        
        Constant.USERDEFAULT .set(true, forKey: "weathervisited")
        Constant.USERDEFAULT.synchronize()
        PushTimer.invalidate()
        
        if (Constant.USERDEFAULT.object(forKey: "AllContact") == nil)
        {
            Constant.APPDELEGATE.FetchContacts()
        }
        
        Constant.USERDEFAULT .set(true, forKey: "isLogin")
        Constant.USERDEFAULT .synchronize()
        Constant.APPDELEGATE.window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        let notification = UNMutableNotificationContent()
        
        notification.title = "Runsafe"
        
        notification.subtitle = "Check out updated weather and UV index. Don’t forget to apply SPF 30+ sunscreen when you head out."
        
       // notification.body = "I need to tell you something, but first read this."
        
        var date = DateComponents()
        date.hour = 8
        date.minute = 30
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
       // let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)

       // notificationTrigger.repeatInterval = NSCalendar.Unit.day

        //notificationTrigger.nextTriggerDate()

        let request = UNNotificationRequest(identifier: "WeatherUpdate", content: notification, trigger: notificationTrigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func initNotificationSetupCheck()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success
            {
                print("Permission Granted")
            } else
            {
                print("There was a problem!")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation])
    {
        CurrentLocation=locations[0]
        
        locationManager?.stopUpdatingLocation()
        
        getWeatherFromOpenMap()
        
        getUIIndex()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
    }
    
    func getWeatherFromOpenMap()
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
        let Latt = String(format: "%f", CurrentLocation.coordinate.latitude)
        
        let longg = String(format: "%f", CurrentLocation.coordinate.longitude)
        
        
        let params:[String : String] = ["lat":Latt,"lon": longg,"units":"metric","cnt":"7","appid":"86c793e72e9295059f6d19c37c010534"]
        
        Alamofire.request(NSURL(string: "http://api.openweathermap.org/data/2.5/weather?")! as URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                var dict = JSON(response.result.value as Any ).dictionaryValue
                
                let Status = dict["cod"]?.stringValue
                
                if(Status?.isEqual("200"))!
                {
                    let  Temprature = dict["main"]?.dictionaryValue["temp"]?.doubleValue
                    
                    let FerenHitTemp=self.temperatureInFahrenheit(temperature: Temprature!)
                    
                    print(FerenHitTemp)

                    let FerenHitFinal:String = String(format:"%.0f", FerenHitTemp)
                    
                    print(FerenHitFinal)

                    
                    self.temperatureLabel.text = FerenHitFinal
                }
                else
                {
                     self.temperatureLabel.text = " "
                    
                    //                    MMProgressHUD.dismiss()
                    //                    var Message = "\(responseObject["message"])"
                    //                    MMProgressHUD.dismissWithError(Message, title: "AA Adventure")
                }
                
                break
                
            case .failure(_):
                
                
                break
                
            }
        }
    }
    @IBAction func CloseButton(_ sender: UIButton) {
        
      
        invalidateTimerAndPush()
    }
    
    func getUIIndex()
    {
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
        let Latt = String(format: "%f", CurrentLocation.coordinate.latitude)
        
        let longg = String(format: "%f", CurrentLocation.coordinate.longitude)
        
        let params:[String : String] = ["lat": Latt ,"lon": longg,"appid":"86c793e72e9295059f6d19c37c010534"]
        
        Alamofire.request(NSURL(string: "http://api.openweathermap.org/data/2.5/uvi?")! as URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                var ResponseDic = JSON(response.result.value as Any ).dictionaryValue

                let UVIndexDouble = ResponseDic["value"]?.doubleValue.rounded(.toNearestOrAwayFromZero)
                
                let UVIndex:String = String(format:"%.0f", UVIndexDouble!)

                self.UVIndexLabel.text = UVIndex
                
                let UVINT = Int(UVIndex)
                
                self.getMessageBasedOnUVIndex(_iNDEX: UVINT!)
                
                break
                
            case .failure(_):
                
                self.UVIndexLabel.text = "0"
                break
                
            }
        }
    }
    
    //MARK:- Get Messages Based on UVIndex
    
    func getMessageBasedOnUVIndex(_iNDEX:Int)
    {
           self.descriptionabel.textColor = UIColor.black
        
        if _iNDEX >= 0 && _iNDEX <= 2
        {
            //For the low UVIndex
           
            self.descriptionabel.text="Wear Sunglasses, Apply Sunscreen SPF 30+"
           // self.descriptionabel.textColor = UIColor.green
            UVIndexStausLbl.text="(Low)"
//            self.UVIndexStausLbl.textColor = UIColor.green
        }
        else if _iNDEX >= 3 && _iNDEX <= 5
        {
            //For the Moderate UVIndex
            
            self.descriptionabel.text="Wear protective clothing,Apply Sunscreen SPF 30+ every 2 hrs"
         //   self.descriptionabel.textColor = UIColor.yellow
              UVIndexStausLbl.text="(Moderate)"
//            self.UVIndexStausLbl.textColor = UIColor.yellow
        }
        else if _iNDEX >= 6 && _iNDEX <= 7
        {
            //For the High UVIndex
           
            self.descriptionabel.text="Avoid outdoors from 10am-4pm, Wear sunglass, protective clothing.Apply sunscreen SPF 30+ every 2 hrs "
          //  self.descriptionabel.textColor = UIColor.orange
              UVIndexStausLbl.text="(High)"
//            self.UVIndexStausLbl.textColor = UIColor.orange
        }
        else if _iNDEX >= 8 && _iNDEX <= 10
        {
            //For the Very High UVIndex
           
            self.descriptionabel.text="Avoid outdoors from 10am-4pm, Wear sunglass, protective clothing.Apply sunscreen SPF 30+ every 2 hrs "
           // self.descriptionabel.textColor = UIColor.red
              UVIndexStausLbl.text="(Very High)"
//            self.UVIndexStausLbl.textColor = UIColor.red
        }
        else if _iNDEX >= 11
        {
            //For the Extreme UVIndex
           
            self.descriptionabel.text="Avoid outdoors from 10am-4pm, Wear sunglass, protective clothing.Apply sunscreen SPF 30+ every 2 hrs "
            //self.descriptionabel.textColor = UIColor.purple
              UVIndexStausLbl.text="(Extreme)"
//            self.UVIndexStausLbl.textColor = UIColor.purple
        }
        
        self.descriptionabel.textColor = UIColor.black
    }
    
    func temperatureInFahrenheit(temperature: Double) -> Double {
        let fahrenheitTemperature = temperature * 9 / 5 + 32
        return fahrenheitTemperature
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

