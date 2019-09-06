//
//  CustomAnnotations.swift
//  Ceres8
//
//  Created by Lucky on 6/20/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Mapbox
class CustomAnnotations: UIView,MGLCalloutView
{
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        
    }
    
    func dismissCallout(animated: Bool) {
        
    }
    
    
    
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        <#code#>
//    }
//
//    func dismissCallout(animated: Bool) {
//        <#code#>
//    }
//
    var representedObject: MGLAnnotation
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    
    let mainBody: UIButton
    
    required init(representedObject: MGLAnnotation)
    {
        self.representedObject = representedObject
        
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        mainBody.backgroundColor = backgroundColorForCallout()
        mainBody.tintColor = UIColor.white
        mainBody.contentEdgeInsets = UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
        mainBody.layer.cornerRadius = 4.0
        
        addSubview(mainBody)

    }
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView?
//    {
//        let hitView: UIView = super.hitTest(point, withEvent: event)!
//        
//        if hitView .isProxy()==false
//        {
//            self.superview!.bringSubviewToFront(self)
//        }
//        return hitView
//    }
//    
//   
//    
//    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
//        let rect: CGRect = self.bounds
//        var isInside: Bool = CGRectContainsPoint(rect, point)
//        if !isInside {
//            for view: UIView in self.subviews {
//                isInside = CGRectContainsPoint(view.frame, point)
//                if isInside {
//                    
//                }
//            }
//        }
//        return isInside
//    }
    
    required init?(coder decoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MGLCalloutView API
    
    func presentCalloutFromRect(rect: CGRect, inView view: UIView, constrainedToView constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            return
        }
        
        view.addSubview(self)
        
        // Prepare title label
        mainBody.setTitle(representedObject.title!, for: [.normal])
        mainBody.sizeToFit()
        mainBody.layoutIfNeeded()
        
        
        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            mainBody.addTarget(self, action: #selector(CustomAnnotations.calloutTapped), for: .touchUpInside)
        } else {
            // Disable tapping and highlighting
            mainBody.isUserInteractionEnabled = false
        }
        
        // Prepare our frame, adding extra space at the bottom for the tip
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        
        frame = CGRect(x:frameOriginX,y: frameOriginY,width: frameWidth, height:frameHeight)
        
        if animated
        {
            alpha = 0
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCalloutAnimated(animated: Bool)
    {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                    })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // MARK: - Callout interaction handlers
    
    func isCalloutTappable() -> Bool
    {
        if let delegate = delegate
        {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight(_:))) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    @objc func calloutTapped()
    {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped(_:))) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom view styling
    
    func backgroundColorForCallout() -> UIColor
    {
        return UIColor.darkGray
    }
    
    override func draw(_ rect: CGRect)
    {
        let fillColor = backgroundColorForCallout()
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
//        let tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y + rect.size.height)
         let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        
//        CGPathMoveToPoint(tipPath, nil, tipLeft, heightWithoutTip)
//        CGPathAddLineToPoint(tipPath, nil, tipBottom.x, tipBottom.y)
//        CGPathAddLineToPoint(tipPath, nil, tipLeft + tipWidth, heightWithoutTip)
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
