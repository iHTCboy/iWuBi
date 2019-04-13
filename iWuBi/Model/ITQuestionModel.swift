//
//  ITQuestionModel.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITQuestionModel: NSObject {
    var language = "" //当前分类
    var word = "" //当前词
    var codeStrings = ""
    var codeArray = Array<String>()
    var leetId = ""
    var title = ""
    var titleZh = ""
    var is_locked = ""
    var difficulty = ""
    var frequency = ""
    var link = ""
    var questionDescription = ""
    var questionDescriptionZh = ""
    var tags = Array<Any>()
    var tagString = NSMutableArray()
    var tagStringZh = NSMutableArray()
    
    
    init(word: String) {
        self.word = word
    }
    
    init(dictionary: Dictionary<String, Any>, language: String) {
        
        self.language = language
        let wordKey = dictionary.keys.first as! String
        self.word = wordKey
        let wordValue = dictionary[wordKey]
        self.codeArray = wordValue as! Array
        let codes = self.codeArray.joined(separator: "，")
        self.codeStrings = codes.uppercased()
    }
}

/*
 {
 "leetId": "1",
 "link": "two-sum",
 "title": "Two Sum",
 "is_locked": "Normal",
 "difficulty": "Easy",
 "frequency": "45.5%",
 "titleZh": "\u4e24\u6570\u4e4b\u548c",
 "questionDescription": "Given an array of integers, return **indices** of the two numbers such that they add up to a specific target.\n\nYou may assume that each input would have **_exactly_** one solution, and you may not use the _same_ element twice.\n\n**Example:**\n\nGiven nums = [2, 7, 11, 15], target = 9,\n\nBecause nums[**0**] + nums[**1**] = 2 + 7 = 9,\nreturn [**0**, **1**].",
 "questionDescriptionZh": "\u7ed9\u5b9a\u4e00\u4e2a\u6574\u6570\u6570\u7ec4\u548c\u4e00\u4e2a\u76ee\u6807\u503c\uff0c\u627e\u51fa\u6570\u7ec4\u4e2d\u548c\u4e3a\u76ee\u6807\u503c\u7684 **\u4e24\u4e2a** \u6570\u3002\n\n\u4f60\u53ef\u4ee5\u5047\u8bbe\u6bcf\u4e2a\u8f93\u5165\u53ea\u5bf9\u5e94\u4e00\u79cd\u7b54\u6848\uff0c\u4e14\u540c\u6837\u7684\u5143\u7d20\u4e0d\u80fd\u88ab\u91cd\u590d\u5229\u7528\u3002\n\n**\u793a\u4f8b:**\n\n\u7ed9\u5b9a nums = [2, 7, 11, 15], target = 9\n\n\u56e0\u4e3a nums[**0**] + nums[**1**] = 2 + 7 = 9\n\u6240\u4ee5\u8fd4\u56de [**0, 1**]",
 "tags": [
 {
 "tag": "Array",
 "tagZh": "\u6570\u7ec4",
 "link": "array"
 },
 {
 "tag": "Hash Table",
 "tagZh": "\u54c8\u5e0c\u8868",
 "link": "hash-table"
 }
 ]
 },
 */
 
