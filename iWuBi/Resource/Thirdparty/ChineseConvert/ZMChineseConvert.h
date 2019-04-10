//
//  ZMChineseConvert.h
//  ZMChineseConvert
//
//  Created by ZengZhiming on 2017/3/30.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMChineseConvert : NSObject



/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertToTraditional:(NSString *)simpString;


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString*)convertToSimplified:(NSString*)tradString;

@end
