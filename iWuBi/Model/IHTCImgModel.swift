//
//  IHTCImgModel.swift
//  iWuBi
//
//  Created by HTC on 2019/4/11.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCImgModel: NSObject {
    static let shared = IHTCImgModel()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
        super.init()
    }

   public lazy var image86Dict : Dictionary<String, UIImage> = {
        var dict = Dictionary<String, UIImage>()
        let image = UIImage.init(named: "iWuBi-86-keyboard")
        let image86Keys = [
            "Q": [0, 81], "W": [121, 81], "E": [242, 81], "R": [363, 81], "T": [484, 81], "Y": [607, 81], "U": [728, 81], "I": [849, 81], "O": [970, 81], "P": [1091, 81],
            "A": [34, 215], "S": [155, 215], "D": [276, 215], "F": [397, 215], "G": [518, 215], "H": [641, 215], "J": [762, 215], "K": [883, 215], "L": [1005, 215],
            "Z": [93, 348], "X": [214, 348], "C": [335, 348], "V": [457, 348], "B": [577, 348], "N": [699, 348], "M": [821, 348]
        ]
        for (key, value) in image86Keys {
            let rect = CGRect(x: value[0], y: value[1], width: 109, height: 117)
            let cgImageCorpped = image?.cgImage?.cropping(to: rect)
            let imageCorpped = UIImage(cgImage: cgImageCorpped!)
            dict[key] = imageCorpped
        }
        return dict
    }()
    
    public lazy var image98Dict : Dictionary<String, UIImage> = {
        var dict = Dictionary<String, UIImage>()
        let image = UIImage.init(named: "iWuBi-98-keyboard")
        let image98Keys = [
            "Q": [0, 83], "W": [124, 83], "E": [249, 83], "R": [374, 83], "T": [499, 83], "Y": [626, 83], "U": [750, 83], "I": [875, 83], "O": [1000, 83], "P": [1125, 83],
            "A": [35, 222], "S": [160, 222], "D": [285, 222], "F": [410, 222], "G": [535, 222], "H": [661, 222], "J": [786, 222], "K": [911, 222], "L": [1036, 222],
            "Z": [96, 360], "X": [221, 360], "C": [346, 360], "V": [471, 360], "B": [595, 360], "N": [720, 360], "M": [847, 360]
        ]
        for (key, value) in image98Keys {
            let rect = CGRect(x: value[0], y: value[1], width: 113, height: 121)
            let cgImageCorpped = image?.cgImage?.cropping(to: rect)
            let imageCorpped = UIImage(cgImage: cgImageCorpped!)
            dict[key] = imageCorpped
        }
        return dict
    }()
    
    
}
