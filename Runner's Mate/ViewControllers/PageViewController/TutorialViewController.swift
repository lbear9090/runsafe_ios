//
//  TutorialViewController.swift
//  Runners Mate
//
//  Created by Lucky on 12/09/16.
//  Copyright © 2016 Lucky. All rights reserved.
//


import UIKit

class TutorialViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet var SkipButton: UIButton!
    @IBOutlet var NextButton: UIButton!
    @IBOutlet var GoButton: UIButton!

    @IBOutlet var scrollView: UIScrollView!
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var ImageArray:NSMutableArray!
    
    var pageNumber:CGFloat!
    
    @IBOutlet var pageControl : UIPageControl!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDomain: String = Bundle.main.bundleIdentifier!
        
        Constant.USERDEFAULT .removePersistentDomain(forName: appDomain)
        
        GoButton.isHidden=true

        let Image1:UIImage=UIImage(named: "help screen 0")!
        let Image2:UIImage=UIImage(named: "help screen 1")!
        let Image3:UIImage=UIImage(named: "help screen 2")!
        let Image4:UIImage=UIImage(named: "help screen 3")!
        
        
        ImageArray=NSMutableArray()
        
        ImageArray .add(Image1)
        ImageArray .add(Image2)
        ImageArray .add(Image3)
        ImageArray .add(Image4)
        pageNumber=0
        
        scrollView.layoutIfNeeded()
        
        configurePageControl()
        
        scrollView.delegate = self
        
       // self.view.addSubview(scrollView)
        
        for index in 0..<4
        {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size.width = self.scrollView.frame.size.width
            frame.size.height = self.scrollView.frame.size.height

            self.scrollView.isPagingEnabled = true
            
            let subView = UIImageView(frame: frame)
            
            subView.image = ImageArray[index] as? UIImage
            
            self.scrollView .addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 4, height: 0)
        
        pageControl.addTarget(self, action: #selector(TutorialViewController.changePage(sender:)), for: .valueChanged)
        
    }
    
    func configurePageControl()
    {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
             
        if pageNumber==3
        {
            //Remove Skip And Next Button
//            SkipButton.hidden=true
//            NextButton.hidden=true
            GoButton.isHidden=false
        }
        else
        {
//            SkipButton.hidden=false
//            NextButton.hidden=false
            GoButton.isHidden=true

        }
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Skip Click
    @IBAction func SkipClick(sender: UIButton)
    {
        self.performSegue(withIdentifier: "PushToLogin", sender: self)

    }
    
    //MARK:- Next Click
    
    @IBAction func NextClick(sender: UIButton)
    {
      
       pageNumber = pageNumber + 1
        
        if pageNumber==3
        {
//            SkipButton.hidden=true
//            NextButton.hidden=true
              GoButton.isHidden=false
        }
        else
        {
//            SkipButton.hidden=false
//            NextButton.hidden=false
              GoButton.isHidden=true
            
        }
        
        let pageWidth:CGFloat = scrollView.frame.size.width;
       
      scrollView.setContentOffset(CGPoint(x: pageWidth*pageNumber, y: -20), animated: true)
        //scrollView .setContentOffset(CGPointMake(pageWidth*pageNumber, -20), animated: true)
        
        pageControl.currentPage = Int(pageNumber)
        
    }
    
    @IBAction func GoClick(sender: UIButton)
    {
        self.performSegue(withIdentifier: "PushToLogin", sender: self)
    }

}


