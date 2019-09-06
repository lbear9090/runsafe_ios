//
//  NewAnnotation.swift
//  Ceres8
//
//  Created by Lucky on 6/20/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit
import Mapbox
class NewAnnotation: NSObject, MGLAnnotation
{
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    var image: UIImage?
    var reuseIdentifier: String?
    
    init(title: String, subtitle: String,coordinate: CLLocationCoordinate2D,image: UIImage, reuseIdentifier:String)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
        self.reuseIdentifier = reuseIdentifier
        super.init()
    }
}
