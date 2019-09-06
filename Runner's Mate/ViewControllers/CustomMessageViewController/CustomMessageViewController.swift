//
//  CustomMessageViewController.swift
//  Runners Mate
//
//  Created by Apple on 07/10/16.
//  Copyright © 2016 Lucky. All rights reserved.
//   DispatchQueue.main.async(execute: {() -> Void in
//self.tableContactList.reloadData()
//})

import UIKit
import Foundation

class CustomMessageViewController: UIViewController,MGSwipeTableCellDelegate,UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource
{

    @IBOutlet var MessageTable: UITableView!
    
    var MessageArray:NSMutableArray?
    
    var CMessageCell:CustomMessageCell!
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
    }
    
    //MARK:- ViewWill Appear
    override func viewWillAppear(_ animated: Bool)
    {
        MessageArray =  NSMutableArray(array: Constant.USERDEFAULT.array(forKey: "CustomMessageArray")!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }

    @objc func CheckForNotification()
    {
        Constant.APPDELEGATE.ReceiveNotification=true
        
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    
    
    //MARK:- TableView Delegate
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (MessageArray?.count)! > Int(0)
        {
            return (MessageArray?.count)! + 1
            
        }
        else
        {
            return 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
   
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    override func viewDidLayoutSubviews()
    {
        if(self.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            MessageTable.separatorInset = UIEdgeInsets.zero
        }
        if(self.responds(to: #selector(setter: UIView.layoutMargins))){
            MessageTable.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (MessageArray?.count)! > Int(0)
        {
            if (indexPath.row == MessageArray?.count)
            {
                let cell:UITableViewCell = self.MessageTable.dequeueReusableCell(withIdentifier: "AddmessageCell")! as UITableViewCell
                
                let txtAddedComment:UITextField=cell.viewWithTag(32) as! UITextField
                txtAddedComment.delegate=self
                txtAddedComment.placeholder="Add Message"
                
                let btnDone:UIButton=cell.viewWithTag(33) as! UIButton
                btnDone.addTarget(self, action: #selector(btn_AddMessage_clicked), for: UIControlEvents.touchUpInside)
                
                btnDone.layer.cornerRadius = 5;

                return cell
            }
            else
            {
                CMessageCell=self.MessageTable.dequeueReusableCell(withIdentifier: "CustomMessageCell") as! CustomMessageCell
                
                
                let  StrMessage1:NSString=self.MessageArray?.object(at: indexPath.row) as! NSString
                
                let currentMessage1:NSString=Constant.USERDEFAULT.value(forKey: "CustomMessage") as! NSString
                
                if StrMessage1.isEqual(to: currentMessage1 as String)
                {
                    CMessageCell.backgroundColor=UIColor.lightGray
                }
                else
                {
                    CMessageCell.backgroundColor=UIColor.white
                }
                
                
                let lblComment:UILabel = CMessageCell.viewWithTag(21) as! UILabel
                
                
                lblComment.text=MessageArray?.object(at: indexPath.row) as? String
                
                let DeleteBtn=MGSwipeButton(title: "Delete", backgroundColor: UIColor.red, padding: 20, callback: { (sender: MGSwipeTableCell!) -> Bool in
                    
                    let  StrMessage:NSString=self.MessageArray?.object(at: indexPath.row) as! NSString
                    
                    let currentMessage:NSString=Constant.USERDEFAULT.value(forKey: "CustomMessage") as! NSString
                    
                    if StrMessage.isEqual(to: currentMessage as String)
                    {
                        
                          Constant.showToastMessage(withTitle: Constant.AppName, message: "You can't Delete this message,You have selected this message.", in: self.view, animation: true)
                    }
                    else
                    {
                        self.MessageArray?.removeObject(at: indexPath.row)
                        
                        Constant.USERDEFAULT.set(self.MessageArray, forKey: "CustomMessageArray")
                        
                        Constant.USERDEFAULT.synchronize()
                        DispatchQueue.main.async(execute:  { () -> Void in
                            self.MessageTable.reloadData()
                        })

                    }
                    return true
                })
                
                
                let EditBtn=MGSwipeButton(title: "Edit", backgroundColor: UIColor.green, padding: 20, callback: { (sender: MGSwipeTableCell!) -> Bool in
                    
                    let passwordPrompt = UIAlertController(title: "Edit your message", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    passwordPrompt.addTextField(configurationHandler: { (textField: UITextField!) in
                        textField.text=self.MessageArray?.object(at: indexPath.row) as? String
                        })
                    
                    passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                    
                    passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                        
                        let TextFinal:UITextField=passwordPrompt.textFields![0]
                        
                        let InputStr:NSString=TextFinal.text! as NSString
                        
                        if (InputStr .isEqual(to: " ") || InputStr .isEqual(to: ""))
                        {
                            
                               Constant.showToastMessage(withTitle: Constant.AppName, message: "Please Enter message", in: self.view, animation: true)
                        }
                        else
                        {
                            
                            let  StrMessage:NSString=self.MessageArray?.object(at: indexPath.row) as! NSString
                            
                            let currentMessage:NSString=Constant.USERDEFAULT.value(forKey: "CustomMessage") as! NSString
                            
                            if StrMessage.isEqual(to: currentMessage as String)
                            {
                                Constant.USERDEFAULT.setValue(InputStr, forKey: "CustomMessage")
                            }
                            
                            self.MessageArray?.replaceObject(at: indexPath.row, with: InputStr)
                          
                            Constant.USERDEFAULT.set(self.MessageArray, forKey: "CustomMessageArray")
                            
                            Constant.USERDEFAULT.synchronize()
                            
                            DispatchQueue.main.async(execute:  { () -> Void in
                                self.MessageTable.reloadData()
                            })

                            passwordPrompt.dismiss(animated: true, completion: nil)
                        }
                    }))
                    
                    self.present(passwordPrompt, animated: true, completion: nil)

                    
                    return true
                })
                
                
                CMessageCell.rightButtons = [DeleteBtn as Any,EditBtn as Any]
                
                CMessageCell.rightSwipeSettings.transition=MGSwipeTransition.static
                
                CMessageCell.delegate = self
                
                return CMessageCell
                

            }
        }
        else
        {
            let cell:UITableViewCell = self.MessageTable.dequeueReusableCell(withIdentifier: "AddmessageCell")! as UITableViewCell
            
            let txtAddedComment:UITextField=cell.viewWithTag(32) as! UITextField
            txtAddedComment.delegate=self
            txtAddedComment.placeholder="Add Message"
            
            let btnDone:UIButton=cell.viewWithTag(33) as! UIButton
            btnDone.addTarget(self, action: #selector(btn_AddMessage_clicked), for: UIControlEvents.touchUpInside)
            
            btnDone.layer.cornerRadius = 5;
            
            return cell
        }
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == MessageArray?.count
        {
          return
        }
        else
        {
            let Message:NSString=MessageArray?.object(at: indexPath.row) as! NSString
            
            Constant.USERDEFAULT.setValue(Message, forKey: "CustomMessage")
            Constant.USERDEFAULT.synchronize()

            DispatchQueue.main.async(execute:  { () -> Void in
                self.MessageTable.reloadData()
            })

        }
   }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to:MessageTable)
        var contentOffset:CGPoint = MessageTable.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        MessageTable.contentOffset = contentOffset
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField.superview!.superview?.superview is UITableViewCell)
        {
            let cell: UITableViewCell = (textField.superview!.superview?.superview as! UITableViewCell)
            
            let indexPath: NSIndexPath = MessageTable.indexPath(for: cell)! as NSIndexPath
            
            MessageTable.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func btn_AddMessage_clicked(sender: AnyObject)
    {
        let path:NSIndexPath=NSIndexPath(row:MessageArray!.count, section: 0)

        let cell: UITableViewCell = self.MessageTable.cellForRow(at: path as IndexPath)!
        
        let txtAddedComment:UITextField=cell.viewWithTag(32) as! UITextField
        
        let NewMessageStr:NSString=txtAddedComment.text! as NSString
        
        if (NewMessageStr .isEqual(to: " ") || NewMessageStr .isEqual(to: ""))
        {
              Constant.showToastMessage(withTitle:Constant.AppName, message: "Please add custom message", in: self.view, animation: true)
        }
        else
        {
            MessageArray?.add(NewMessageStr)
            Constant.USERDEFAULT.set(MessageArray, forKey: "CustomMessageArray")
            Constant.USERDEFAULT.synchronize()
            
            txtAddedComment.text=""
            DispatchQueue.main.async(execute:  { () -> Void in
                self.MessageTable.reloadData()
            })

        }
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
