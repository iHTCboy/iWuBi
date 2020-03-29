//
//  IHTCWordListViewController.swift
//  iWuBi
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class IHTCWordListViewController: UIViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let refreshControl = UIRefreshControl.init()
    var selectedCell: ITQuestionListViewCell!
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 58 + 40, right: 0) //tabBarHeight 58
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib.init(nibName: "ITQuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionListViewCell")
        self.refreshControl.addTarget(self, action: #selector(randomRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl)
        return tableView
    }()
    
    func listModel() -> Array<Any> {
        var model = Array<Any>()
        if IHTCModel.shared.defaultArray.contains(self.title!) {
            model = IHTCModel.shared.defaultData()[self.title!] ?? Array()
        } else if IHTCModel.shared.tagsArray.contains(self.title!) {
            model = IHTCModel.shared.tagsData()[self.title!] ?? Array()
        }  else {
            print("no featch title")
        }
        
        return model
    }
    
}


// MARK:- Prive mothod
extension IHTCWordListViewController {
    fileprivate func setUpUI() {
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
        
        // 判断系统版本，必须iOS 9及以上，同时检测是否支持触摸力度识别
        if #available(iOS 9.0, *), traitCollection.forceTouchCapability == .available {
            // 注册预览代理，self监听，tableview执行Peek
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    @objc public func randomRefresh(sender: AnyObject) {
        IHTCModel.shared.shuffledData(title: self.title!)
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

// MARK: Tableview Delegate
extension IHTCWordListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITQuestionListViewCell = tableView.dequeueReusableCell(withIdentifier: "ITQuestionListViewCell") as! ITQuestionListViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.num1Lbl.layer.cornerRadius = 3
        cell.num1Lbl.layer.masksToBounds = true
        cell.num1Lbl.adjustsFontSizeToFitWidth = true
        cell.num1Lbl.baselineAdjustment = .alignCenters
        cell.num1Lbl.backgroundColor = kColorAppBlue
        cell.num2Lbl.layer.cornerRadius = 3
        cell.num2Lbl.layer.masksToBounds = true
        cell.num2Lbl.adjustsFontSizeToFitWidth = true
        cell.num2Lbl.baselineAdjustment = .alignCenters
        cell.num2Lbl.backgroundColor = kColorAppGreen
        cell.num3Lbl.layer.cornerRadius = 3
        cell.num3Lbl.layer.masksToBounds = true
        cell.num3Lbl.adjustsFontSizeToFitWidth = true
        cell.num3Lbl.baselineAdjustment = .alignCenters
        cell.num3Lbl.backgroundColor = KColorAppRed
        cell.num4Lbl.layer.cornerRadius = 3
        cell.num4Lbl.layer.masksToBounds = true
        cell.num4Lbl.adjustsFontSizeToFitWidth = true
        cell.num4Lbl.baselineAdjustment = .alignCenters
        cell.num4Lbl.backgroundColor = kColorAppGray
        
        if DeviceType.IS_IPHONE_5_OR_LESS {
            cell.wordHeightConstraint.constant = UIScreen.getScreenItemWidth(width: 7.0)
        }
        
        let question = self.listModel()[indexPath.row] as! Dictionary<String, Any>
        cell.wordLbl.text = question["word"] as? String
        
        let codeArray = question["codes"] as? Array<String> ?? Array<String>()
        
        let lblArray = [cell.num1Lbl, cell.num2Lbl, cell.num3Lbl, cell.num4Lbl]
        
        for (index, lbl) in lblArray.enumerated() {
            if index < codeArray.count {
                lbl?.isHidden = false
                lbl?.text = codeArray[index].uppercased() + "   "
                
            } else {
                lbl?.isHidden = true
            }
        }
        
        let imgArray = [cell.img1, cell.img2, cell.img3, cell.img4]
        let code = codeArray.first
        for (index, imgView) in imgArray.enumerated() {
            if index < code!.count {
                imgView?.isHidden = false
                let index = code!.index(code!.startIndex, offsetBy: index)
                let key = code![index].uppercased()
                if self.title!.contains("86") {
                    imgView?.image = IHTCImgModel.shared.image86Dict[key]
                } else {
                    imgView?.image = IHTCImgModel.shared.image98Dict[key]
                }
            } else {
                imgView?.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! ITQuestionListViewCell)
    
        let question = self.listModel()[indexPath.row] as! Dictionary<String, Any>
        let questionVC = IHTCWordDetailViewController()
        questionVC.title = question["word"] as? String
        questionVC.is86Word = self.title!.contains("86")
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}

// MARK: - UIViewControllerPreviewingDelegate
@available(iOS 9.0, *)
extension IHTCWordListViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // 模态弹出需要展现的控制器
//        showDetailViewController(viewControllerToCommit, sender: nil)
        // 通过导航栏push需要展现的控制器
         show(viewControllerToCommit, sender: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // 获取indexPath和cell
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        // 设置Peek视图突出显示的frame
        previewingContext.sourceRect = cell.frame
        
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! ITQuestionListViewCell)
        
        let question = self.listModel()[indexPath.row] as! Dictionary<String, Any>
        let questionVC = IHTCWordDetailViewController()
        questionVC.title = question["word"] as? String
        questionVC.is86Word = self.title!.contains("86")
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        
        // 返回需要弹出的控制权
        return questionVC
    }
}
