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
    public var defaultArray = ["86版",
                                "86一级简码",
                                "86二级简码",
                                "86三级编码",
                                "86四级编码"]
    public var tagsArray =  ["98版",
                             "98一级简码",
                             "98二级简码",
                             "98三级编码",
                             "98四级编码"]
    
    fileprivate var defaultDict  = Dictionary<String, Array<Any>>()
    fileprivate var tagsDict = Dictionary<String, Array<Any>>()
    
    var search86Dict  = Dictionary<String, Dictionary<String, Any>>()
    var search98Dict  = Dictionary<String, Dictionary<String, Any>>()
}


extension IHTCModel
{
    func defaultData() -> Dictionary<String, Array<Any>> {
        return self.defaultDict
    }
    
    func tagsData() -> Dictionary<String, Array<Any>> {
        return self.tagsDict
    }
    
    func shuffledData(title: String) {
        if defaultArray.contains(title) {
            defaultDict[title] = defaultDict[title]!.shuffled()
        } else if tagsArray.contains(title) {
            tagsDict[title] = tagsDict[title]!.shuffled()
        }  else {
            print("no shuffled title")
        }
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
                        dfDict[df] = NSMutableArray();
                    }
                    
                    let objs86 = objects["86"]
                    for key86 in objs86!.keys {
                        // default
                        let allDict = dfDict["86版"]
                        let word86 = objs86![key86]
                        let dict = ["word": key86 , "codes": word86 as Any]
                        allDict?.add(dict)
                        self.search86Dict[key86] = dict
                        
                        for word in word86! {
                            let wordLength = word.count
                            let wordKey = self.defaultArray[wordLength]
                            let wordDict = dfDict[wordKey]
                            wordDict?.add(dict)
                        }
                    }
                    
                    
                    var tagDict = Dictionary<String, NSMutableArray>()
                    for tag in self.tagsArray {
                        tagDict[tag] = NSMutableArray();
                    }
                    
                    let objs98 = objects["98"]
                    for key98 in objs98!.keys {
                        // default
                        let allDict = tagDict["98版"]
                        let word98 = objs98![key98]
                        let dict = ["word": key98 , "codes": word98 as Any]
                        allDict?.add(dict)
                        self.search98Dict[key98] = dict
                        
                        for word in word98! {
                            let wordLength = word.count
                            let wordKey = self.tagsArray[wordLength]
                            let wordDict = tagDict[wordKey]
                            wordDict?.add(dict)
                        }
                    }
                    
                    if let df = dfDict as?  Dictionary<String, Array<Any>> {
                        self.defaultDict = df
                    }
                    
                    if let tag = tagDict as?  Dictionary<String, Array<Any>> {
                        self.tagsDict = tag
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
