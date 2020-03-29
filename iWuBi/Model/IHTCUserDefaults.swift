//
//  IHTCUserDefaults.swift
//  iLeetcode
//
//  Created by HTC on 2019/4/22.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCUserDefaults: NSObject {
    
    static let shared = IHTCUserDefaults()
    let df = UserDefaults.standard
}

extension IHTCUserDefaults
{
    func setUDValue(value: Any?, forKey key: String){
        df.set(value, forKey: key)
        df.synchronize()
    }
    
    func getUDValue(key: String) -> Any? {
        return df.value(forKey: key)
    }
}

// MARK: 语言设置
extension IHTCUserDefaults
{
    func getUDLanguage() -> String {
        if let language = getUDValue(key: "IHTCLanguageKey") as? String {
            return language
        }
        return  "en_US"
    }
    
    func setUDlanguage(value: String) {
        setUDValue(value: value, forKey: "IHTCLanguageKey")
    }
}

// MARK: 主题外观设置
enum AppAppearanceStyle : String
{
    case Default     = "FollowSystem"
    case Light       = "LightStyle"
    case Dark        = "DarkStyle"
}

extension IHTCUserDefaults
{
    func getAppAppearance() -> AppAppearanceStyle {
        if let language = getUDValue(key: "IHTCAppAppearanceKey") as? AppAppearanceStyle.RawValue {
            return AppAppearanceStyle(rawValue: language) ?? AppAppearanceStyle.Default
        }
        return  AppAppearanceStyle.Default
    }
    
    func setAppAppearance(style: AppAppearanceStyle) {
        setUDValue(value: style.rawValue, forKey: "IHTCAppAppearanceKey")
    }
    
    func setDefaultAppAppearance(style: AppAppearanceStyle) {
        if #available(iOS 13.0, *) {
            switch style {
            case .Default:
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .unspecified
                IHTCUserDefaults.shared.setAppAppearance(style: .Default)
                break
            case .Light:
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
                IHTCUserDefaults.shared.setAppAppearance(style: .Light)
                break
            case .Dark:
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
                IHTCUserDefaults.shared.setAppAppearance(style: .Dark)
                break
            }
        }
    }
}
