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
    let favoritesKey = "iCloud.com.iHTCboy.iWuBi.favorites"
    let keyValueStore = NSUbiquitousKeyValueStore.default
}

extension IHTCUserDefaults
{
    func setUDValue(value: Any?, forKey key: String) {
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


// MARK: 收藏夹设置
extension IHTCUserDefaults
{
    func isFavoritesItem(item: String) -> Bool {
        let items = getFavoritesItems()
        return items.contains(item)
    }
    
    func setFavoritesItem(item: String) {
        var items = getFavoritesItems()
        guard !items.contains(item) else {
            return
        }
        items.append(item)
        setUDFavorites(value: items)
    }
    
    func deleteFavoritesItem(item: String) {
        var items = getFavoritesItems()
        items = items.filter({ $0 != item })
        setUDFavorites(value: items)
    }
    
    func getFavoritesItems() -> Array<String> {
        if let favories = keyValueStore.array(forKey: favoritesKey) as? Array<String> {
            return favories
        }
        
        if let favorites = getUDValue(key: "IHTCFavoritesItemsKey") as? Array<String> {
            return favorites
        }
        
        return []
    }
    
    private func setUDFavorites(value: Array<String>) {
        keyValueStore.set(value, forKey: favoritesKey)
        keyValueStore.synchronize()
        setUDValue(value: value, forKey: "IHTCFavoritesItemsKey")
    }
}


// MARK: 五笔版本设置
extension IHTCUserDefaults
{
    func getUDWubiVersionIs86() -> Bool {
        if let v_86 = getUDValue(key: "IHTCWubiVersionKey") as? Bool {
            return v_86
        }
        return true
    }
    
    func setUDWubiVeersionIs86(value: Bool) {
        setUDValue(value: value, forKey: "IHTCWubiVersionKey")
    }
}
