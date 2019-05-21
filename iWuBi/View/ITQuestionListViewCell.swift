//
//  ITQuestionListViewCell.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITQuestionListViewCell: UITableViewCell {

    @IBOutlet weak var num1Lbl: UILabel!
    
    @IBOutlet weak var num2Lbl: UILabel!
    
    @IBOutlet weak var num3Lbl: UILabel!
    
    @IBOutlet weak var num4Lbl: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var img4: UIImageView!
    
    @IBOutlet weak var wordLbl: ITCopyLabel!
    
    @IBOutlet weak var wordHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
