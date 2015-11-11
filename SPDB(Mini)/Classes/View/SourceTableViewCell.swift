//
//  SourceTableViewCell.swift
//  SPDB(Mini)
//
//  Created by GBTouchG3 on 15/10/26.
//  Copyright (c) 2015年 GBTouchG3. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSourceName: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblProgressValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
