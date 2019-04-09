//
//  ILeetCoderModel.swift
//  iLeetcode
//
//  Created by HTC on 2019/3/31.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class ILeetCoderModel: NSObject {
    static let shared = ILeetCoderModel()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
        super.init()
        initModel()
    }
    public var defaultArray = ["All",
                                "Easy",
                                "Medium",
                                "Hard",
                                "Public",
                                "Private"]
    public var tagsArray = Array<String>() //[]
    public var enterpriseArray = Array<String>() //[]
    

    fileprivate var defaultDict  = Dictionary<String, ITModel>()
    fileprivate var tagsDict = Dictionary<String, ITModel>()
    fileprivate var enterpriseDict = Dictionary<String, ITModel>()
}


extension ILeetCoderModel
{
    func defaultData() -> Dictionary<String, ITModel> {
        return self.defaultDict
    }
    
    func tagsData() -> Dictionary<String, ITModel> {
        return self.tagsDict
    }
    
    func enterpriseData() -> Dictionary<String, ITModel> {
        return self.enterpriseDict
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
        let fileName = "iLeetCoder-Question"
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let objects = json as? [Dictionary<String, Any>] {
                    // json is a dictionary
                    var dfDict = Dictionary<String, NSMutableArray>()
                    for df in self.defaultArray {
                        dfDict[df] = NSMutableArray.init();
                    }
                    
                    var tagDict = Dictionary<String, NSMutableArray>()
                    // 分类保存
                    for question in objects {
                        // default
                        let allDict = dfDict["All"]
                        allDict?.add(question)
                        
                        let difficulty = question["difficulty"] as! String
                        let difDict = dfDict[difficulty]
                        difDict?.add(question)
                        
                        let is_locked = question["is_locked"] as! String
                        let is_lockedDict = dfDict[is_locked == "Normal" ? "Public" : "Private"]
                        is_lockedDict?.add(question)
                        
                        // tags
                        if let tags = question["tags"] as? [Dictionary<String, String>] {
                            if tags.count > 0 {
                                for tag in tags {
                                    let tg = tag["tag"]
                                    if let tagArray = tagDict[tg!] {
                                        tagArray.add(question)
                                    }
                                    else {
                                        let newTagArray = NSMutableArray.init();
                                        newTagArray.add(question)
                                        tagDict[tg!] = newTagArray
                                    }
                                }
                            }
                        }
                    }
                    
                    // 转成模型
                    for dfKey in dfDict.keys {
                        let model = ITModel.init(array: dfDict[dfKey] as! Array<Dictionary<String, Any>>, language: dfKey)
                        self.defaultDict[dfKey] = model
                    }
                    
                    let tagArray = tagDict.keys.sorted(){$0 < $1} //排序
                    for tagKey in tagArray {
                        let model = ITModel.init(array: tagDict[tagKey] as! Array<Dictionary<String, Any>>, language: tagKey)
                        self.tagsDict[tagKey] = model
                        self.tagsArray.append(tagKey)
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
