//
//  ITListTitleViewCell.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITListTitleViewCell: UITableViewCell {

    @IBOutlet weak var num1Lbl: UILabel!
    
    @IBOutlet weak var num2Lbl: UILabel!
    
    @IBOutlet weak var num3Lbl: UILabel!
    
    @IBOutlet weak var num4Lbl: UILabel!
    
    @IBOutlet weak var versionLbl: UILabel!
    
    
    @IBOutlet weak var wordLbl: ITCopyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
