//
//  IHTCWuBiWordViewCell.swift
//  iWuBi
//
//  Created by HTC on 2019/4/11.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCWuBiWordViewCell: UITableViewCell {

    
    @IBOutlet weak var num1Lbl: UILabel!
    
    @IBOutlet weak var num2Lbl: UILabel!

    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var img4: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
