//
//  FacebookFriendCell.swift
//  Ceres8
//
//  Created by Lucky on 7/27/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit

class FacebookFriendCell: UITableViewCell {

    @IBOutlet var FriendImageView: RemoteImageView!
    
    @IBOutlet var NameLbl: UILabel!
    
    @IBOutlet var Colorlable: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
}
