//
//  IHTCWordDetailViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit
import SafariServices


class IHTCWordDetailViewController: ITBasePopTransitionVC {
 
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedCell: ITListTitleViewCell!
    
    var questionModle : Dictionary<String, Any>?
    var isShowZH : Bool = false
    
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionHeaderHeight = 80
        tableView.register(UINib.init(nibName: "ITListTitleViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITListTitleViewCell")
        tableView.register(UINib.init(nibName: "IHTCWuBiWordViewCell", bundle: Bundle.main), forCellReuseIdentifier: "IHTCWuBiWordViewCell")
        // 调试
        //        tableView.fd_debugLogEnabled = true
        return tableView
    }()
}


extension IHTCWordDetailViewController {
    fileprivate func setUpUI() {
        view.addSubview(tableView)
        tableView.delegate = self;
        tableView.dataSource = self;
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
        
        let add = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addTapped))
//        let play = UIBarButtonItem(title: "繁體", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc func addTapped(item: UIBarButtonItem) {
        
        var url = "https://m.youdao.com/dict?q=" + self.title!
        if UIDevice.current.userInterfaceIdiom == .pad {
            url = "https://dict.youdao.com/w/eng/" + self.title!
        }
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let URLs = URL.init(string: urlEncoding!)!
        let sfvc = SFSafariViewController.init(url: URLs)
        sfvc.hidesBottomBarWhenPushed = true
        sfvc.title = "Search"
        if #available(iOS 10.0, *) {
            sfvc.preferredBarTintColor = kColorAppOrange
            sfvc.preferredControlTintColor = UIColor.white
        }
        if #available(iOS 11.0, *) {
            sfvc.dismissButtonStyle = .close
            sfvc.navigationItem.largeTitleDisplayMode = .never
        }
        self.present(sfvc, animated: true, completion: nil)
    }
    
    @objc func playTapped(item: UIBarButtonItem) {
        
        if item.title == "简体" {
            isShowZH = true
            item.title = "繁體"
        }
        else {
            isShowZH = false
            item.title = "简体"
        }
        
        self.tableView.reloadData()
    }
    
    func showWebView(url: String) {
        let vc = SFSafariViewController(url: URL(string: url
            )!, entersReaderIfAvailable: true)
        if #available(iOS 10.0, *) {
            vc.preferredBarTintColor = kColorAppOrange
            vc.preferredControlTintColor = UIColor.white
        }
        if #available(iOS 11.0, *) {
            vc.dismissButtonStyle = .close
        }
        present(vc, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


extension IHTCWordDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (questionModle?["codes"] as! Array<String>).count as Int 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UINib(nibName: "ITListTitleViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ITListTitleViewCell
        cell.backgroundColor = UIColor.white
        cell.accessoryType = .none
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
        
        let question = questionModle! as! Dictionary<String, Any>
        
        cell.wordLbl.text = question["word"] as? String
        
        var codeArray = question["codes"] as? Array<String> ?? Array<String>()
        
        let lblArray = [cell.num1Lbl, cell.num2Lbl, cell.num3Lbl, cell.num4Lbl]
        
        for (index, lbl) in lblArray.enumerated() {
            if index < codeArray.count {
                lbl?.isHidden = false
                lbl?.text = codeArray[index].uppercased() + "   "
                
            } else {
                lbl?.isHidden = true
            }
        }
        
        self.selectedCell = cell;
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell: IHTCWuBiWordViewCell = tableView.dequeueReusableCell(withIdentifier: "IHTCWuBiWordViewCell") as! IHTCWuBiWordViewCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.num1Lbl.layer.cornerRadius = 3
        cell.num1Lbl.layer.masksToBounds = true
        cell.num1Lbl.adjustsFontSizeToFitWidth = true
        cell.num1Lbl.baselineAdjustment = .alignCenters
        cell.num1Lbl.backgroundColor = kColorAppBlue
        
        let question = questionModle!
        
        cell.num1Lbl.text = question["word"] as? String
        
        var codeArray = question["codes"] as? Array<String> ?? Array<String>()
        
        var code = ""
        if codeArray.count > 0 {
            code = codeArray[indexPath.row].uppercased()
        }
        
        cell.num2Lbl.text = "编码：\(code)"
        
        let imgArray = [cell.img1, cell.img2, cell.img3, cell.img4]
        for (index, imgView) in imgArray.enumerated() {
            if index < code.count {
                imgView?.isHidden = false
                let index = code.index(code.startIndex, offsetBy: index)
                let key = code[index].uppercased()
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
        
    }
}

