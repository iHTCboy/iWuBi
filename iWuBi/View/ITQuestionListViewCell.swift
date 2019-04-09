//
//  ITQuestionListViewCell.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITQuestionListViewCell: UITableViewCell {

    @IBOutlet weak var numLbl: UILabel!
    
    @IBOutlet weak var tagLbl: UILabel!
    
    @IBOutlet weak var langugeLbl: UILabel!
    
    @IBOutlet weak var frequencyLbl: UILabel!
    
    @IBOutlet weak var questionLbl: ITCopyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
