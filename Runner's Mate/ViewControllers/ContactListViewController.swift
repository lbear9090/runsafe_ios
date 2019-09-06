//
//  ContactListViewController.swift
//  Ceres8
//
//  Created by Lucky on 8/25/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
@available(iOS 9.0, *)

class ContactListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{

    
    
    @IBOutlet var tableContactList: UITableView!
    var Cell:ContactTableViewCell!
    
    var SearchContactArray:NSMutableArray?=NSMutableArray()
    
    var SelectedFriend:NSMutableArray=NSMutableArray()
    
    var selectedIndex:NSMutableArray=NSMutableArray()
    
    var aryTemp:NSMutableArray? = NSMutableArray()
    
    var arySelectedContacts:NSMutableArray=NSMutableArray()
    
    var words2:NSMutableArray?=NSMutableArray()
    
    @IBOutlet var ClearSelection: UIButton!
    
    var store = CNContactStore()
    
    var searchActive : Bool = false
    
    @IBOutlet var ContactListSearchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        ContactListSearchBar.delegate = self
        
        if Constant.USERDEFAULT .object(forKey: "SelectedContacts") != nil
        {
            let ary:NSArray = (Constant.USERDEFAULT.object(forKey: "SelectedContacts") as? NSArray)!
            
            for k in 0 ..< ary.count
            {
                SelectedFriend .add(ary .object(at: k))
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        LoadContact()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        ClearSelection.layer.borderColor=UIColor.lightGray.cgColor
        ClearSelection.layer.borderWidth=1
        ClearSelection.layer.cornerRadius=3
        ClearSelection.clipsToBounds=true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    //MARK:- Check For Notification
    @objc func CheckForNotification()
    {
        Constant.APPDELEGATE.ReceiveNotification=true
        
        let tabBarController = (UIApplication.shared.keyWindow!.rootViewController as! UITabBarController)
        
        tabBarController.selectedIndex = 0;
    }
    
    //MARK:- Load Contacts
    func LoadContact()
    {
        if (Constant.USERDEFAULT.object(forKey: "AllContact") != nil)
        {
            words2! .removeAllObjects()
            self.aryTemp!.removeAllObjects()
            words2=NSMutableArray(array: (Constant.USERDEFAULT.object(forKey: "AllContact") as? NSArray)!)
            
            self.aryTemp=self.words2
            
       
            
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.tableContactList.reloadData()
            })
        }
        else
        {
            words2! .removeAllObjects()
            self.aryTemp!.removeAllObjects()
            self.FetchContacts()
        }
        
    }
    
    //MARK:- TableView Delegte
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(searchActive==true)
        {
            return  SearchContactArray!.count
        }
        else
        {
            return aryTemp!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Identifire:String="contactCell"
        
        Cell = self.tableContactList.dequeueReusableCell(withIdentifier: Identifire)as! ContactTableViewCell
        
        if(searchActive==true)
        {
            Cell.lblName.text=(SearchContactArray!.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
        }
        else
        {
            Cell.lblName.text=(aryTemp!.object(at: indexPath.row) as AnyObject).value(forKey: "name")as? String
        }
        
        
        Cell.lblPreFix.layer.cornerRadius=25
        Cell.lblPreFix.clipsToBounds=true
        
        Cell.lblPreFix.backgroundColor = self.getRandomColor()
        
        let TempStr:NSString = Cell.lblName.text! as NSString
        
        let Charstr:NSString=TempStr.substring(to: 1) as NSString
        
        Cell.lblPreFix.text = Charstr as String
        
        
        if(searchActive==true)
        {
            if SelectedFriend.count>0
            {
                for i in 0 ..< SelectedFriend.count
                {
                    print(i)
                    if SelectedFriend .contains((SearchContactArray?.object(at: indexPath.row))!)
                    {
                        Cell.accessoryType = .checkmark
                    }
                    else
                    {
                        Cell.accessoryType = .none
                    }
                }
            }
            else
            {
                Cell.accessoryType = .none
            }
            
        }
        else
        {
            if SelectedFriend.count>0
            {
                for i in 0 ..< SelectedFriend.count
                {
                    print(i)
                    
                    if SelectedFriend .contains((aryTemp?.object(at: indexPath.row))!)
                    {
                        Cell.accessoryType = .checkmark
                    }
                    else
                    {
                        Cell.accessoryType = .none
                    }
                }
            }
            else
            {
                Cell.accessoryType = .none
            }
            
        }
        
        return Cell
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        ContactListSearchBar.isUserInteractionEnabled=false
    }
    
    func scrollViewDidScroll( _ scrollView: UIScrollView)
    {
        ContactListSearchBar.isUserInteractionEnabled=true
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("Selected Row Number is:: %ld", indexPath.row)
        
        Cell=tableContactList.cellForRow(at: indexPath as IndexPath)as! ContactTableViewCell
        
        if(searchActive==true)
        {
            if Cell.accessoryType == .none
            {
                
                if SelectedFriend.contains((SearchContactArray?.object(at: indexPath.row))!)
                {
                
                    Cell.accessoryType = .checkmark
                    
                }
                else
                {
                    

                    
                    SelectedFriend.add(SearchContactArray! .object(at: indexPath.row))
                    
                    Cell.accessoryType = .checkmark
                }
                
            }
            else
            {
                Cell.accessoryType = .none
                
                if SelectedFriend.count>0
                {
                    if SelectedFriend.contains((SearchContactArray?.object(at: indexPath.row))!)
                    {
                        SelectedFriend.remove((SearchContactArray?.object(at: indexPath.row))!)
                    }
 
                }
            }
            
            tableContactList .deselectRow(at: indexPath as IndexPath, animated: true)
            
        }
        else
        {
            if Cell.accessoryType == .none
            {
                
                if SelectedFriend.contains((aryTemp?.object(at: indexPath.row))!)
                {
                    Cell.accessoryType = .checkmark
                }
                else
                {

                   
                    SelectedFriend .add(aryTemp! .object(at: indexPath.row))
                    Cell.accessoryType = .checkmark
                }
                
            }
            else
            {
                Cell.accessoryType = .none
                
                if SelectedFriend.count>0
                {
                    if SelectedFriend.contains((aryTemp?.object(at: indexPath.row))!)
                    {
                        SelectedFriend.remove((aryTemp?.object(at: indexPath.row))!)
                    }
                }
            }
            tableContactList .deselectRow(at: indexPath as IndexPath, animated: true)
        }
        
        NSLog("SelectedFriend===%@", SelectedFriend)
        
    }
    
    //MARK:- Random Color Method
    
    func getRandomColor() -> UIColor
    {
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63
        
    }
    
    //MARK:- Cancel Click
    
    @IBAction func btn_cancel_Clicked(sender: AnyObject)
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Done Click
    
    @IBAction func btn_Done_Clicked(sender: AnyObject)
    {
       
        Constant.USERDEFAULT .setValue(SelectedFriend, forKey: "SelectedContacts")
        
        Constant.USERDEFAULT .synchronize()
        
        print(Constant.USERDEFAULT.value(forKey: "SelectedContacts") as Any)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- ReLoad Contacts-  Refresh Click
    
    @IBAction func RefreshClick(sender: UIBarButtonItem)
    {
        self.FetchContacts()
    }
    
    //MARK:- Clear Seletion Click
    
    @IBAction func ClearSeletionClick(sender: UIButton)
    {
        
       SelectedFriend .removeAllObjects()
     
        Constant.USERDEFAULT .setValue(SelectedFriend, forKey: "SelectedContacts")
        
        Constant.USERDEFAULT .synchronize()

       

        DispatchQueue.main.async(execute: {() -> Void in
            self.tableContactList.reloadData()
        })
       
    }
    
    
    //MARK:- Fetch Contacts
    
    func FetchContacts()
    {
        words2!.removeAllObjects()
        self.aryTemp!.removeAllObjects()
        

        DispatchQueue.main.async(execute: {() -> Void in
            self.tableContactList.reloadData()
        })
        let contactStore = CNContactStore()
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus
        {
        case .authorized:
            self.arySelectedContacts.removeAllObjects()
            
            Constant.APPDELEGATE.showLoadingHUD(navigation: self.navigationController!, withText: "Please Wait While Fetching Contacts...")
            
            DispatchQueue.global().async(execute: {
                do {
                    try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor,CNContactFamilyNameKey as CNKeyDescriptor])) {
                        (contact, cursor) -> Void in
                        
                        
                        if (contact.phoneNumbers.isEmpty)
                        {
                            
                        }
                        else
                        {
                            self.arySelectedContacts.add(contact)
                        }
                    }
                }
                catch{
                    print("Handle the error please")
                }
                
                self.words2!.removeAllObjects()
                self.aryTemp!.removeAllObjects()
             
                for i in 0 ..< self.arySelectedContacts.count
                {
                    let dictContact:NSMutableDictionary=NSMutableDictionary()
                    
                    
                    
                    if let actualNumber = (self.arySelectedContacts.object(at: i) as AnyObject).phoneNumbers.first?.value
                    {
                        if (self.arySelectedContacts.object(at: i) as AnyObject).givenName != ""
                        {
                            let Name:NSString=NSString(format: "%@ %@ %@",(self.arySelectedContacts.object(at: i) as AnyObject).givenName,(self.arySelectedContacts.object(at: i) as AnyObject).middleName,(self.arySelectedContacts.object(at: i) as AnyObject).familyName)
                            
                            
                            if actualNumber.isProxy()
                            {
                                
                                
                            }
                            else
                            {
                                _ = actualNumber.stringValue
                                
                                for num in (self.arySelectedContacts.object(at: i) as AnyObject).phoneNumbers
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
                            self.words2!.add(dicTemp)
                        }
                    }
                }
                
                Constant.USERDEFAULT.set(self.words2, forKey: "AllContact")
                
                Constant.USERDEFAULT.synchronize()
                
                self.aryTemp=self.words2
                
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.tableContactList.reloadData()
                     Constant.APPDELEGATE.hideLoadingHUD()
                })
               
                
            })
            

            
        case .denied, .notDetermined:
            
            contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access
                {
                    self.FetchContacts()
                }
                else
                {
                    Constant.AlertViewNew(Title: "Runsafe", Message: "Please allow the app to access your contacts through the Settings.", ViewController: self)
                }
            })
            
            
        default: break
            
        }
    }
    
    //MARK:- SearchBar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
       // searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = false;
        searchBar.text=nil;
        
        //  let TempArray:NSArray=NSArray(array: self.aryTemp!)
        
        // SearchContactArray?.addObjectsFromArray(TempArray as [AnyObject])
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableContactList.reloadData()
//        })
        DispatchQueue.main.async(execute: {() -> Void in
            self.tableContactList.reloadData()
        })
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if (searchText.characters.count == 0)
        {
            searchActive = false;
        }
        else
        {
            searchActive = true;
        }
        
        let TempSearchArray:NSMutableArray?=NSMutableArray()
        
        for i in 0..<self.aryTemp!.count
        {
            let strval1:String = (self.aryTemp?.object(at: i) as AnyObject).value(forKey: "name") as! String
            
            
           // let range2 = strval1.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            let range2 = strval1.range(of: searchText, options: .caseInsensitive)
            
            if range2 != nil
            {
                let myCountOfRange = strval1[range2!].characters.count
                
                if myCountOfRange > 0
                {
                    TempSearchArray?.add((self.aryTemp?.object(at: i))!)
                }
            }            
        }
        
        SearchContactArray?.removeAllObjects()
        
        SearchContactArray=TempSearchArray
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableContactList.reloadData()
//        })
        DispatchQueue.main.async(execute: {() -> Void in
            self.tableContactList.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
