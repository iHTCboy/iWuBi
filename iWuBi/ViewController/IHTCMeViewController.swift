//
//  ITProgrammerVC.swift
//  iTalker
//
//  Created by HTC on 2017/4/22.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class IHTCMeViewController: UIViewController {

    // MARK:- Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isNewVersion = false
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        tableView.sectionFooterHeight = 0.1;
        tableView.estimatedRowHeight = 55
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    fileprivate var titles = ["0": "切换App图标:选择你的最爱,设置主题外观:暗黑or浅色", "1": "应用内评分:欢迎给\(kiTalker)打评分！,AppStore评价:欢迎给\(kiTalker)写评论!,分享给朋友:与身边的好友一起学习！",
        "2":"意见反馈:欢迎到AppStore提需求或bug问题,邮件联系:如有问题欢迎来信,隐私条款:用户使用服务协议,开源地址:现已开源代码，欢迎关注,更多关注:欢迎访问作者博客,更多学习:更多开发者内容推荐,关于应用:\(kiTalker)"] as [String : String]

}


extension IHTCMeViewController
{
    func setupUI() {
        view.addSubview(tableView)
        let constraintViews = [
            "tableView": tableView
        ]
        let vFormat = "V:|-0-[tableView]-0-|"
        let hFormat = "H:|-0-[tableView]-0-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: Tableview Delegate
extension IHTCMeViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let string = self.titles["\(section)"]
        let titleArray = string?.components(separatedBy: ",")
        return (titleArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ITProgrammerVCViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "ITProgrammerVCViewCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.selectedBackgroundView = UIView.init(frame: cell!.frame)
            cell!.selectedBackgroundView?.backgroundColor = kColorAppOrange.withAlphaComponent(0.7)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 20:16.5)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 16:12.5)
            cell?.detailTextLabel?.sizeToFit()
        }
        
        let string = self.titles["\(indexPath.section)"]
        let titleArray = string?.components(separatedBy: ",")
        let titles = titleArray?[indexPath.row]
        let titleA = titles?.components(separatedBy: ":")
        cell!.textLabel?.text = titleA?[0]
        cell?.detailTextLabel?.text = titleA?[1]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section;
        let row = indexPath.row;
        
        switch section {
        case 0:
            if row == 0 {
                let refreshAlert = UIAlertController(title: "切换App图标", message: "选择你喜欢的图标~", preferredStyle: UIAlertController.Style.alert)
                
                // icon1
                let image1 = UIImage.init(named: "AppIcon-default")!
                let defaltIcon = UIAlertAction(title: "默认图标-经典", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: nil)
                    return
                })
                defaltIcon.setValue(image1.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(defaltIcon)
                // icon2
                let name2 = "iWiBi-orange-icon-light"
                let image2 = UIImage.init(named: name2)!
                let newIcon1 = UIAlertAction(title: "橙色图标-轻亮", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name2)
                    return
                })
                newIcon1.setValue(image2.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon1)
                // icon3
                let name3 = "iWiBi-orange-icon"
                let image3 = UIImage.init(named: name3)!
                let newIcon3 = UIAlertAction(title: "橙色图标-墨深", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name3)
                    return
                })
                newIcon3.setValue(image3.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon3)
                // icon4
                let name4 = "iWiBi-orange-two"
                let image4 = UIImage.init(named: name4)!
                let newIcon4 = UIAlertAction(title: "橙色图标-全彩", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name4)
                    return
                })
                newIcon4.setValue(image4.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon4)
                // icon5
                let name5 = "iWiBi-orange-blank"
                let image5 = UIImage.init(named: name5)!
                let newIcon5 = UIAlertAction(title: "橙色图标-留白", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name5)
                    return
                })
                newIcon5.setValue(image5.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon5)
                // icon6
                let name6 = "iWiBi-dark-one"
                let image6 = UIImage.init(named: name6)!
                let newIcon6 = UIAlertAction(title: "橙色图标-暗黑", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name6)
                    return
                })
                newIcon6.setValue(image6.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon6)
                
                // icon7
                let name7 = "iWiBi-dark-two"
                let image7 = UIImage.init(named: name7)!
                let newIcon7 = UIAlertAction(title: "橙色图标-至黑", style: .default, handler: { (action: UIAlertAction!) in
                    IAppleServiceUtil.changeAppIconWithName(iconName: name7)
                    return
                })
                newIcon7.setValue(image7.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon7)
                
                // icon8
                let name8 = "iWiBi-gray-icon"
                let image8 = UIImage.init(named: name8)!
                let newIcon8 = UIAlertAction(title: "橙色图标-怀念", style: .default, handler: { (action: UIAlertAction!) in
                   IAppleServiceUtil.changeAppIconWithName(iconName: name8)
                   return
                })
                newIcon8.setValue(image8.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                refreshAlert.addAction(newIcon8)
                
                let cancel = UIAlertAction(title:  "取消", style: .cancel, handler: nil)
                refreshAlert.addAction(cancel)
                self.present(refreshAlert, animated: true, completion: nil)
            }
            if row == 1 {
                let vc = IHTCAppearanceVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 1:
            if row == 0 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    IAppleServiceUtil.openAppstore(url: kAppDownloadURl, isAssessment: true)
                }
            }
            if row == 1 {
                IAppleServiceUtil.openAppstore(url: kAppDownloadURl, isAssessment: false)
            }
            if row == 2 {

                let image = UIImage(named: "App-share-Icon")
                let url = NSURL(string: kAppDownloadURl)
                let string = kAppShare
                let activityController = UIActivityViewController(activityItems: [image! ,url!,string], applicationActivities: nil)
                //if iPhone
                if (UIDevice.current.userInterfaceIdiom == .phone) {
                    self.present(activityController, animated: true, completion: nil)
                } else {
                    //if iPad
                    // Change Rect to position Popover
                    let popup = UIPopoverController.init(contentViewController: activityController);
                    popup.present(from: CGRect.init(x: self.view.frame.width-44, y: 64, width: 0, height: 0), in: self.view, permittedArrowDirections: .any, animated: true)
                }
            }
            
            break
        case 2:
            if row == 0 {
                IAppleServiceUtil.openAppstore(url: kAppDownloadURl, isAssessment: true)
            }
            if row == 1 {
                let message = "欢迎来信，写下你的问题吧" + "\n\n\n\n" + kMarginLine + "\n 当前\(kiTalker)版本：" + KAppVersion + "， 系统版本：" + String(Version.SYS_VERSION_FLOAT) + "， 设备信息：" + UIDevice.init().modelName
                
                ITCommonAPI.shared.sendEmail(recipients: [kEmail], messae: message, vc: self)
            }
            if row == 2 {
                IAppleServiceUtil.openWebView(url: kLicenseURL, tintColor: kColorAppOrange, vc: self)
            }
            if row == 3 {
                IAppleServiceUtil.openWebView(url: kGithubURL, tintColor: kColorAppOrange, vc: self)
            }
            if row == 4 {
                IAppleServiceUtil.openWebView(url: kiHTCboyURL, tintColor: kColorAppOrange, vc: self)
            }
            if row == 5 {
                let vc = ITAdvancelDetailViewController()
                vc.title = "更多学习"
                vc.advancelType = .iHTCboyApp
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if row == 6 {
                let vc = IHTCAboutAppViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        default: break
            
        }
        
    }
}

