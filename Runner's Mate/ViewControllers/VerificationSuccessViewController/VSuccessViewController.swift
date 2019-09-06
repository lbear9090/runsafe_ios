//
//  VSuccessViewController.swift
//  Ceres8
//
//  Created by Lucky on 6/3/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit

class VSuccessViewController: UIViewController
{
    @IBOutlet var FistView_line_Seprator: UILabel!
    
    @IBOutlet var Seprator_Right: NSLayoutConstraint!
    
    @IBOutlet var Seprator_Left: NSLayoutConstraint!
    
    @IBOutlet var Bottom_View: UIView!
    
    @IBOutlet var Bottom_View_lbl: UILabel!
    
    //MARK:- BottomView_CloseButton Click
    @IBAction func BottomView_Close_Click(sender: UIButton)
    {
        Bottom_View.isHidden=true
    }
    @IBAction func Done_Click(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Bottom_View.isHidden=true

    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden=true

        Bottom_View.isHidden=true
    
        self.navigationController?.navigationItem.hidesBackButton=true
        self.navigationItem.hidesBackButton=true

        if (Constant.isiPhone_6)
        {
            FistView_line_Seprator .layoutIfNeeded();
            Seprator_Left.constant=15
            Seprator_Right.constant=15
            
        }
        else if (Constant.isiPhone_6_Plus)
        {
            FistView_line_Seprator .layoutIfNeeded();
            Seprator_Left.constant=17
            Seprator_Right.constant=17
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
     
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
   
}
