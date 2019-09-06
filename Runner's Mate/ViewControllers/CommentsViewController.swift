//
//  CommentsViewController.swift
//  Ceres8
//
//  Created by Lucky on 8/15/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UtilityDelegate,URLSessionDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    @IBOutlet var table: UITableView!
    
    var Comment_Arr: NSMutableArray? = []

    var dictForDetail:NSDictionary?
    
    var strImgName:String=""
    
    var strLat:String=""
    
    var receivedData:NSMutableData?
    
    var strLong:String=""
    
    var strComment:String=""
    
    
    var Util:UtilityClass=UtilityClass()
    
    // var ViewForAddComment:UIView?
    // var cell:UITableViewCell?
    //  var btnAddComment:UIButton?
    // var txtAddedComment:UITextField?
    //  var btnDone:UIButton?
    //   var btnCancel:UIButton?
   
    var strCrimeId:String=""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //JSON(dic).dictionaryValue["main_comment"]?.stringValue
        
        print(dictForDetail)
        
        Comment_Arr=NSMutableArray(array: (JSON(dictForDetail as Any).dictionaryValue["comments"]?.arrayValue)!)
        
        strLat=JSON(dictForDetail as Any).dictionaryValue["latitude"]!.stringValue
        
        strLong=JSON(dictForDetail as Any).dictionaryValue["longitude"]!.stringValue
      
        print(strImgName)
        
        if strImgName == "Poor Roads"
        {
            strCrimeId="a"
        }
        else if strImgName == "Poor Lighting"
        {
            strCrimeId="b"
        }
        else if strImgName == "Unsafe Neighborhoods"
        {
            strCrimeId="c"
        }
        else if strImgName == "Robbery"
        {
            strCrimeId="2"
        }
        else if strImgName == "Assault"
        {
            strCrimeId="3"
        }
        else if strImgName == "Arson"
        {
            strCrimeId="4"
        }
        else if strImgName == "Rape"
        {
            strCrimeId="5"
        }
        else if strImgName == "Violet Crime Murder"
        {
            strCrimeId="6"
        }
        else if strImgName == "Other"
        {
            strCrimeId="7"
        }
       
        print(strCrimeId)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckForNotification), name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    //MARK:- ViewWill Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CheckForNotification"), object: nil)
    }
    
    @objc func CheckForNotification()
    {
        Constant.APPDELEGATE.ReceiveNotification=true
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (Comment_Arr?.count)!>Int(0)
        {
            return (Comment_Arr?.count)! + 2
            
        }
        else
        {
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
        
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)
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
            table.separatorInset = UIEdgeInsets.zero
        }
        if(self.responds(to: #selector(setter: UIView.layoutMargins))){
            table.layoutMargins = UIEdgeInsets.zero;
        }
        
    }
    
    //    -(void)viewDidLayoutSubviews
    //    {
    //    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //    }
    //
    //    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //    }
    //    }
    //    -(CGFloat)tableView:(UITableView )tableView estimatedHeightForRowAtIndexPath:(NSIndexPath )indexPath
    //    {
    //    return UITableViewAutomaticDimension;
    //    }
    //
    //    -(CGFloat)tableView:(UITableView )tableView heightForRowAtIndexPath:(NSIndexPath )indexPath
    //    {
    //    return UITableViewAutomaticDimension;
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
     
        if indexPath.row==0
        {
            let cell1:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell0")! as UITableViewCell
            
            let lblHeader:UILabel = cell1.viewWithTag(10) as! UILabel
            let lblComment:UILabel = cell1.viewWithTag(11) as! UILabel
            let lblComments:UILabel = cell1.viewWithTag(12) as! UILabel
            let lblRecords:UILabel = cell1.viewWithTag(13) as! UILabel
            let lblYears:UILabel = cell1.viewWithTag(14) as! UILabel
            
            lblHeader.text=strImgName
            
            lblComment.text=JSON(dictForDetail as Any).dictionaryValue["main_comment"]!.stringValue
            
            lblComments.text=NSString(format: "%d",Comment_Arr!.count) as String
            
            lblRecords.text=JSON(dictForDetail as Any).dictionaryValue["crime_data"]!.stringValue
                //dictForDetail?.value(forKey: "crime_data") as? String
            
            var strYear:String=(JSON(dictForDetail as Any).dictionaryValue["year"]!.stringValue)
            
                //(dictForDetail?.value(forKey: "year")as! String)
            //strYear = strYear .stringByReplacingOccurrencesOfString(" ", withString:"")
            
            strYear = strYear .replacingOccurrences(of: " ", with: "")
            lblYears.text=strYear
            
            return cell1
        }
            
        else if (Comment_Arr?.count)!>Int(0)
        {
     
            if (indexPath.row == (Comment_Arr?.count)! + 1 )
            {
                
                let cell:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell2")! as UITableViewCell
                
                // let btnAddComment:UIButton = cell.viewWithTag(30) as! UIButton
                //  btnAddComment.addTarget(self, action: #selector(btn_AddComment_clicked), forControlEvents: UIControlEvents.TouchUpInside)
                
                //  let ViewForAddComment:UIView=(cell.viewWithTag(31))!
                
                
                let txtAddedComment:UITextField=cell.viewWithTag(32) as! UITextField
                txtAddedComment.delegate=self
                txtAddedComment.placeholder="Add Comment"
                
                let btnDone:UIButton=cell.viewWithTag(33) as! UIButton
                btnDone.addTarget(self, action: #selector(btn_DoneComment_clicked), for: UIControlEvents.touchUpInside)
                
                btnDone.layer.cornerRadius = 5;
                
                
                return cell
                
            }
            else
            {
                let cell2:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell1")! as UITableViewCell
                let lblComment:UILabel = cell2.viewWithTag(21) as! UILabel
                
                let imgUser:UIImageView = cell2.viewWithTag(20) as! UIImageView
                
                
                lblComment.text=JSON(Comment_Arr as Any).array![indexPath.row - 1]["comment"].stringValue
                    
                    //(Comment_Arr?.object(at: indexPath.row - 1) as AnyObject).value(forKey: "comment") as? String
                
                // comment
                imgUser.image=UIImage(named: "comment")
                return cell2

            }
        }
        else
        {
            let cell:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell2")! as UITableViewCell
            
            //   let ViewForAddComment:UIView=cell.viewWithTag(31)!
            
            //   ViewForAddComment.hidden=true
            
            let txtAddedComment:UITextField=cell.viewWithTag(32) as! UITextField
            txtAddedComment.placeholder="Add Comment"
            txtAddedComment.delegate=self
            
            let btnDone:UIButton=cell.viewWithTag(33) as! UIButton
            btnDone.addTarget(self, action: #selector(btn_DoneComment_clicked), for: UIControlEvents.touchUpInside)
            btnDone.layer.cornerRadius = 5;
            
            
            
            
            return cell
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to:table)
        var contentOffset:CGPoint = table.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        table.contentOffset = contentOffset
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
       // strComment=textField.text
        
        if (textField.superview!.superview?.superview is UITableViewCell)
        {
            let cell: UITableViewCell = (textField.superview!.superview?.superview as! UITableViewCell)
            
            let indexPath: NSIndexPath = table.indexPath(for: cell)! as NSIndexPath as NSIndexPath
            
            table.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
        }
    }
   
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        let s = textField.text.bridgeToObjectiveC().stringByReplacingCharactersInRange(range, withString:string)
//        
//        strComment = (textField.text! as NSString).stringByRe‌​placingCharactersInRa‌​nge(range, withString: string)
//        
//       // strComment=textField.text
//        return true
//    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func btn_DoneComment_clicked(sender: AnyObject)
    {
        if (AFNetworkReachabilityManager.shared().networkReachabilityStatus.rawValue == 0)
        {
            Constant.InternetNewAlert(ViewController: self)
            return
            
        }
        
       
        
        let User_id=(Constant.USERDEFAULT.value(forKey: "UserID"))!
        
      //  let cell:UITableViewCell = self.table.dequeueReusableCellWithIdentifier("cell2")! as UITableViewCell
        
        let txtAddedComment:UITextField=table.viewWithTag(32) as! UITextField
        
  
        if txtAddedComment.text!.isEmpty==true
        {
            Constant.AlertViewNew(Title: "Runsafe", Message: "Please Enter Comment", ViewController: self)
            return
        }
        
        Constant.APPDELEGATE.showLoadingHUD(navigation: self, withText: "Please wait...")
        
//        var post:String=String(stringInterpolation:"user_id=\(String(describing: User_id))&latitude=\(String(describing: strLat))&longitude=\(String(describing: strLong))&crime_id=\(String(describing: strCrimeId))&comment=\(String(describing: txtAddedComment.text))")
        
        print(User_id)
         print(strLat)
         print(strLong)
         print(strCrimeId)
         print(txtAddedComment.text!)
        
        let params:[String : String] = ["user_id":User_id as! String ,"latitude":strLat,"longitude":strLong,"crime_id":strCrimeId,"comment":txtAddedComment.text!]
        
        
        Alamofire.request(NSURL(string: "http://i-phoneappdevelopers.com/runner_mate/webservice/add_comments.php?")! as URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                print("Response: \((response.result.value)! as AnyObject!)")
                
                Constant.APPDELEGATE.hideLoadingHUD()
                
                var dict = JSON(response.result.value ?? "")
                
                
                let str = dict["status"].dictionaryValue["sucess"]?.stringValue
                if (str? .isEqual("1"))!
                {
                    

                    let msg = dict["status"].dictionaryValue["message"]?.stringValue
                   
                    let AlertView = UIAlertController(title:"Runsafe", message:msg, preferredStyle: .alert)
                    
                    let Ok:UIAlertAction=UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                        AlertView.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    AlertView.addAction(Ok)
                    
                    self.present(AlertView, animated: true, completion: nil)
                    
                }
                else
                {
                    let msg = dict["status"].dictionaryValue["data"]?.stringValue
                    
                    Constant.AlertViewNew(Title: "Runsafe", Message:msg! as NSString, ViewController: self)
                }
                
                break
                
            case .failure(_):
               Constant.ConnectionFailAlert(ViewController: self)
                break
                
            }
        }
        
        
        
        
        


    }
    
    
 
    func DeactivateAddCommentMode()
    {
        // self.ViewForAddComment?.hidden=true
    }
    
    
    @IBAction func btn_back_clicked(sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
