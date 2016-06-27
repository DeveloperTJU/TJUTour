//
//  TableViewCell.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    var cellImage = UIImageView(frame: CGRectMake(0, 10, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width * 9 / 16 - 10))
    var detailLabel = UILabel(frame: CGRectMake(5, UIScreen.mainScreen().bounds.width * 9 / 16 - 25, 200, 20))
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
