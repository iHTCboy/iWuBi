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
        let play = UIBarButtonItem(title: "中", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItems = [add, play]
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
        
        if item.title == "中" {
            isShowZH = true
            item.title = "En"
        }
        else {
            isShowZH = false
            item.title = "中"
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
        cell.numLbl.layer.cornerRadius = 3
        cell.numLbl.layer.masksToBounds = true
        cell.numLbl.adjustsFontSizeToFitWidth = true
        cell.numLbl.baselineAdjustment = .alignCenters
        cell.tagLbl.layer.cornerRadius = 3
        cell.tagLbl.layer.masksToBounds = true
        cell.tagLbl.adjustsFontSizeToFitWidth = true
        cell.tagLbl.baselineAdjustment = .alignCenters
        cell.langugeLbl.layer.cornerRadius = 3
        cell.langugeLbl.layer.masksToBounds = true
        cell.langugeLbl.adjustsFontSizeToFitWidth = true
        cell.langugeLbl.baselineAdjustment = .alignCenters
        cell.frequencyLbl.layer.cornerRadius = 3
        cell.frequencyLbl.layer.masksToBounds = true
        cell.frequencyLbl.adjustsFontSizeToFitWidth = true
        cell.frequencyLbl.baselineAdjustment = .alignCenters
        
        let question = questionModle!
        cell.numLbl.text =  " #" + question.leetId + " "
        cell.tagLbl.text =  " " + question.difficulty + " "
        cell.tagLbl.backgroundColor = ILeetCoderModel.shared.colorForKey(level: question.difficulty)
        cell.frequencyLbl.text = " " + (question.frequency.count < 3 ? (question.frequency + ".0%") : question.frequency) + " "
        cell.langugeLbl.backgroundColor = kColorAppGray
        
        if ILeetCoderModel.shared.defaultArray.contains(self.title!) {
            if question.tagString.count > 0 {
                //cell.langugeLbl.text =  " " + question.tagString.componentsJoined(by: " · ") + "   "
                cell.langugeLbl.isHidden = false
            }
            else {
                cell.langugeLbl.isHidden = true
            }
            
        }
        
        if ILeetCoderModel.shared.tagsArray.contains(self.title!) {
            //cell.langugeLbl.text =  " " + self.title! + "   "
            cell.langugeLbl.isHidden = false
        }
        
        if isShowZH {
            cell.tagLbl.text =  " " + (question.difficulty == "Easy" ? "容易" : (question.difficulty == "Medium" ? "中等" : "困难" )) + " "
            cell.langugeLbl.text = cell.langugeLbl.isHidden ? "" : (" " + question.tagStringZh.componentsJoined(by: " · ") + " ")
            cell.questionLbl.text = question.titleZh.count > 0 ? question.titleZh : question.title
        }else{
            cell.tagLbl.text = " " + question.difficulty + " "
            cell.langugeLbl.text = cell.langugeLbl.isHidden ? "" : (" " + question.tagString.componentsJoined(by: " · ") + " ")
            cell.questionLbl.text = question.title
        }
        
        
//        if questionModle!.hasOptionQuestion {
//            cell.questionLbl.text = questionModle!.question + "\n  A: " + questionModle!.optionA + "\n  B: " + questionModle!.optionB + "\n  C: " + questionModle!.optionC + "\n  D: " + questionModle!.optionD
//        }else{
//
//            cell.questionLbl.text = questionModle!.question
//        }
//
//        if self.title == questionModle?.lauguage {
//            // 判断当前是语言tabbar 也可以用 self.tabBarController?.selectedIndex 判断，但兼容性不好
//            cell.tagLbl.backgroundColor = kColorAppBlue
//            cell.langugeLbl.isHidden = true
//        }else{
//
//            cell.tagLbl.backgroundColor = kColorAppOrange
//            cell.langugeLbl.isHidden = false
//            cell.langugeLbl.text =   " " + questionModle!.lauguage + "   "
//        }
        self.selectedCell = cell;
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell: ITQuestionDetailViewCell = tableView.dequeueReusableCell(withIdentifier: "ITQuestionDetailViewCell") as! ITQuestionDetailViewCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.answerLbl.textAlignment = .left
        if isShowZH {
            let str = questionModle!.questionDescriptionZh.count > 0 ? questionModle!.questionDescriptionZh : questionModle!.questionDescription;
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

