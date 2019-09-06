//
//  HomeViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/9/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import CoreTelephony
import Foundation
import Alamofire
import SwiftyJSON


let directions = Directions(accessToken: "pk.eyJ1Ijoic2FuayIsImEiOiJjaXBzOGRzczIwMmxwaDJucjZjeGF6N3NyIn0.0x08kXfv47JT2iGnkScofA")


class HomeViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate,UtilityDelegate,UIActionSheetDelegate,WXApiDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,FeedPhotoViewDelegate
{
    
    var popUpPhotoViewer: KLCPopup?
    func closeFeedPhotoViewer() {
      
        print("closed here PhotoViewer")
        Constant.USERDEFAULT .set(true, forKey: "mapvisited")
        Constant.USERDEFAULT.synchronize()
    }
    
    func closeFeedPhotoViewerAfterDeleteFeed() {
        print("closed here AfterDeleteFeed")
    }
    
    //variable declare-:
    
    @IBOutlet var Map: MGLMapView!
    
    var receivedData:NSMutableData?
    
    @IBOutlet var imgHeaderOthers: UIImageView!
    
    @IBOutlet var imgHeader: UIImageView!
    
    var up:Bool=true
    
    @IBOutlet var viewInMainMenuView: UIView!
    
    @IBOutlet var btnBluetooth: UIButton!
    
    var TapGesture:UILongPressGestureRecognizer?
    @IBOutlet var lblSelectCrimeType: UILabel!
    
    var Util:UtilityClass=UtilityClass()
    
    @IBOutlet var viewPinDetial: UIView!
    
    @IBOutlet var imgHeaderPinDetail: UIImageView!
    
    @IBOutlet var lblCommentPinDetail: UILabel!
    
    @IBOutlet var lblRecordsPinDetail: UILabel!
    
    @IBOutlet var lblYearsPinDetail: UILabel!
    var Outdoors:UIAlertAction?
    var Streets:UIAlertAction?
    var polyLineRef:AnyObject?
    var pinRef:MGLAnnotation?
    var routeLine:MGLPolyline?
    var point:MGLAnnotation?
    @objc var pointFromNotification:MGLAnnotation?
    @IBOutlet var viewPinDetailTop: NSLayoutConstraint!
    @IBOutlet var viewPolylineDetailBottom: NSLayoutConstraint!
    
    @IBOutlet var viewBackgroundBottom: NSLayoutConstraint!
    
    @IBOutlet var viewBackgroundTop: NSLayoutConstraint!
    
    
    
    @IBOutlet var viewPolylineDetail: UIView!
    
    
    
    @IBOutlet var btnUpDwnOfPolylineDetail: UIButton!
    
    @IBOutlet var btnStopPolyLineDetail: UIButton!
    
    @IBOutlet var btnClosePolylineDetail: UIButton!
    
    @IBOutlet var lblTimePolylineDetail: UILabel!
    
    @IBOutlet var lblAddressPolylineDetail: UILabel!
    
    
    @IBOutlet var imgCallBackGround: UIImageView!
    
    var message:String?
    var strCategory:String?
    
    var beaconRegion: CLBeaconRegion!
    var lastProximity:CLProximity?
    
    @IBOutlet var txtViewComments: UITextView!
    
    @IBOutlet var viewOtherSelection: UIView!
    @IBOutlet var lblPoorRoads: UILabel!
    
    @IBOutlet var lblUnsafeNeighbourhd: UILabel!
    
    @IBOutlet var lblPoorLighting: UILabel!
    
    @IBOutlet var NeighbourBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var OtherBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var viewNeighbourTop: NSLayoutConstraint!
    
    @IBOutlet var viewInnerTop: NSLayoutConstraint!
    
    @IBOutlet var viewInnerBottom: NSLayoutConstraint!
    
    @IBOutlet var viewSocialShare: UIView!
    
    @IBOutlet var viewSocialShareTop: NSLayoutConstraint!
    
    
    @IBOutlet var viewOtherTop: NSLayoutConstraint!
    
    
    @IBOutlet var viewSocialShareBottom: NSLayoutConstraint!
    
    
    @IBOutlet var btnCloseWidth: NSLayoutConstraint!
    
    @IBOutlet var btnCloseBottom: NSLayoutConstraint!
    
    @IBOutlet var btnCloseHeight: NSLayoutConstraint!
    
    
    @IBOutlet var btnCloseCrimeWidth: NSLayoutConstraint!
    
    @IBOutlet var btnCloseCrimeHeight: NSLayoutConstraint!
    
    @IBOutlet var btnCloseCrimeBottom: NSLayoutConstraint!
    
    @IBOutlet var viewBlurMenuTop: NSLayoutConstraint!
    
    @IBOutlet var viewBlurMenuBottom: NSLayoutConstraint!
    
    @IBOutlet var btnCloseMainViewHeight: NSLayoutConstraint!
    
    @IBOutlet var btnBackCrimeHeight: NSLayoutConstraint!
    
    @IBOutlet var btnCloseSocialHeight: NSLayoutConstraint!
    
    var pickerDataSoruce=NSMutableArray()
    
    var Robbery: NSMutableArray? = []
    
    var Assault:NSMutableArray? = []
    var Arson:NSMutableArray? = []
    var Rape:NSMutableArray? = []
    var Violet_Crime_Murder:NSMutableArray? = []
    var Poor_Roads:NSMutableArray? = []
    var Poor_Lighting :NSMutableArray? = []
    var Unsafe_Neighbourhoods:NSMutableArray? = []
    var aryOther:NSMutableArray? = []
    
    var img:UIImage?
    var strPassCrime:String=""
    
    //    var userInfo:NSDictionary?
    
    var tappedGesture:UITapGestureRecognizer!
    var tappedGesture2:UITapGestureRecognizer!
    @IBOutlet var btnBlurMenu: UIButton!
    @IBOutlet var viewBlurMenu: FXBlurView!
    
    @IBOutlet var Emergencylbl: UILabel!
    
    //  @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var viewForPicker: UIView!
    
    @IBOutlet var viewInnerMain: UIView!
    @IBOutlet var viewForBackground: UIView!
    
    @IBOutlet var viewMainViewOfMenu: UIView!
    
    @IBOutlet var imgPoorRoadsSel: UIImageView!
    
    @IBOutlet var lblCrimeTitleTypeOS: UILabel!
    @IBOutlet var imgNeighbourhdSel: UIImageView!
    
    @IBOutlet var imgPoorLightSel: UIImageView!
    
    @IBOutlet var txtViewCommentOS: UITextView!
    
    @IBOutlet var viewNeighbourSelection: UIView!
    @IBOutlet var Emlbl_left: NSLayoutConstraint!
    
    @IBOutlet var ShareTop: NSLayoutConstraint!
    
    @IBOutlet var lblSelectedRedWidth: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    var PoliceNumber:NSString?
    @IBOutlet var lblSeletedRed: UILabel!
    
    @IBOutlet var CountryImage: UIImageView!
    var NewUpdatedLocation = CLLocation()
    
    var tempColor:UIColor!
    @IBOutlet var CallButton: UIButton!
    var isHidden:Bool = false
    var isNeighbour:Bool = false
    var dic=NSMutableDictionary()
    
    //MARK:- View DidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //-------------latest Main menu change------
        
        viewInMainMenuView.layer.borderColor=UIColor(red: 221/255, green:221/255, blue:221/255, alpha:1).cgColor
        
        
        
        
        //-------------latest Main menu change------
        
        txtViewComments.delegate=self
        
        txtViewCommentOS.delegate=self
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
        setCloseButton()
        
        self.view .layoutIfNeeded()
        
        self.viewBlurMenu.frame = CGRect(x:self.viewBlurMenu.frame.origin.x,y: -1000, width:self.viewBlurMenu.frame.size.width, height:self.viewBlurMenu.frame.size.height)
        viewBlurMenu.isHidden=false
        viewBlurMenu.isBlurEnabled=true
        viewBlurMenu.blurRadius=20
        viewForBackground.alpha=0.75
        
        
        self.view.bringSubview(toFront: viewBlurMenu)
        self.view.bringSubview(toFront: viewPolylineDetail)
        
        Map .addSubview(btnBlurMenu)
        Map .bringSubview(toFront: btnBlurMenu)
        
        Map .addSubview(viewPolylineDetail)
        
        
        let beaconUUID:NSUUID = NSUUID (uuidString: "EBEFD083-70A2-47C8-9837-E7B5634DF524")!
        
        let regionIdentifier: String = "us.iBeaconModules"
        
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID as UUID, identifier: regionIdentifier)
        
        
        
        Util.delegate=self
        
        Map.compassView.isHidden=true
        
        
        var Imagecode = String()
        
        Imagecode = (Constant.USERDEFAULT.value(forKey: "Country_Image_Code")as? String)!
        
        Imagecode = (Imagecode.appending(".png") ) as String
        
        
        CountryImage.image=UIImage(named:Imagecode as String)
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100.0; // detect when I move 100 meters
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager .startMonitoringSignificantLocationChanges()
        
        
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            self.locationManager .startMonitoring(for: beaconRegion)
            self.locationManager .startRangingBeacons(in: beaconRegion)
            
            self.locationManager.startUpdatingLocation()
            
            Map.showsUserLocation=true
            
            
        }
        else
        {
            
            self.locationManager .stopMonitoring(for: beaconRegion)
            self.locationManager .stopRangingBeacons(in: beaconRegion)
            
            self.locationManager.stopUpdatingLocation()
            Map.showsUserLocation=false
        }
        
        Map.attributionButton.isHidden=true
        Map.logoView.isHidden=true
        Map.isZoomEnabled=true
        
        Map .setZoomLevel(5.0, animated: true)
        Map.userTrackingMode = .follow
        
        pickerDataSoruce = ["Robbery","Assault","Arson","Rape","Violet Crime Murder","Poor Roads","Poor Lighting","Unsafe Neighborhoods"]
        
        
        TapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation))
        
        self.Map.addGestureRecognizer(TapGesture!)
        
        lblAddressPolylineDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblAddressPolylineDetail.numberOfLines = 0
        lblAddressPolylineDetail.sizeToFit()
        viewPolylineDetail.layer.borderColor=UIColor.white.cgColor
        viewPolylineDetail.layer.borderWidth=1
        
    }
    
    
    
    func setCloseButton()
    {
        
        if Constant.isiPhone_4
        {
            self.view .layoutIfNeeded()
            btnCloseMainViewHeight.constant=35
            btnBackCrimeHeight.constant=35
            btnCloseSocialHeight.constant=35
            
        }
        else if Constant.isiPhone_5
        {
            self.view .layoutIfNeeded()
            btnCloseMainViewHeight.constant=40
            btnBackCrimeHeight.constant=40
            btnCloseSocialHeight.constant=40
            
            
            
        }
        else
        {
            self.view .layoutIfNeeded()
            btnCloseMainViewHeight.constant=50
            btnBackCrimeHeight.constant=50
            btnCloseSocialHeight.constant=50
            
        }
        self.view .layoutIfNeeded()
        
    }
    //MARK:- ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        if  Constant.APPDELEGATE.SettingLocation==true
            
        {
            self.locationManager.startUpdatingLocation()
            Map.showsUserLocation=true
        }
    }
    
   
    func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    func prefersStatusBarHidden() -> Bool {
        return isHidden
    }
    
    
    func tweakOtherViewUp()
    {
        lblSelectCrimeType.isHidden=true
        UIView.animate(withDuration: 0.2, animations: {
            self.viewOtherTop.constant = -130
            self.OtherBottomConstraint.constant = 111
            self.view.layoutIfNeeded()
            
        })
    }
    
    func tweakOtherViewDown()
    {
        lblSelectCrimeType.isHidden=false
        UIView.animate(withDuration: 0.1, animations: {
            self.viewOtherTop.constant = 19
            self.OtherBottomConstraint.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    
    
    func tweakNeighbourViewUp()
    {
        lblSelectCrimeType.isHidden=true
        UIView.animate(withDuration: 0.2, animations: {
            self.viewNeighbourTop.constant = -150
            self.NeighbourBottomConstraint.constant = 131
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
    }
    
    func tweakNeighbourViewDown()
    {
        lblSelectCrimeType.isHidden=false
        UIView.animate(withDuration: 0.1, animations: {
            self.viewNeighbourTop.constant = 19
            self.NeighbourBottomConstraint.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView==txtViewComments
        {
            self.tweakNeighbourViewUp()
        }
        else
        {
            self.tweakOtherViewUp()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if textView==txtViewComments
            {
                self.tweakNeighbourViewDown()
                
            }
            else
            {
                self.tweakOtherViewDown()
            }
            
            return false
        }
        return true
    }
    
    func SetUpInnerView()
    {
        viewInnerMain.isHidden=false
        viewNeighbourSelection.isHidden=true
        //  viewOtherSelection.hidden=true
        viewMainViewOfMenu.isHidden=true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewInnerTop.constant = 19
            self.viewInnerBottom.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
            
            
        })
        
    }
    func animateInnerViewDown()
    {
        
        viewInnerMain.isHidden=false
        viewNeighbourSelection.isHidden=true
        viewOtherSelection.isHidden=true
        viewMainViewOfMenu.isHidden=true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewInnerTop.constant = 1024
            self.viewInnerBottom.constant = -1024
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
            
        })
        
        
        
        
    }
    func setUpMainView()
    {
        viewForBackground.isHidden=false
        viewBlurMenu.isHidden=false
        viewInnerMain.isHidden=true
        viewNeighbourSelection.isHidden=true
        viewOtherSelection.isHidden=true
        viewMainViewOfMenu.isHidden=false
        
        
    }
    func setUpSocialShare()
    {
        lblSelectCrimeType.text="Social Sharing"
        viewForBackground.isHidden=false
        viewBlurMenu.isHidden=false
        
        viewInnerMain.isHidden=true
        
        viewNeighbourSelection.isHidden=true
        viewOtherSelection.isHidden=true
        viewMainViewOfMenu.isHidden=true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewSocialShareTop.constant = 19
            self.viewSocialShareBottom.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
        
        
    }
    func animateSocialDown()
    {
        self.lblSelectCrimeType.text="Select Crime Type"
        UIView.animate(withDuration: 0.5, animations: {
            self.viewSocialShareTop.constant = 1024
            self.viewSocialShareBottom.constant = -1024
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
            
        })
        
    }
    
    
    func HideMainView()
    {
        
        viewInnerMain.isHidden=true
        viewNeighbourSelection.isHidden=true
        viewOtherSelection.isHidden=true
        viewMainViewOfMenu.isHidden=true
        
        
    }
    
    func hidePinmenu()
    {
        self.animateInnerViewDown()
        self.animateNeighbourDown()
        self.viewForBackground.isHidden=true
        self.viewInnerMain.isHidden=true
        self.viewBlurMenu.isHidden=true
        
    }
    
    func SetUpNeighbourhoodView()
    {
        if #available(iOS 10.0, *) {
            txtViewComments.layer.borderColor = UIColor(displayP3Red: 0.8666, green: 0.8666, blue: 0.8666, alpha: 1.0).cgColor
        } else {
            // Fallback on earlier versions
            // txtViewComments.layer.borderColor = UIColor (colorLiteralRed: 0.8666, green: 0.8666, blue: 0.8666, alpha: 1.0).cgColor
        }
        viewInnerMain.isHidden=true
        viewMainViewOfMenu.isHidden=true
        txtViewComments.layer.borderWidth = 1.0
        
        txtViewComments.layer.cornerRadius = 5.0
        
        viewNeighbourSelection.isHidden = false
        viewOtherSelection.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewNeighbourTop.constant = 19
            self.NeighbourBottomConstraint.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    func SetUpOtherView()
    {
        viewInnerMain.isHidden=true
        viewMainViewOfMenu.isHidden=true
        
        if #available(iOS 10.0, *) {
            txtViewCommentOS.layer.borderColor = UIColor(displayP3Red: 0.8666, green: 0.8666, blue: 0.8666, alpha: 1.0).cgColor
        } else {
            // Fallback on earlier versions
        }
        
        txtViewCommentOS.layer.borderWidth = 1.0
        txtViewCommentOS.layer.cornerRadius = 5.0
        
        viewNeighbourSelection.isHidden = true
        viewOtherSelection.isHidden = false
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewOtherTop.constant = 19
            self.OtherBottomConstraint.constant = 0
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
        
        
    }
    
    
    func replaceTopConstraintOnView(view: UIView, withConstant constant: Float)
    {
        
    }
    
    func animateConstraints()
    {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.view!.layoutIfNeeded()
        })
    }
    
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        
        Constant.USERDEFAULT .set(true, forKey: "mapvisited")
        Constant.USERDEFAULT.synchronize()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    //MARK:- ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
        
        if  Constant.APPDELEGATE.ReceiveNotification==true
        {
            
            // self.pointFromNotification
            
        }
        else
        {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setter: self.pointFromNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
        
        imgPoorRoadsSel.isHidden=true
        imgPoorLightSel.isHidden=true
        imgNeighbourhdSel.isHidden=true
        self.Map.isPitchEnabled=false
     
        
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            
            
            DispatchQueue.global().async(execute: {
                self.locationManager .startMonitoring(for: self.beaconRegion)
                self.locationManager .startRangingBeacons(in: self.beaconRegion)
                
               
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.locationManager.startUpdatingLocation()
                    self.WebServiceCallForAnnotationsPloatting()
                    
                })
                
            })
          
            
            Map.showsUserLocation=true
            
            
        }
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.font : Constant.TitleFont]
        
        if Constant.isiPhone_6 || Constant.isiPhone_6_Plus
        {
            Emergencylbl.font=UIFont(name:"OpenSans" , size: 12)
        }
        else if(Constant.isiPhone_5 || Constant.isiPhone_4)
        {
            Emergencylbl.font=UIFont(name:"OpenSans" , size: 12)
        }
        
        if Constant.USERDEFAULT.bool(forKey: "mapvisited")==false
        {
            maptoturial()
        }
        else
        {
            
        }
        
       
        
    }
    // MARK: - tutorial screen code
    func maptoturial()
    {
        var topLevelObjects = [Any]()
        topLevelObjects = Bundle.main.loadNibNamed("FeedPhotoView", owner: nil, options: nil) ?? [Any]()
        
        let popView = topLevelObjects[0] as? FeedPhotoView
        
        popView?.delegate = self
        
        popView?.photoImageView.image = UIImage(named: "mapOverlay")
        
        let layout: KLCPopupLayout = KLCPopupLayoutMake(.center, .bottom)
        
        popUpPhotoViewer = KLCPopup(contentView: popView, showType: .growIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: true)
        
        popView?.frame = view.frame
        
        
        
        popUpPhotoViewer?.show(with: layout)
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Tap Gesture Recognizer method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self)
        {
            if touch.view! .isKind(of: MGLPointAnnotation.self)
            {
                return false
            }
        }
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self)
        {
            if touch.view! .isKind(of: UIButton.self)
            {
                return false
            }
            else
            {
                if viewPinDetailTop.constant==0 {
                    self.hidePinDetail()
                    self.hidePinmenu()
                    
                }
                if self.viewPolylineDetailBottom.constant == 0
                {
                    
                    self.hidePolyLineDetail()
                    
                    if up==true
                    {
                        up=false
                    }
                    else
                    {
                        up=true
                    }
                }
                
                return true
            }
        }
        
        return true
    }
    
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began
        {
            let touchPoint = gestureRecognizer.location(in: Map)
            
            let newCoordinates = Map.convert(touchPoint, toCoordinateFrom: Map)
            
            if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
            {
                Constant.InternetNewAlert(ViewController: self)
                return
            }
            
            point = NewAnnotation(title: "Destination", subtitle: "Other", coordinate: CLLocationCoordinate2D(latitude:newCoordinates.latitude,longitude: newCoordinates.longitude), image:UIImage(named: "finish")! , reuseIdentifier:"other")
            
            
            if self.polyLineRef != nil
            {
                let poly2:MGLAnnotation=polyLineRef as! MGLAnnotation
                
                self.Map.removeAnnotation(poly2)
                
                let poly:MGLPolyline=polyLineRef as! MGLPolyline
                
                self.Map.removeAnnotation(poly)
                
                Map.removeAnnotation(pinRef!)
            }
            
            if self.pointFromNotification != nil
            {
                self.Map.removeAnnotation(pointFromNotification!)
            }
            
            Map.addAnnotation(point!)
            pinRef=point
            
            
            
            let AlertView = UIAlertController(title:"Runsafe", message:"Wanna Run?", preferredStyle: .alert)
            
            let cancel:UIAlertAction=UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
                AlertView.dismiss(animated: true, completion: nil)
                self.Map .removeAnnotation(self.point!)
                
            })
            
            let Continue:UIAlertAction=UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
                AlertView.dismiss(animated: true, completion: nil)
                
                let CrimeView:AddPinViewController=self.storyboard?.instantiateViewController(withIdentifier: "AddPinViewController") as!AddPinViewController
                
                
                CrimeView.Cord=newCoordinates
                
                Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Fetching Route...")
                self.wayPointswithcordinates(fromCoordinate: (self.Map.userLocation?.coordinate)!, toCoordinate: newCoordinates)
               
            })
            
            AlertView.addAction(cancel)
            AlertView.addAction(Continue)
            
            self.present(AlertView, animated: true, completion: nil)
            
            
        }
    }
    
    func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D)->(String)
    {
        var Address:String=String()
        let geocoder = CLGeocoder()
        let location:CLLocation=CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if e != nil
            {
                print("Error:  \(e!.localizedDescription)")
                return
            }
            else
            {
                
                let placemark = placemarks!.last! as CLPlacemark
                
                let userInfo:NSDictionary =
                {
                    placemark.addressDictionary!
                    }() as NSDictionary
                
                print("Location:  \(userInfo)")
                
                Address=String(describing: userInfo.value(forKey: "FormattedAddressLines") as! NSArray)
                
                Address=self.RemoveUnrequiredStuffFromString(string: Address)
                
                
                print("Address:  \(Address)")
                self.lblAddressPolylineDetail.text=Address
            }
        })
        
        return Address
    }
    
    func RemoveUnrequiredStuffFromString(string:String) -> String
    {
        
        var newString = string.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        newString = newString.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
        newString = newString.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        newString = newString.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        newString = newString.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
     
        
        return newString
    }
    
    
    
    func wayPointswithcordinates(fromCoordinate:CLLocationCoordinate2D,toCoordinate:CLLocationCoordinate2D)
    {
        
        let directions = Directions.sharedDirections
        
        //23.023499, 72.556071  23.029256, 72.558130
        
        let waypoints = [
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: fromCoordinate.latitude, longitude: fromCoordinate.longitude), name: "Mapbox"),
            Waypoint(coordinate: CLLocationCoordinate2D(latitude: toCoordinate.latitude, longitude: toCoordinate.longitude), name: "White House"),
            ]
        
        let addstr:String=self.getAddressFromGeocodeCoordinate(coordinate: toCoordinate)
        
        print("address ===\(String(describing: self.lblAddressPolylineDetail.text))")
        print(addstr)
        
        
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierWalking)
        
        options.shapeFormat=RouteShapeFormat.GeoJSON
        
        options.routeShapeResolution = RouteShapeResolution.Full
        
        options.includesSteps = true
        
        _ = directions.calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else
            {
                print("Error calculating directions: \(error!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                Constant.APPDELEGATE.ReceiveNotification=false
                
                Constant.AlertViewNew(Title: "Runsafe", Message: "This location is out of bound you can't catch it.", ViewController: self)
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first
            {
                print("Route via \(leg):")
                
                let distanceFormatter = LengthFormatter()
                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                
                let travelTimeFormatter = DateComponentsFormatter()
                
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                
                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                
                self.lblTimePolylineDetail.text="Distance: \(formattedDistance)    Time: \(formattedTravelTime!)"
                
                
                for step in leg.steps
                {
                    print("\(step.instructions)")
                    let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                    
                    print("— \(formattedDistance) —")
                }
                
                //draws polyline on path
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    
                    self.routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    
                    self.Map.addAnnotation(self.routeLine!)
                    // self.polyLineRef=self.routeLine
                    
                    //MARK:- Important Notes For CameraView
                    // For simulator heading=180
                    // For Phone Heading = 20
                    let camera = MGLMapCamera(lookingAtCenter: (route.coordinates?.first)!, fromDistance: 200, pitch: 80, heading: 20)
                    let center = CLLocationCoordinate2D(latitude: (self.Map.userLocation?.coordinate.latitude)!, longitude: (self.Map.userLocation?.coordinate.longitude)!)
                    
                    // Optionally set a starting point.
                    self.Map.isPitchEnabled=true
                    
                    self.Map.setCenter(center, zoomLevel: 7, direction:0, animated: false)
                    
                    // Animate the camera movement over 5 seconds.
                    
                    self.Map.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                    
                }
                self.showPolyLineDetail()
            }
        }
        
    }
    
    func setCameraToNormalMode()
    {
        let camera = MGLMapCamera(lookingAtCenter: (self.Map.userLocation?.coordinate)!, fromDistance: 4500, pitch: 0, heading: 180)
        
        let center = CLLocationCoordinate2D(latitude: (self.Map.userLocation?.coordinate.latitude)!, longitude: (self.Map.userLocation?.coordinate.longitude)!)
        self.Map.setCenter(center, zoomLevel: 7, direction: 0, animated: false)
        // Animate the camera movement over 5 seconds.
        self.Map.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    func hideDownCrimeList(){
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.viewForPicker.frame = CGRect(x:self.viewForPicker.frame.origin.x,y:1000, width:self.viewForPicker.frame.size.width, height:self.viewForPicker.frame.size.height)
            
        }, completion: nil)
        
    }
    func showUpCrimeList(){
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.viewForPicker.frame = CGRect(x: self.viewForPicker.frame.origin.x, y: (self.view.frame.size.height/2)-(self.viewForPicker.frame.size.height/2)-30, width: self.viewForPicker.frame.size.width, height: self.viewForPicker.frame.size.height)
            
            
        }, completion: nil)
        
    }
    
    //MARK:- Location Button Click
    
    @IBAction func LocationClick(sender: UIBarButtonItem)
    {
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            Map.showsUserLocation=true
            Map.isZoomEnabled=true
            
            let Cord:CLLocationCoordinate2D?=CLLocationCoordinate2D(latitude: (Map.userLocation!.location?.coordinate.latitude)!, longitude: (Map.userLocation!.location?.coordinate.longitude)!)
            
            Map .setCenter(Cord!, animated: true)
            
            Map .setZoomLevel(15.0, animated: true)
            Map .setUserTrackingMode(.follow, animated: true)
            
            var Imagecode:NSString = NSString(format: "%@", Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
            
            Imagecode = Imagecode.appending(".png") as NSString
            
            CountryImage.image=UIImage(named:Imagecode as String)
            
        }
        else
        {
            Constant.AlertViewNew(Title: "Please go to app setting and enble your location", Message:"", ViewController: self)
        }
        
    }
    
    //MARK:- Calling Button Click
    
    @IBAction func CallButton_Click(sender: UIButton)
    {
        let AlertView:UIAlertController = UIAlertController(title:"                                                                     Are you sure? " as String, message:"Do you want a call!" as String, preferredStyle: .alert)
        
        
        var Imagecode:NSString = NSString(format: "%@", Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
        
        // print(Imagecode)
        
        Imagecode = Imagecode.appending(".png") as NSString
        
        CountryImage.image=UIImage(named:Imagecode as String)
        
        //let imageView = UIImageView(frame: CGRectMake(125,15,26,20))
        let imageView = UIImageView(frame: CGRect(x: 125, y: 15, width: 26, height: 20))
        imageView.image = UIImage(named:Imagecode as String)
        
        AlertView.view.addSubview(imageView)
        
        
        let Ok:UIAlertAction=UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            
            if (Constant.USERDEFAULT.value(forKey: "Country_name")! as AnyObject).isEqual("India")
            {
                self.PoliceNumber="100"
            }
            else if (Constant.USERDEFAULT.value(forKey: "Country_name")! as AnyObject) .isEqual("Japan")
            {
                self.PoliceNumber="110"
            }
            else if (Constant.USERDEFAULT.value(forKey: "Country_name")! as AnyObject) .isEqual("China")
            {
                self.PoliceNumber="110"
            }
            else if (Constant.USERDEFAULT.value(forKey: "Country_name")! as AnyObject) .isEqual("Hong Kong")
            {
                self.PoliceNumber="999"
            }
            else
            {
                self.PoliceNumber="911"
            }
            
            
            var Str:String = "tel://\(String(describing: self.PoliceNumber))"
            Str = Str.replacingOccurrences(of: "Optional", with: "")
            Str = Str.replacingOccurrences(of: ")", with: "")
            Str = Str.replacingOccurrences(of: "(", with: "")
            Str = Str.replacingOccurrences(of: "\n", with: "")
            Str = Str.replacingOccurrences(of: "\"", with: "")
            
            
            if let phoneCallURL:NSURL = NSURL(string: Str)
            {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL))
                {
                    application.openURL(phoneCallURL as URL);
                }
            }
            
        })
        
        let Cancel:UIAlertAction=UIAlertAction(title: "Not Now", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            
        })
        
        AlertView.addAction(Ok)
        
        AlertView.addAction(Cancel)
        
        self.present(AlertView, animated: true, completion: nil)
        
    }
    
    //MARK:- Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            NewUpdatedLocation = locations.last!
            
            Map .setUserTrackingMode(.follow, animated: true)
            
            let location=manager.location!
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
                if e != nil
                {
                    //print("Error:  \(e!.localizedDescription)")
                    
                }
                else
                {
                    
                    let placemark = placemarks!.last! as CLPlacemark
                    let userInfo =
                        [
                            "city":     placemark.locality!,
                            "state":    placemark.administrativeArea!,
                            "country":  placemark.country!,
                            "Code":   placemark.postalCode!
                    ]
                    
                    
                    print("Location:  \(userInfo)")
                    
                    let Country_name:NSString=placemark.country! as NSString
                    
                    
                    if ((Country_name as NSString) .isEqual(to: Constant.USERDEFAULT.value(forKey: "Country_name") as! String))
                    {
                        
                        Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                        
                        Constant.USERDEFAULT .synchronize()
                        
                        var Imagecode:NSString = NSString(format: "%@",Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
                        
                        //print(Imagecode)
                        
                        Imagecode = Imagecode.appending(".png") as NSString
                        
                        self.CountryImage.image=UIImage(named:Imagecode as String)
                    }
                    else
                    {
                        
                        Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                        
                        Constant.USERDEFAULT .synchronize()
                        
                        self.parseJson(country: Country_name)
                    }
                    
                }
            })
            
            self .WebServiceCallForAnnotationsPloatting()
        }
        else
        {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while updating location " + error.localizedDescription)
        
        let  Status:CLAuthorizationStatus=CLLocationManager .authorizationStatus()
        
        print(Status)
        
    }
    
    //MARK:-  CLLocation Manager Delegate For iBeacon
    
    func sendLocalNotificationWithMessage(message: String)
    {
        let notification: UILocalNotification = UILocalNotification()
        
        notification.alertBody = message
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
    }
    
    
    
    func parseJson(country:NSString)
    {
        
        DispatchQueue.global().async(execute: {
            
            let path = Bundle.main.path(forResource: "countries", ofType: "json")
            
            let jsonData:NSData = try! NSData(contentsOfFile: path!, options:.alwaysMapped)
            
            let CountryArray:NSMutableArray = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            
            DispatchQueue.main.async(execute: {() -> Void in
                if CountryArray.count>0
                {
                    self.GetCountryCodeViaCountryName(Country: country, CountryArray: CountryArray)
                }
            })
            
        })

        
    }
    
    func GetCountryCodeViaCountryName(Country:NSString, CountryArray:NSMutableArray)
    {
        
        for i in 0 ..< CountryArray.count
        {
            if (((CountryArray.object(at: i) as AnyObject).value(forKey: "name")! as AnyObject) .isEqual(Country as String))
            {
                Constant.USERDEFAULT .setValue((CountryArray.object(at: i) as AnyObject).value(forKey:"dial_code") as? NSString, forKey: "Country_code")
                Constant.USERDEFAULT .setValue((CountryArray.object(at: i) as AnyObject).value(forKey:"code") as? NSString, forKey: "Country_Image_Code")
                Constant.USERDEFAULT .synchronize()
                
                var Imagecode:NSString = NSString(format: "%@",Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
                
                Imagecode = Imagecode.appending(".png") as NSString
                
                self.CountryImage.image=UIImage(named:Imagecode as String)
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        
        
    }
    
    @IBAction func btn_Close_CrimeList_clicked(sender: AnyObject) {
        
        self.hideDownCrimeList()
        
    }
    //MARK:- Style Button Click
    
    @IBAction func StyleButton_Click(sender: UIButton)
    {
        let AlertView:UIAlertController = UIAlertController(title:"Select Your Map Style " as String, message:"" as String, preferredStyle: .actionSheet)
        
        Outdoors=UIAlertAction(title: "Trail Run", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            self.Map.styleURL=NSURL(string: "mapbox://styles/mapbox/outdoors-v9")! as URL
            
        })
        
        
        Streets=UIAlertAction(title: "Neighborhood Run", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            self.Map.styleURL=NSURL(string: "mapbox://styles/sank/cips92pyj001ycknggpvrbqq7")! as URL
            _ = UIImage(named: "online_tab")
            
        })
        
        
        let Cancel:UIAlertAction=UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
        })
        
        AlertView.addAction(Streets!)
        
        AlertView.addAction(Outdoors!)
        
        AlertView.addAction(Cancel)
        
        self.present(AlertView, animated: true, completion: nil)
        
    }
    
    //MARK:- Sharing Click
    
    @IBAction func Share_Click(sender: UIButton)
    {
        SGActionView.showGridMenu(withTitle: "Select Your option for sharing", itemTitles: ["Facebook", "WeChat", "Line", "WhatsApp"], images: [UIImage(named: "set_fac_icn")!, UIImage(named: "set_we_icn")!, UIImage(named: "set_lin_icn")!, UIImage(named: "set_wat_icn")!]) { (Int) in
            if(Int==1)
            {
                self.FaceBookSharing()
                
            }
            else if(Int==2)
            {
                self.WeChatSharing()
            }
            else if(Int==3)
            {
                self.LineSharing()
            }
            else if(Int==4)
            {
                self.WhatsAppSharing()
            }
        }
    }
    
    
    //MARK:- WebService Call For Annotations Ploatting
    
    func WebServiceCallForAnnotationsPloatting()
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        if  Constant.APPDELEGATE.SettingLocation==true
        {
            var Latt = String()
            Latt = String(format: "%f", (NewUpdatedLocation.coordinate.latitude))

            var longg = String(format: "%f", (NewUpdatedLocation.coordinate.longitude))

            let params:[String : String] = ["latitude":Latt ,"longitude":longg]
            
            Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/new_map.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON(queue: nil, options: .allowFragments, completionHandler: { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                    
                case .success(_):
                    print("Response: \((response.result.value)! as AnyObject!)")
                    
                    Constant.APPDELEGATE.hideLoadingHUD()
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    
                    Constant.APPDELEGATE.hideLoadingHUD()
                    
                    self.clearForm()
                    
                    
                    let str = dict["status"]?.dictionaryValue["sucess"]?.stringValue
                    
                    if (str? .isEqual("1"))!
                    {                       
                        
                      

                        let  mainArray=dict["status"]?.dictionaryValue ["data"]?.arrayValue
                        
                        let  FinalDic = mainArray![0].dictionaryValue
                        
                        print("FinalDic Data Print")
                        print(FinalDic as Any)
                       
                        self.Robbery = NSMutableArray(array: dict["status"]!["data"][0]["Robbery"].array!)
                      
                        print("Robbery Array")
                        print(self.Robbery as Any)
                        
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                if (self.Robbery?.count)! > Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Robbery!, Identifier: "Robbery",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                        
                        
                        
                      
                        self.Assault=NSMutableArray(array: dict["status"]!["data"][0]["Assault"].array!)
                      
                        print("Assault Array")
                        print(self.Assault as Any)
                       
                        
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Assault?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Assault!, Identifier: "Assault",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                    
                        self.Arson=NSMutableArray(array: dict["status"]!["data"][0]["Arson"].array!)
                       
                        print("Arson Array")
                        print(self.Arson as Any)
                       
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Arson?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Arson!, Identifier: "Arson",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
           
                        
                        self.Rape=NSMutableArray(array: dict["status"]!["data"][0]["Rape"].array!)
                      
                        
                        print("Rape Array")
                        print(self.Rape as Any)
                        
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Rape?.count)! > Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Rape!, Identifier: "Rape",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                       
                        
                        self.Violet_Crime_Murder=NSMutableArray(array: dict["status"]!["data"][0]["Violet_Crime_Murder"].array!)
                 
                        print("Violet_Crime_Murder Array")
                        print(self.Violet_Crime_Murder as Any)
                       
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Violet_Crime_Murder?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Violet_Crime_Murder!, Identifier: "Violet Crime Murder",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                   
                        self.Poor_Roads=NSMutableArray(array: dict["status"]!["data"][0]["Poor_Roads"].array!)
                        
                        print("Poor Road Array")
                        print(self.Poor_Roads as Any)
                       
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Poor_Roads?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Assault!, Identifier: "Poor Roads",ImageName:"set_wat_icn")
                                }
                            })
                        })
                        
                        
                      
                        self.Poor_Lighting=NSMutableArray(array: dict["status"]!["data"][0]["Poor_Lighting"].array!)
                        print("Poor_Lighting Array")
                        print(self.Poor_Lighting as Any)
                       
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Poor_Lighting?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Poor_Lighting!, Identifier: "Poor Lighting",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                        
                      
                        
                        self.Unsafe_Neighbourhoods=NSMutableArray(array: dict["status"]!["data"][0]["Unsafe_Neighbourhoods"].array!)
                        
                       
                        print("Unsafe_Neighborhoods Array")
                        print(self.Unsafe_Neighbourhoods as Any)

                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.Unsafe_Neighbourhoods?.count)!>Int(0)
                                {
                                    self.SetPin(PinDataArray: self.Unsafe_Neighbourhoods!, Identifier: "Unsafe Neighborhoods",ImageName:"set_wat_icn")
                                }
                            })
                            
                        })
                        
                      
                        
                        self.aryOther=NSMutableArray(array: dict["status"]!["data"][0]["other"].array!)
                        
                        self.aryOther?.removeObject(identicalTo: NSNull())
                       
                        print("aryOther Array")
                        print(self.aryOther as Any)
                      
                        DispatchQueue.global().async(execute: {
                            
                            DispatchQueue.main.async(execute: {() -> Void in
                                if (self.aryOther?.count)!>Int(0)
                                {
                                    self.SetOtherPin(PinDataArray: self.aryOther!, Identifier: "other", ImageName: "Default")
                                }
                            })
                        })
                    }
                    else
                    {
                        
                    }
                    
                    break
                    
                case .failure(_):
                    
                    Constant.APPDELEGATE.hideLoadingHUD()
                    
                    self.clearForm()
                    
                    break
                    
                }
            })
        }
        else
        {
            Constant.AlertViewNew(Title: "Please go to app setting and enble your location", Message:"", ViewController: self)
        }
        
    }
    
    //MARK:- Set All Annotations
    
    func SetOtherPin(PinDataArray:NSMutableArray,Identifier:String,ImageName:String)
    {
     
        print("Other PinData Array")
        
        print(PinDataArray)
        
        var ARRR=JSON(PinDataArray).arrayValue
        
        if PinDataArray.count>0
        {
            for i in 0..<PinDataArray.count
            {
                var PinData = ARRR[i].dictionaryValue
                
                print(PinData)
                
                let TempLat=PinData["latitude"]?.doubleValue

                let TempLong=PinData["longitude"]?.doubleValue
                
                let Lat:CLLocationDegrees=TempLat!
                
                let Long:CLLocationDegrees=TempLong!
                
                let SubTitleStr:NSString=NSString(format: "%d", locale:NSLocale .current,i)
                
                
                var TitleStr:String=String("Other")
                
                TitleStr = TitleStr .replacingOccurrences(of: "Optional", with: "")
                TitleStr = TitleStr .replacingOccurrences(of: ")", with: "")
                TitleStr = TitleStr .replacingOccurrences(of: "(", with: "")
                TitleStr = TitleStr .replacingOccurrences(of: "\n", with: "")
                TitleStr = TitleStr .replacingOccurrences(of: "\"", with: "")
               
                let point = NewAnnotation(title: TitleStr, subtitle: SubTitleStr as String, coordinate: CLLocationCoordinate2D(latitude:Lat,longitude: Long), image:UIImage(named:ImageName)! , reuseIdentifier: Identifier)
                point.accessibilityActivate()
                
                point.image=UIImage(named:ImageName)
                
                point.reuseIdentifier = Identifier
                
                DispatchQueue.global().async(execute: {
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.Map .addAnnotation(point)
                    })
                    
                })
            }
        }
    }
    
    func SetPin(PinDataArray:NSMutableArray,Identifier:String,ImageName:String)
    {
        
        var ARRR=JSON(PinDataArray).arrayValue

        if PinDataArray.count>0
        {
            for i in 0..<PinDataArray.count
            {
                
                var PinData = ARRR[i].dictionaryValue
                
                print(PinData)
                
                let TempLat=PinData["latitude"]?.doubleValue
                
                let TempLong=PinData["longitude"]?.doubleValue
                
                let Lat:CLLocationDegrees=TempLat!
                
                let Long:CLLocationDegrees=TempLong!
                
                let SubTitleStr:NSString=NSString(format: "%d", locale:NSLocale .current,i)
                
                let point = NewAnnotation(title: Identifier, subtitle: SubTitleStr as String, coordinate: CLLocationCoordinate2D(latitude:Lat,longitude: Long), image:UIImage(named:ImageName)! , reuseIdentifier: Identifier)
                
                point.image=UIImage(named:ImageName)
                
                point.reuseIdentifier = Identifier
                
                DispatchQueue.global().async(execute: {
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.Map .addAnnotation(point)
                    })
                    
                })
               
                
            }
        }
    }
    
    //MARK:- WhatsApp Sharing
    func WhatsAppSharing()
    {
        if Constant.APPDELEGATE.WhatsAppSharing==true
        {
            var msg:String=String()
            
            if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) != nil
            {
                print("messageFromUserdefault== \(String(describing: Constant.USERDEFAULT.value(forKey: "CustomMessage"))) ")
                
                msg  = (Constant.USERDEFAULT.value(forKey: "CustomMessage") as? String)!
            }
            else
            {
                msg = "I am out for run/walk, not feeling safe. I need you on the phone/help"
            }
            
            print(msg)
            
           
            let urlWhats = "whatsapp://send?text=\(msg)"
            
            print(urlWhats)
            
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            {
                if let whatsappURL = NSURL(string: urlString)
                {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL)
                    {
                        UIApplication.shared.openURL(whatsappURL as URL)
                    }
                    else
                    {
                        Constant.AlertViewNew(Title: "Runsafe", Message: "Please add WhatsApp Application in your device to share", ViewController: self)
                    }
                }
            }
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please go to your app setting and on your WhatsApp Sharing", ViewController: self)
        }
        
    }
    
    //MARK:- WeChat Sharing
    func WeChatSharing()
    {
        var msg1:String=String()
        
        if Constant.APPDELEGATE.WeChatSharing==true
        {
            if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) != nil
            {
                print("messageFromUserdefault== \(String(describing: Constant.USERDEFAULT.value(forKey: "CustomMessage"))) ")
                
                msg1  = (Constant.USERDEFAULT.value(forKey: "CustomMessage") as? String)!
            }
            else
            {
                msg1 = "I am out for run/walk, not feeling safe. I need you on the phone/help"
            }
            
            print(msg1)
            
            
            if WXApi.isWXAppInstalled()
            {
                if WXApi.openWXApp()
                {
                    let req:SendMessageToWXReq=SendMessageToWXReq()
                    req.text=msg1
                    req.bText = true;
                    req.scene = 0;
                    WXApi .send(req)
                }
            }
            else
            {
                Constant.AlertViewNew(Title: "Runsafe", Message: "Please add WeChat Application in your device to share", ViewController: self)
            }
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please go to your app setting and on your WeChat Sharing", ViewController: self)
        }
    }
    
    //MARK:- Line Sharing
    func LineSharing()
    {
        var msg1:String=String()
        
        if Constant.APPDELEGATE.LineSharing==true
        {
            
            
            if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) != nil
            {
                print("messageFromUserdefault== \(String(describing: Constant.USERDEFAULT.value(forKey: "CustomMessage"))) ")
                
                msg1  = (Constant.USERDEFAULT.value(forKey: "CustomMessage") as? String)!
            }
            else
            {
                msg1 = "I am out for run/walk, not feeling safe. I need you on the phone/help"
            }
            
            print(msg1)
            
            let urlLine = "line://msg/text/\(msg1)"
            
            if let urlString = urlLine.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            {
                if let LineURL = NSURL(string: urlString)
                {
                    if UIApplication.shared.canOpenURL(LineURL as URL)
                    {
                        UIApplication.shared.openURL(LineURL as URL)
                    }
                    else
                    {
                        Constant.AlertViewNew(Title: "Runsafe", Message: "Please add Line Application in your device to share", ViewController: self)
                    }
                }
            }
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please go to your app setting and on your Line Sharing", ViewController: self)
        }
        
    }
    
    //MARK:- FaceBook Sharing
    
    func FaceBookSharing()
    {
        if Constant.APPDELEGATE.FaceBookSharing==true
        {
            //New Code
            
            if  (FBSDKAccessToken .current() != nil)
            {
                self.shareViaShareDialogFacebook()
            }
            else
            {
                
                
                Constant.APPDELEGATE.FacebookLoginManager?.logIn(withReadPermissions:  ["public_profile","email"], from: self, handler: { (result, error) in
                    if (error != nil)
                    {
                        print(error?.localizedDescription as Any)
                        
                        NSLog("%@", "There is an error")
                    }
                    else if (result?.isCancelled)!
                    {
                        NSLog("%@", "Login cancelled")
                        
                        let AlertView = UIAlertController(title:"Login Cancelled", message:"You have cancelled Login", preferredStyle: .alert)
                        
                        let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                            AlertView.dismiss(animated: true, completion: nil)
                        })
                        
                        AlertView.addAction(Ok)
                        
                        self.present(AlertView, animated: true, completion: nil)
                    }
                    else
                    {
                        self.shareViaShareDialogFacebook()
                    }
                })
    
                
            }
            
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please go to your app setting and on your FaceBook Sharing", ViewController: self)
        }
    }
    
    
    func ShareOnFacebookWithParametrs()
    {
        let params:NSMutableDictionary = NSMutableDictionary(capacity: 4)
        
        let Location:CLLocation=CLLocation(latitude: (Map.userLocation?.coordinate.latitude)!, longitude: (Map.userLocation?.coordinate.longitude)!)
        
        params.setObject(Location, forKey: "center" as NSCopying)
        
        params.setObject("I am out for run/walk, not feeling safe. I need you on the phone/help", forKey: "message" as NSCopying)
        
        var qryString:String=String(stringInterpolation:"http://maps.google.com/?q=\(String(describing: Map.userLocation?.coordinate.latitude)),\(String(describing: Map.userLocation?.coordinate.longitude))")
        
        qryString = qryString .replacingOccurrences(of: "Optional", with: "")
        qryString = qryString .replacingOccurrences(of: ")", with: "")
        qryString = qryString .replacingOccurrences(of: "(", with: "")
        qryString = qryString .replacingOccurrences(of: "\n", with: "")
        qryString = qryString .replacingOccurrences(of: "\"", with: "")
       
        
        params.setObject("http://www.ceres8.com/safety", forKey: "link" as NSCopying)
        
       
        
    }
    
    func shareViaShareDialogFacebook()
    {
        
        let Dialog:FBSDKShareDialog = FBSDKShareDialog()
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentTitle = "Runsafe Runner’s mate"
        
        let  HasTag:FBSDKHashtag=FBSDKHashtag(string:"Click this link to see my location on map")
        
        if (Constant.USERDEFAULT.value(forKey: "CustomMessage")) != nil
        {
            print("messageFromUserdefault== \(String(describing: Constant.USERDEFAULT.value(forKey: "CustomMessage"))) ")
            
            content.contentDescription = "Click this link to see my location on map"
            
            content.quote=Constant.USERDEFAULT.value(forKey: "CustomMessage") as? String
        }
        else
        {
            content.contentDescription = "Click this link to see my location on map"
            
            content.quote="I am out for run/walk, not feeling safe. I need you on the phone/help"
        }
        
        content.hashtag=HasTag
        
      
        
        content.imageURL=NSURL(string: String(format:"http://i-phoneappdevelopers.com/runner_mate/webservice/img/runner-mate.png"))! as URL!
        
        var qryString:String=String(stringInterpolation:"http://maps.google.com/?q=\(String(describing: Map.userLocation?.coordinate.latitude)),\(String(describing: Map.userLocation?.coordinate.longitude))")
        qryString = qryString .replacingOccurrences(of: "Optional", with: "")
        qryString = qryString .replacingOccurrences(of: ")", with: "")
        qryString = qryString .replacingOccurrences(of: "(", with: "")
        qryString = qryString .replacingOccurrences(of: "\n", with: "")
        qryString = qryString .replacingOccurrences(of: "\"", with: "")
        
        
        content.contentURL = NSURL(string:qryString)! as URL!
        
        Dialog.shareContent=content
        Dialog.mode = .feedBrowser
        Dialog.fromViewController=self
        Dialog.show()
        
    }
    
    
    //MARK:- CallOut View Delegate
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool
    {
        // Always allow callouts to popup when annotations are tapped
        return false
    }
    
    private func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView?
    {
        if annotation.responds(to: #selector(getter: UIPreviewActionItem.title)) && annotation.title! == "Hello world!"
        {
            return CustomAnnotations(representedObject: annotation)
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation)
    {
       
    }
    
    //MARK:- Annotation Click
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation)
    {
        var subtitle:String=String(describing: annotation.subtitle)
        subtitle = subtitle.replacingOccurrences(of: "Optional", with: "")
        subtitle = subtitle.replacingOccurrences(of: ")", with: "")
        subtitle = subtitle.replacingOccurrences(of: "(", with: "")
        subtitle = subtitle.replacingOccurrences(of: "\n", with: "")
        subtitle = subtitle.replacingOccurrences(of: "\"", with: "")
     
        
        if annotation.title! as String? == "Arson"
        {
            let numberFromString:Int = Int(subtitle)!
            
            let TempArray = JSON(Arson as Any).arrayValue
            
            if TempArray.count>0
            {
                self.dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
                print(dic)
            
                self.imgHeaderPinDetail.image=UIImage(named:"Arson")
                strPassCrime="Arson"
            }
            
        }
        else if annotation.title! as String? == "Robbery"
        {
            let numberFromString:Int = Int(subtitle)!
            
            let TempArray = JSON(Robbery as Any).arrayValue
            if TempArray.count>0
            {
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
           
            self.imgHeaderPinDetail.image=UIImage(named:"Robbery")
            strPassCrime="Robbery"
            }
        }
        else if annotation.title! as String? == "Other"
        {
            
            let numberFromString:Int = Int(subtitle)!
          
            
            let TempArray = JSON(aryOther as Any).arrayValue
            if TempArray.count>0
            {
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            
         
            self.imgHeaderPinDetail.image=UIImage(named:"Default")
            strPassCrime=(annotation.title!! as NSString) as String
            }
        }
        else if annotation.title! as String? == "Unsafe Neighborhoods"
        {
            let numberFromString:Int = Int(subtitle)!
            
            
            let TempArray = JSON(Unsafe_Neighbourhoods as Any).arrayValue
            if TempArray.count>0
            {
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            
            self.imgHeaderPinDetail.image=UIImage(named:"Unsafe Neighborhoods")
            strPassCrime="Unsafe Neighborhoods"
            
            }
        }
        else if annotation.title! as String? == "Poor Lighting"
        {
            
            let numberFromString:Int = Int(subtitle)!
            let TempArray = JSON(Poor_Lighting as Any).arrayValue
            if TempArray.count>0
            {
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
           
            self.imgHeaderPinDetail.image=UIImage(named:"Poor Lighting")
            strPassCrime="Poor Lighting"
            }
        }
        else if annotation.title! as String? == "Poor Roads"
        {
            
            let numberFromString:Int = Int(subtitle)!
          
            let TempArray = JSON(Poor_Roads as Any).arrayValue
            if TempArray.count>0
            {
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            
            self.imgHeaderPinDetail.image=UIImage(named:"Poor Roads")
            strPassCrime="Poor Roads"
            
            }
        }
        else if annotation.title! as String? == "Violet Crime Murder"
        {
            
            let numberFromString:Int = Int(subtitle)!
           
            let TempArray = JSON(Violet_Crime_Murder as Any).arrayValue
            
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            self.imgHeaderPinDetail.image=UIImage(named:"Violet Crime Murder")
            strPassCrime="Violet Crime Murder"
            
            
        }
        else if annotation.title! as String? == "Rape"
        {
            let numberFromString:Int = Int(subtitle)!
            
            let TempArray = JSON(Rape as Any).arrayValue
            
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            
            self.imgHeaderPinDetail.image=UIImage(named:"Rape")
            strPassCrime="Rape"
            
            
        }
        else if annotation.title! as String? == "Assault"
        {
            let numberFromString:Int = Int(subtitle)!
            let TempArray = JSON(Assault as Any).arrayValue
            
            dic=NSMutableDictionary(dictionary: TempArray[numberFromString].dictionaryValue)
                as Any as! NSMutableDictionary
            
            print(dic)
            self.imgHeaderPinDetail.image=UIImage(named:"Assault")
            strPassCrime="Assault"
            
        }
        
       
            if dic .allKeys.count>0
            {
                
                tappedGesture = UITapGestureRecognizer(target:self, action: #selector(self.hidePinDetail))
                
                
                tappedGesture.delegate=self
                
                self.view.addGestureRecognizer(tappedGesture)
                
                self.lblYearsPinDetail.text=JSON(dic).dictionaryValue["year"]?.stringValue
                self.lblCommentPinDetail.text=JSON(dic).dictionaryValue["main_comment"]?.stringValue
                self.lblRecordsPinDetail.text=JSON(dic).dictionaryValue["crime_data"]?.stringValue
                
                self.showPinDetail()
                
            }
        
    }
    
    internal func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation)
    {
        mapView.deselectAnnotation(annotation, animated: true)
    }
    func showPinDetail()
    {
        
        UIView.animate(withDuration: 0.0, animations: {
            self.viewPinDetailTop.constant = 0
            //  self.btnBlurMenu.hidden=true
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    @objc func hidePinDetail()
    {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewPinDetailTop.constant = -200
            self.view.layoutIfNeeded()
            self.view.removeGestureRecognizer(self.tappedGesture)
            
            
        })
        
        
    }
    func hideEmergencyCall()
    {
        Emergencylbl.isHidden=true
        CallButton.isHidden=true
        imgCallBackGround.isHidden=true
        CountryImage.isHidden=true
    }
    func showEmergencyCall()
    {
        Emergencylbl.isHidden=false
        CallButton.isHidden=false
        imgCallBackGround.isHidden=false
        CountryImage.isHidden=false
    }
    
    
    func showPolyLineDetail()
    {
        if self.TapGesture != nil
        {
            self.Map .removeGestureRecognizer(self.TapGesture!)
        }
        
        
        Constant.APPDELEGATE.hideLoadingHUD()
        
        hideEmergencyCall()
        tappedGesture2 = UITapGestureRecognizer(target:self, action: #selector(self.hidePolyLineDetail))
        tappedGesture2.delegate=self
        self.view.addGestureRecognizer(tappedGesture2)
        
        self.view .bringSubview(toFront: viewPolylineDetail)
        
        UIView.animate(withDuration: 0.0, animations: {
            
            self.viewPolylineDetailBottom.constant = 0
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    @objc func hidePolyLineDetail()
    {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.viewPolylineDetailBottom.constant = -98
            
            self.view.layoutIfNeeded()
            
            if self.tappedGesture2 != nil
            {
                self.view.removeGestureRecognizer(self.tappedGesture2)//crashes here
                
            }
        })
        
        
    }
    
    func SendDownPolyLineDetail()
    {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.viewPolylineDetailBottom.constant = -300
            
            self.view.layoutIfNeeded()
            self.view.removeGestureRecognizer(self.tappedGesture2)
            
            
        })
    }
    
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage?
    {
        
        var annotationImage : MGLAnnotationImage? = nil
        //seems to be a double optional! String??
        var title = ""
        // var subTitle = ""
        //--------------------------------------------------
        //TITLE
        //--------------------------------------------------
        
        if let titleOpt = annotation.title{
            if let title_ = titleOpt{
                title = title_
                
            }else{
            }
        }else{
        }
        //--------------------------------------------------
        //SUBTITLE
        //--------------------------------------------------
        //        if let subtitleOpt = annotation.subtitle{
        //            if let subtitle_ = subtitleOpt{
        //                subTitle = subtitle_
        //
        //            }else{
        //            }
        //        }else{
        //        }
        //---------------------------------------------------------------------
        if title == "" {
            
        }else{
            
            
            if title == "Assault" {
                // let imageOut = (title , iconColor: UIColor.appColorFlat_TahitiGold_Orange())
                annotationImage = MGLAnnotationImage(image:UIImage(named:"Assault")!, reuseIdentifier: title)
            }
            else if title == "Rape" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Rape")!, reuseIdentifier: title)
            }
            else if title == "Robbery" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Robbery")!, reuseIdentifier: title)
            }
            else if title == "Violet Crime Murder" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Violet Crime Murder")!, reuseIdentifier: title)
            }
            else if title == "Poor Roads" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Poor Roads")!, reuseIdentifier: title)
            }
            else if title == "Unsafe Neighborhoods" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image:UIImage(named:"Unsafe Neighborhoods")!, reuseIdentifier: title)
            }
            else if title == "Arson" {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Arson")!, reuseIdentifier: title)
            }
                
            else if title == "Poor Lighting"
            {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Poor Lighting")!, reuseIdentifier: title)
            }
            else if title == "Destination"
            {
                //let imageOut = self.textToImage(title , iconColor: UIColor.appColorButtonPink())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"finish")!, reuseIdentifier: title)
            }
            else{
                
                // let imageOut = self.textToImage(title ,iconColor: UIColor.appColorCYAN())
                annotationImage = MGLAnnotationImage(image: UIImage(named:"Default")!, reuseIdentifier: title)
            }
        }
        //  drawPolyline()
        return annotationImage
        
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 10.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor
    {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
            
        }
        else
        {
            return UIColor(red: 102/255, green:102/255, blue:255/255, alpha:1)
        }
    }
    
    
    
    //------------------------------polyline code Ends--------------------------------
    
    
    //MARK:- Bluetooth Button Click
    func addBlurEffect(view:UIView)
    {
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
        }
        else {
            
            view.backgroundColor = UIColor.black
        }
        
    }
    
    func BluetoothButtonClick(sender: UIButton)
    {
        self .performSegue(withIdentifier: "PushtoBluetooth", sender: self)
    }
    
    @IBAction func btn_PinMenu_clicked(sender: AnyObject)
    {
        
        
        isHidden=true
        UIApplication .shared.setStatusBarHidden(true, with: .none)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewPinDetailTop.constant = -200
            
            self.view.layoutIfNeeded()
            
        })
        
        setUpMainView()
        showUpMainMenuWithAnimation()
    }
    func showUpMainMenuWithAnimation()
    {
        //------------------jig's Code-------------------------
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tabBarController?.tabBar.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations:
            {
                
                self.viewBackgroundTop.constant=0
                self.viewBackgroundBottom.constant=0
                
                self.viewBlurMenuTop.constant=0
                self.viewBlurMenuBottom.constant=0
                self.viewForBackground.isHidden=false
                
                self.view.layoutIfNeeded()
        })
        {
            (value:Bool) in
            
        }
        
    }
    func hideDownMenuWithAnimation()
    {
        
        //------------------jig's Code-------------------------
        
        ///For Hide Only
        
        UIView.animate(withDuration: 0.1, animations:
            {
                self.viewBlurMenuTop.constant=1024
                self.viewBlurMenuBottom.constant = -1024
                self.viewBackgroundBottom.constant = -1024
                self.viewBackgroundTop.constant=1024
                self.viewForBackground.isHidden=false
                self.view.layoutIfNeeded()
        })
        
    }
    
 
   @IBAction func btn_PoorRoads_Clicked(sender: AnyObject)
    {
        
        strCategory="a"
        imgPoorRoadsSel.isHidden=false
        imgPoorLightSel.isHidden=true
        imgNeighbourhdSel.isHidden=true
        
    }
    
    @IBAction func btn_UnsafeNeighbour_clicked(sender: AnyObject)
    {
        strCategory="c"
        
        imgPoorRoadsSel.isHidden=true
        imgPoorLightSel.isHidden=true
        imgNeighbourhdSel.isHidden=false
        
        
    }
    @IBAction func btn_PoorLIghting_clicked(sender: AnyObject)
    {
        strCategory="b"
        
        imgPoorRoadsSel.isHidden=true
        imgPoorLightSel.isHidden=false
        imgNeighbourhdSel.isHidden=true
        
        
    }
    
    
   @IBAction func btn_NeighbourCondition_Clicked(sender: UIButton)
    {
        
        strCategory=""
        
        if sender.tag==10
        {
            SetUpNeighbourhoodView()
        }
        else if sender.tag==11
        {
            imgHeaderOthers.image=UIImage (named: "Robbery")
            lblCrimeTitleTypeOS.text="Robbery"
            SetUpOtherView()
            strCategory="2"
        }
        else if sender.tag==12
        {
            imgHeaderOthers.image=UIImage (named: "Assault")
            lblCrimeTitleTypeOS.text="Assault"
            SetUpOtherView()
            strCategory="3"
            
        }
        else if sender.tag==13
        {
            imgHeaderOthers.image=UIImage (named: "Arson")
            lblCrimeTitleTypeOS.text="Arson"
            SetUpOtherView()
            strCategory="4"
            
        }
        else if sender.tag==14
        {
            imgHeaderOthers.image=UIImage (named: "Rape")
            lblCrimeTitleTypeOS.text="Rape"
            SetUpOtherView()
            strCategory="5"
            
        }
        else if sender.tag==15
        {
            imgHeaderOthers.image=UIImage (named: "Violet Crime Murder")
            lblCrimeTitleTypeOS.text="Violet Crime Murder"
            SetUpOtherView()
            strCategory="6"
            
        }
        else if sender.tag==16
        {
            imgHeaderOthers.image=UIImage (named: "Default")
            lblCrimeTitleTypeOS.text="Other"
            SetUpOtherView()
            strCategory="7"
        }
        
    }
    
    
   @IBAction func btn_Cancel_clicked(sender: AnyObject)
    {
        self.viewMainViewOfMenu.isHidden=false
        self.animateNeighbourDown()
        lblSelectCrimeType.isHidden=false
        self.clearForm()
    }
    
    func animateNeighbourDown()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewNeighbourTop.constant = 1024
            self.NeighbourBottomConstraint.constant = -1024
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func clearForm()
    {
        txtViewCommentOS.text=""
        txtViewComments.text=""
        strCategory=""
        imgPoorRoadsSel.isHidden=true
        imgPoorLightSel.isHidden=true
        imgNeighbourhdSel.isHidden=true
        
    }
    @IBAction func btn_Send_clicked(sender: AnyObject)
    {
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
        
        if strCategory == "" {
            
            Constant.AlertViewNew(Title: "Crime Type Required", Message: "Please Select Crime Type", ViewController: self)
            return
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        isHidden=false
        self.setNeedsStatusBarAppearanceUpdate()
        lblSelectCrimeType.isHidden=false
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Please wait...")
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: (self.Map.userLocation?.coordinate.latitude)!, longitude: (self.Map.userLocation?.coordinate.longitude)!), completionHandler: { (placemarks, e) -> Void in
            if e != nil
            {
                //print("Error:  \(e!.localizedDescription)")
                
            }
            else
            {
                let placemark = placemarks!.last! as CLPlacemark
                let userInfo =
                    [
                        "city":     placemark.locality!,
                        "state":    placemark.administrativeArea!,
                        "country":  placemark.country!,
                        "Code":   placemark.postalCode!
                ]
                
                let User_id=(Constant.USERDEFAULT .value(forKey: "UserID"))!
                
              
                
                self.txtViewComments.text=""
                
                let Latt = String(format: "%f", self.NewUpdatedLocation.coordinate.latitude)
                
                let longg = String(format: "%f", self.NewUpdatedLocation.coordinate.longitude)
                
                let params:[String : String] = ["user_id": User_id as! String ,"latitude":Latt ,"longitude":longg ,"country": placemark.country!,"city": placemark.locality!,"category": self.strCategory!,"comment":self.txtViewComments.text]
                
                print(params)
                
                Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/add_crime.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result)
                    {
                        
                    case .success(_):
                        print("Response: \((response.result.value) as AnyObject!)")
                        
                        Constant.APPDELEGATE.hideLoadingHUD()
                        
                        var dict = JSON(response.result.value ?? "").dictionaryValue
                        
                        Constant.APPDELEGATE.hideLoadingHUD()
                        
                        self.clearForm()
                        
                        
                        let str = dict["status"]?.dictionaryValue["sucess"]?.stringValue
                        if (str? .isEqual("1"))!
                        {

                            
                            self.WebServiceCallForAnnotationsPloatting()
                        }
                        else
                        {

                        }
                        
                        break
                        
                    case .failure(_):
                        Constant.APPDELEGATE.hideLoadingHUD()
                        Constant.ConnectionFailAlert(ViewController: self)
                        break
                        
                    }
                }
                

                
                print("Location:  \(userInfo)")
                
                let Country_name:NSString=placemark.country! as NSString
                
                
                if ((Country_name as NSString) .isEqual(to: Constant.USERDEFAULT.value(forKey: "Country_name") as! String))
                {
                    
                    Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    var Imagecode:NSString = NSString(format: "%@",Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
                    
                    print(Imagecode)
                    
                    Imagecode = Imagecode.appending(".png") as NSString
                    
                    self.CountryImage.image=UIImage(named:Imagecode as String)
                }
                else
                {
                    
                    Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    self.parseJson(country: Country_name)
                }
                
            }
        })
        
        
        self.animateNeighbourDown()
        
        self.hidePinmenu()
        
    }
    
    
  
    
    @IBAction func btn_CacelOther_clicked(sender: AnyObject)
    {
        // self.viewMainViewOfMenu.hidden=false
        self .SetUpInnerView()
        self.animateOtherViewDown()
        lblSelectCrimeType.isHidden=false
        self.clearForm()
        
    }
    
    func animateOtherViewDown()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewOtherTop.constant = 1024
            self.OtherBottomConstraint.constant = -1024
            
            // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            
        })
        
    }
    
   @IBAction func btn_okOther_clicked(sender: AnyObject)
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        self.animateOtherViewDown()
        
        self.hidePinmenu()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        isHidden=false
        self.setNeedsStatusBarAppearanceUpdate()
        
        lblSelectCrimeType.isHidden=false
        
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Loading...")
        
        
        let geocoder = CLGeocoder()
        
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: (self.Map.userLocation?.coordinate.latitude)!, longitude: (self.Map.userLocation?.coordinate.longitude)!), completionHandler: { (placemarks, e) -> Void in
            if e != nil
            {
                //print("Error:  \(e!.localizedDescription)")
                
            }
            else
            {
                let placemark = placemarks!.last! as CLPlacemark
                let userInfo =
                    [
                        "city":     placemark.locality!,
                        "state":    placemark.administrativeArea!,
                        "country":  placemark.country!,
                        "Code":   placemark.postalCode!
                ]
                
                let User_id=(Constant.USERDEFAULT .value(forKey: "UserID"))!
                
               
                
                self.clearForm()
                
                let Latt = String(format: "%f", (self.Map.userLocation?.coordinate.latitude)!)
                
                let longg = String(format: "%f", (self.Map.userLocation?.coordinate.longitude)!)
                
                let params:[String : String] = ["user_id":User_id as! String ,"latitude":Latt ,"longitude":longg ,"country":placemark.country!,"city":placemark.locality!,"category":self.strCategory!,"comment":(self.txtViewCommentOS.text)]
                
                
                Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/add_crime.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result)
                    {
                        
                    case .success(_):
                        print("Response: \((response.result.value)! as AnyObject!)")
                        
                        Constant.APPDELEGATE.hideLoadingHUD()
                        
                        
                        
                        self.clearForm()
                        
                        
                        break
                        
                    case .failure(_):
                        Constant.APPDELEGATE.hideLoadingHUD()
                        Constant.ConnectionFailAlert(ViewController: self)
                        break
                        
                    }
                }
                
                
                print("Location:  \(userInfo)")
                
                let Country_name:NSString=placemark.country! as NSString
                
                
                if ((Country_name as NSString) .isEqual(to: Constant.USERDEFAULT.value(forKey: "Country_name") as! String))
                {
                    
                    Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    var Imagecode:NSString = NSString(format: "%@",Constant.USERDEFAULT.value(forKey: "Country_Image_Code") as! String)
                    
                    //print(Imagecode)
                    
                    Imagecode = Imagecode.appending(".png") as NSString
                    
                    self.CountryImage.image=UIImage(named:Imagecode as String)
                }
                else
                {
                    
                    Constant.USERDEFAULT.setValue(Country_name, forKey: "Country_name")
                    
                    Constant.USERDEFAULT .synchronize()
                    
                    self.parseJson(country: Country_name)
                }
                
            }
        })
        
    }
    
   @IBAction  func btn_CommentOfPinDetail_clicked(sender: AnyObject)
    {
        self.hidePinDetail()
        let controller:CommentsViewController=self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        // dictForDetail
        controller.dictForDetail=dic
        print(strPassCrime)
        controller.strImgName=strPassCrime
        self .present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btn_Close_clicked(sender: AnyObject)
    {
        viewForBackground.isHidden=false
        animateInnerViewDown()
        viewMainViewOfMenu.isHidden=false
    }
    
    @IBAction func btn_RunCondition_clicked(sender: AnyObject)
    {
        SetUpNeighbourhoodView()
    }
    
    @IBAction func btn_Crime_Clicked(sender: AnyObject) {
        
        SetUpInnerView()
    }
    
    @IBAction func btn_SocialMedia_clicked(sender: AnyObject) {
        
        setUpSocialShare()
    }
    
    
    @IBAction func btn_CloseMainMenu_clicked(sender: AnyObject)
    {
        hideDownMenuWithAnimation()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        isHidden=false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    @IBAction func btn_FaceBookShare_clicked(sender: AnyObject)
    {
        FaceBookSharing()
    }
    
    @IBAction func btn_WhatsAppShare_clicked(sender: AnyObject)
    {
        WhatsAppSharing()
    }
    
    @IBAction func btn_LineShare_clicked(sender: AnyObject)
    {
        LineSharing()
    }
    
    @IBAction func btn_WeChatShare_clicked(sender: AnyObject)
    {
        WeChatSharing()
    }
    
    @IBAction func btn_CloseSocial_clicked(sender: AnyObject)
    {
        animateSocialDown()
        setUpMainView()
    }
    
  @IBAction  func btn_UpDwn_polyLineDetail_clicked(sender: AnyObject)
    {
        btnUpDwnOfPolylineDetail.showsTouchWhenHighlighted=false
        
        
        if up==true
        {
            up=false
            hidePolyLineDetail()
            
        }
        else
        {
            up=true
            showPolyLineDetail()
            
        }
        
        
    }
    
    @IBAction func btn_StopPolyline_clicked(sender: AnyObject)
    {
       self.Map.addGestureRecognizer(TapGesture!)
        
        Constant.APPDELEGATE.ReceiveNotification=false
        
        SendDownPolyLineDetail()
        showEmergencyCall()
        self.Map.removeAnnotation(self.routeLine!)
        self.Map.removeAnnotation((self.Map.annotations?.last)!)
        setCameraToNormalMode()
        
    }
    
   @IBAction func btn_ClosePolyLineDetail_clicked(sender: AnyObject)
    {
        btn_UpDwn_polyLineDetail_clicked(sender: self)
    }
    
    
    
    //MARK:- APNSButton Click
   @IBAction func APNSButtonClick(sender: UIBarButtonItem)
    {
        self.APNSWebserviceCall()
    }
    
    //MARK: APNS Emergency Webservice
    func APNSWebserviceCall()
    {
        var ContactArray:NSArray=NSArray()
        
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
        }
        
        if (Constant.USERDEFAULT.value(forKey: "SelectedContacts") != nil)
        {
            ContactArray=(Constant.USERDEFAULT.object(forKey: "SelectedContacts") as? NSArray)!
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please first select contacts from the setting.", ViewController: self)
            return
        }
        
        print(ContactArray)
        
        
        let FinalContactArray:NSMutableArray=NSMutableArray()
        
        if ContactArray.count>0
        {
            for i in 0 ..< ContactArray.count
            {
                var Cstr:String=((ContactArray.object(at: i) as AnyObject).value(forKey:"number") as? String)!
                Cstr = Cstr.replacingOccurrences(of: "-", with: "")
                Cstr = Cstr.replacingOccurrences(of: "[^+0-9]", with: "", options: NSString.CompareOptions.regularExpression, range: nil
                )
               
                
                FinalContactArray.add(Cstr)
            }
        }
        else
        {
            Constant.AlertViewNew(Title: "Runsafe", Message:"Please first select contacts from the setting.", ViewController: self)
            return
        }
        
        
        let User_id=(Constant.USERDEFAULT.value(forKey:"UserID"))!
        
        let message:String=Constant.USERDEFAULT.value(forKey:"CustomMessage") as! String
        
        print(message)
        
        
        if message.isEmpty == true
        {
            Constant.AlertViewNew(Title: "Runsafe", Message:"Go to setting and add Custom message for emergency.", ViewController: self)
            return
        }
        
        Constant.APPDELEGATE .showLoadingHUD(navigation: self.navigationController!, withText: "We're sending emergency message")
        
        var FinalContactStr:String=String(stringInterpolation:"\(FinalContactArray)")
        
        FinalContactStr = FinalContactStr.replacingOccurrences(of: " ", with: "")
        FinalContactStr = FinalContactStr.replacingOccurrences(of: "\n", with: "")
        FinalContactStr = FinalContactStr.replacingOccurrences(of: "\"", with: "")
        FinalContactStr = FinalContactStr.replacingOccurrences(of: "(", with: "")
        FinalContactStr = FinalContactStr.replacingOccurrences(of: ")", with: "")
        FinalContactStr = FinalContactStr.replacingOccurrences(of: "", with: "")
        let Latt = String(format: "%f", (self.Map.userLocation?.coordinate.latitude)!)
        
        let longg = String(format: "%f", (self.Map.userLocation?.coordinate.longitude)!)
        
        let params:[String : String] = ["user_id":User_id as! String ,"latitude":Latt ,"longitude":longg ,"contacts":FinalContactStr,"message":message]

        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/push.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
             print(response.result)
            switch(response.result)
                
            {
               
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                var dict = JSON(response.result.value ?? "").dictionaryValue
                
                let StatusStr = dict["status"]?.dictionaryValue ["sucess"]?.stringValue
                
                if (StatusStr? .isEqual("1"))!
                {
                    Constant.showToastMessage(withTitle: Constant.AppName, message: "Emergency Message sent to your friends successfully.", in: self.view, animation: true)
                }
                else
                {
                    Constant.showToastMessage(withTitle: "Runsafe", message: "Please check your selected number is not proper.", in: self.view, animation: true)
                }
                
                break
                
            case .failure(_):
                Constant.APPDELEGATE.hideLoadingHUD()
                Constant.ConnectionFailAlert(ViewController: self)
                break
                
            }
        }
        
    }
    
    
    func hideAllForNotificationArrived()
    {
        hidePinmenu()
        hidePinDetail()
        hideDownMenuWithAnimation()
        
    }
    
    func CheckForNotification()
    {
        //Display Data which you got from notification
        
        var arr: [AnyObject] = Constant.APPDELEGATE.NotificationContent!.components(separatedBy:"/") as [AnyObject]
        
        
        let strMessage:NSString = arr[0] as! NSString
        
        let AlertView = UIAlertController(title:"Runsafe", message:strMessage as String,preferredStyle: .alert)
        
        let Continue:UIAlertAction=UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            
            //Drow Polyline Code Here
            
            let strLatitude:NSString = arr[1] as! NSString
            let strLongitude:NSString = arr[2] as! NSString
            //   let strAddress:String = arr[3] as! String
            
            let latitude = (strLatitude as NSString).doubleValue
            
            let longitude = (strLongitude as NSString).doubleValue
            print(latitude)
            print(longitude)
            
            let toCoordinate:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            
            Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Fetching Route...")
            
            if(AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
            {
                Constant.InternetNewAlert(ViewController: self)
                return
            }
            
            self.removeOldPinAndPolylineFromMap()
            
            self .wayPointswithcordinates(fromCoordinate: (self.Map.userLocation?.coordinate)!, toCoordinate: toCoordinate)
            
            self.pointFromNotification = NewAnnotation(title: "Destination", subtitle: "Destination", coordinate: CLLocationCoordinate2D(latitude:toCoordinate.latitude,longitude: toCoordinate.longitude), image:UIImage(named: "finish")! , reuseIdentifier:"other")
            
            self.Map.addAnnotation(self.pointFromNotification!)
            
        })
        
        let Cancel:UIAlertAction=UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            AlertView.dismiss(animated: true, completion: nil)
            
            // UIApplication.sharedApplication().applicationIconBadgeNumber=0
            Constant.APPDELEGATE.ReceiveNotification=false
            
        })
        
        AlertView.addAction(Cancel)
        AlertView.addAction(Continue)
        
        self.present(AlertView, animated: true, completion: nil)
        
    }
    
    func removeOldPinAndPolylineFromMap()
    {
        if self.point != nil
        {
            let poly2:MGLAnnotation=self.polyLineRef as! MGLAnnotation
            
            self.Map.removeAnnotation(poly2)
            
            let poly:MGLPolyline=self.polyLineRef as! MGLPolyline
            
            self.Map.removeAnnotation(poly)
            
            self.Map.removeAnnotation(self.pinRef!)
        }
    }
}

