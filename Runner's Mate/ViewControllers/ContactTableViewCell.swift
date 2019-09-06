//
//  ContactTableViewCell.swift
//  Ceres8
//
//  Created by Lucky on 8/25/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet var lblPreFix: UILabel!
    
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
