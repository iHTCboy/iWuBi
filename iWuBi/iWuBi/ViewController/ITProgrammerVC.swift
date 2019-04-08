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

class ITProgrammerVC: UIViewController {

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
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-49), style: .grouped)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: -49, right: 0)
        tableView.sectionFooterHeight = 0.1;
        tableView.estimatedRowHeight = 55
        return tableView
    }()
    
    fileprivate var titles = ["0": "应用内评分:欢迎给\(kiTalker)打评分！,AppStore评价:欢迎给\(kiTalker)写评论!,分享给朋友:与身边的好友一起学习！",
        "1":"意见反馈:欢迎到AppStore提需求或bug问题,邮件联系:如有问题欢迎来信,开源地址:未来逐步开放代码，欢迎关注,更多关注:了解更多，欢迎访问作者博客,关于应用:\(kiTalker)"] as [String : String]

}


extension ITProgrammerVC
{
    func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func gotoAppstore(isAssessment: Bool) {
        if UIApplication.shared.canOpenURL(URL.init(string: kAppDownloadURl + (isAssessment ? kReviewAction: ""))!) {
            UIApplication.shared.openURL(URL.init(string: kAppDownloadURl + (isAssessment ? kReviewAction: ""))!)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: Tableview Delegate
extension ITProgrammerVC : UITableViewDelegate, UITableViewDataSource
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
//        case 0:
//            if row == 0 {
////                let vc = NTWaterfallViewController.init(collectionViewLayout:CHTCollectionViewWaterfallLayout())
////                let nav = NTNavigationController.init(rootViewController: vc)
////                vc.title = "实拍面试题目"
////                self.present(nav, animated: true, completion: nil);
//            }
//            break
        case 0:
            if row == 0 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    gotoAppstore(isAssessment: true)
                }
            }
            if row == 1 {
                gotoAppstore(isAssessment: true)
            }
            if row == 2 {

                let image = UIImage(named: "App-share-Icon")
                let url = NSURL(string: kAppDownloadURl)
                let string = "Hello, \(kiTalker)! 这是一款为IT工程师们提供算法知识充电的应用，IT算法和数据结构知识，求职面试必备的好工具哦！" + "iOS下载链接：" + kAppDownloadURl
                let activityController = UIActivityViewController(activityItems: [image! ,url!,string], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
            break
        case 1:
            if row == 0 {
                gotoAppstore(isAssessment: true)
            }
            if row == 1 {
                let message = "欢迎来信，写下你的问题吧" + "\n\n\n\n" + kMarginLine + "\n 当前\(kiTalker)版本：" + KAppVersion + "， 系统版本：" + String(Version.SYS_VERSION_FLOAT) + "， 设备信息：" + UIDevice.init().modelName
                
                ITCommonAPI.sharedInstance.sendEmail(recipients: [kEmail], messae: message, vc: self)
            }
            if row == 2 {
                if #available(iOS 9.0, *) {
                    let vc = SFSafariViewController(url: URL(string: kGithubURL
                        )!, entersReaderIfAvailable: true)
                    if #available(iOS 10.0, *) {
                        vc.preferredBarTintColor = kColorAppOrange
                        vc.preferredControlTintColor = UIColor.white
                    }
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    }
                    present(vc, animated: true)
                } else {
                    if UIApplication.shared.canOpenURL(URL.init(string: kGithubURL )!) {
                        UIApplication.shared.openURL(URL.init(string: kGithubURL)!)
                    }
                }
            }
            if row == 3 {
                if #available(iOS 9.0, *) {
                    let vc = SFSafariViewController(url: URL(string: kiHTCboyURL
                        )!, entersReaderIfAvailable: true)
                    if #available(iOS 10.0, *) {
                        vc.preferredBarTintColor = kColorAppOrange
                        vc.preferredControlTintColor = UIColor.white
                    }
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    }
                    present(vc, animated: true)
                } else {
                    if UIApplication.shared.canOpenURL(URL.init(string: kiHTCboyURL )!) {
                        UIApplication.shared.openURL(URL.init(string: kiHTCboyURL)!)
                    }
                }
            }
            if row == 4 {
                let vc = ITAboutAppVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        default: break
            
        }
        
        

    }
}

