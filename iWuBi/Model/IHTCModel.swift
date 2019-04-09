//
//  IHTCModel.swift
//  iLeetcode
//
//  Created by HTC on 2019/3/31.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCModel: NSObject {
    static let shared = IHTCModel()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
        super.init()
        initModel()
    }
    public var defaultArray = ["86",
                                "一级简码",
                                "二级简码",
                                "三级编码",
                                "四级编码"]
    public var tagsArray =  ["98",
                             "一级简码",
                             "二级简码",
                             "三级编码",
                             "四级编码"]
    
    fileprivate var defaultDict  = Dictionary<String, ITModel>()
    fileprivate var tagsDict = Dictionary<String, ITModel>()
}


extension IHTCModel
{
    func defaultData() -> Dictionary<String, ITModel> {
        return self.defaultDict
    }
    
    func tagsData() -> Dictionary<String, ITModel> {
        return self.tagsDict
    }
    
    
    func colorForKey(level: String) -> UIColor {
        switch level {
        case "All":
            return KColorAppRed
        case "Easy":
            return kColorAppGreen
        case "Medium":
            return kColorAppOrange
        case "Hard":
            return KColorAppRed
        default:
            return kColorAppBlue
        }
    }
    
    private func initModel() {
        let fileName = "iWuBi_code"
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let objects = json as? Dictionary<String, Dictionary<String, [String]>> {
                    // json is a dictionary
                    var dfDict = Dictionary<String, NSMutableArray>()
                    for df in self.defaultArray {
                        dfDict[df] = NSMutableArray.init();
                    }
                    
                    let objs86 = objects["86"]
                    for key86 in objs86!.keys {
                        // default
                        let allDict = dfDict["86"]
                        let word86 = objs86![key86]
                        allDict?.add([key86 : word86])
                        
                        for word in word86! {
                            let wordLength = word.count
                            let wordKey = self.defaultArray[wordLength]
                            let wordDict = dfDict[wordKey]
                            wordDict?.add([key86 : word86])
                        }
                    }
                    
                    
                    var tagDict = Dictionary<String, NSMutableArray>()
                    for tag in self.tagsArray {
                        tagDict[tag] = NSMutableArray.init();
                    }
                    
                    let objs98 = objects["98"]
                    for key98 in objs98!.keys {
                        // default
                        let allDict = tagDict["98"]
                        let word98 = objs98![key98]
                        allDict?.add([key98 : word98])
                        
                        for word in word98! {
                            let wordLength = word.count
                            let wordKey = self.tagsArray[wordLength]
                            let wordDict = tagDict[wordKey]
                            wordDict?.add([key98 : word98])
                        }
                    }
                    
                    // 转成模型
                    for dfKey in dfDict.keys {
                        let model = ITModel.init(array: dfDict[dfKey] as! Array<Dictionary<String, Any>>, word: dfKey)
                        self.defaultDict[dfKey] = model
                    }

                    for tagKey in tagDict.keys {
                        let model = ITModel.init(array: tagDict[tagKey] as! Array<Dictionary<String, Any>>, word: tagKey)
                        self.tagsDict[tagKey] = model
                    }
                    
                } else {
                    print("JSON is invalid")
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("no find json file")
        }
    }
}
