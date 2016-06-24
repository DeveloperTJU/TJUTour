//
//  TableViewCell.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    var cellImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width * 9 / 16)
        cellImage = UIImageView(frame: imageFrame)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
