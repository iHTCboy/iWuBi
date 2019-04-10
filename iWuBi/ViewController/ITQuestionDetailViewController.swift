//
//  ITQuestionDetailViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit
import SafariServices


class ITQuestionDetailViewController: ITBasePopTransitionVC {
 
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
    
    var selectedCell: ITQuestionListViewCell!
    
    var questionModle : ITQuestionModel?
    var isShowZH : Bool = false
    
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionHeaderHeight = 80
        tableView.register(UINib.init(nibName: "ITQuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionListViewCell")
        tableView.register(UINib.init(nibName: "ITQuestionDetailViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionDetailViewCell")
        // 调试
        //        tableView.fd_debugLogEnabled = true
        return tableView
    }()
}


extension ITQuestionDetailViewController {
    fileprivate func setUpUI() {
        view.addSubview(tableView)
        tableView.delegate = self;
        tableView.dataSource = self;
        
        let add = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addTapped))
        let play = UIBarButtonItem(title: "繁體", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItems = [play]
    }
    
    @objc func addTapped(item: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "提示",
                                      message: "请选择要显示的解答的答案的语言\nSelect the language of the answer for the solution",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let zhAction = UIAlertAction.init(title: "中文", style: .default) { (action: UIAlertAction) in
            let url = "https://leetcode-cn.com/articles/" + self.questionModle!.link
            self.showWebView(url: url)
        }
        alert.addAction(zhAction)
        
        let enAction = UIAlertAction.init(title: "English", style: .default) { (action: UIAlertAction) in
            let url = "https://leetcode.com/articles/" + self.questionModle!.link
            self.showWebView(url: url)
        }
        alert.addAction(enAction)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {
            //print("UIAlertController present");
        })
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


extension ITQuestionDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UINib(nibName: "ITQuestionListViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ITQuestionListViewCell
        cell.backgroundColor = UIColor.white
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.num1Lbl.layer.cornerRadius = 3
        cell.num1Lbl.layer.masksToBounds = true
        cell.num1Lbl.adjustsFontSizeToFitWidth = true
        cell.num1Lbl.baselineAdjustment = .alignCenters
        cell.num2Lbl.layer.cornerRadius = 3
        cell.num2Lbl.layer.masksToBounds = true
        cell.num2Lbl.adjustsFontSizeToFitWidth = true
        cell.num2Lbl.baselineAdjustment = .alignCenters
        cell.num3Lbl.layer.cornerRadius = 3
        cell.num3Lbl.layer.masksToBounds = true
        cell.num3Lbl.adjustsFontSizeToFitWidth = true
        cell.num3Lbl.baselineAdjustment = .alignCenters
        cell.num4Lbl.layer.cornerRadius = 3
        cell.num4Lbl.layer.masksToBounds = true
        cell.num4Lbl.adjustsFontSizeToFitWidth = true
        cell.num4Lbl.baselineAdjustment = .alignCenters
        
        let question = questionModle!
        
        if isShowZH {
            cell.wordLbl.text = ZMChineseConvert.convert(toSimplified: question.word)
        }else{
            cell.wordLbl.text = ZMChineseConvert.convert(toTraditional: question.word)
        }
        
        self.selectedCell = cell;
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell: ITQuestionDetailViewCell = tableView.dequeueReusableCell(withIdentifier: "ITQuestionDetailViewCell") as! ITQuestionDetailViewCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.answerLbl.textAlignment = .left
        if isShowZH {
            //let str = questionModle!.questionDescriptionZh.count > 0 ? questionModle!.questionDescriptionZh : questionModle!.questionDescription;
            //cell.answerLbl.attributedText =  SwiftyMarkdown(string: str).attributedString()
        }
        else {
            //cell.answerLbl.attributedText =  SwiftyMarkdown(string: questionModle!.questionDescription).attributedString()
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

