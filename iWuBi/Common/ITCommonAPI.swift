//
//  ITCommonAPI.swift
//  iTalker
//
//  Created by HTC on 2017/4/23.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit
import MessageUI


class ITCommonAPI: NSObject {
    
    static let sharedInstance = ITCommonAPI()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
}

public typealias checkAppUpdateHandler = ((_ isNewVersion: Bool, _ neWversion: String, _ error: Error?) -> ())

// update
extension ITCommonAPI
{
    func checkAppUpdate( newHandler: checkAppUpdateHandler?) {
        
        var request = URLRequest(url: URL(string: "https://itunes.apple.com/lookup?id=" + kAppAppleId)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, err in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let responseObject = json as? [String: Any] {
                        // json is a dictionary
                        //print(responseObject)
                        let resultCount = responseObject["resultCount"] as! Int
                        if resultCount == 0 {
                            return
                        }
                        
                        let serverVersionArr = responseObject["results"] as! NSArray
                        let serverVersionDic = serverVersionArr[0] as! NSDictionary
                        let serverVersion = serverVersionDic["version"] as! NSString
                        let localVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString
                        
                        //以"."分隔数字然后分配到不同数组
                        let serverArray = serverVersion.components(separatedBy: ".")
                        let localArray = localVersion.components(separatedBy: ".")
                        let counts = min(serverArray.count, localArray.count)
                        for i in (0..<counts) {
                            //判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如 本地为1.5 服务器1.5.1）
                            if localArray.count < serverArray.count {
                                self.showNewVersion(version: serverVersion , resultDic: serverVersionDic)
                                newHandler?(true, serverVersion as String, nil)
                                break
                            }
                            
                            //有新版本，服务器版本对应数字大于本地
                            if  Int(serverArray[i])! >  Int(localArray[i])! {
                                self.showNewVersion(version: serverVersion , resultDic: serverVersionDic)
                                newHandler?(true, serverVersion as String, nil)
                                break
                            }else if Int(serverArray[i])! < Int(localArray[i])! {
                                break;
                            }
                            
                        }
                        
                        newHandler?(false, serverVersion as String, nil)
                        
                    } else if let object = json as? [Any] {
                        // json is an array
                        print(object)
                        
                    } else {
                        print("JSON is invalid")
                    }
                } catch {
                    newHandler?(true, "" as String, error)
                    print(error.localizedDescription)
                }
            }
            
            }.resume()
    }
    
    func showNewVersion(version: NSString, resultDic: NSDictionary) {
        print(version)
        
        let title = "发现新版本v" + (version as String)
        
        let alert = UIAlertController(title: title,
                                      message: "赶快体验最新版本吧！是否前往AppStore更新？",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action: UIAlertAction) in
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/cn/app/yi-mei-yun/id" + kAppAppleId + "?l=zh&ls=1&mt=8")!)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let vc = UIApplication.shared.keyWindow?.rootViewController;
            vc?.present(alert, animated: true, completion: {
                //print("UIAlertController present");
            })
        }
    }
}

extension ITCommonAPI : MFMailComposeViewControllerDelegate
{
    func sendEmail(recipients: Array<String>, messae: String, vc: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipients)
            mail.setMessageBody(messae, isHTML: false)
            vc.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
