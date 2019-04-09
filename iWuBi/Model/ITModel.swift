//
//  ITModel.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITModel: NSObject {
    var success = 0
    var total = 0
    
    lazy var result: Array<ITQuestionModel> = {
        return Array()
    }()
    
    override init() {
        super.init()
    }
    
    init(array: Array<Dictionary<String, Any>> , language: String) {
        super.init()
        
        guard !array.isEmpty else {
            print("dictionary can't nil !")
            return
        }
        
        success = 1
        total = array.count
        for dic in array {
            let questionModel = ITQuestionModel.init(dictionary: dic);
            questionModel.language = language
            result.append(questionModel)
        }
    }
}
