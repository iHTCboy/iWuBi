//
//  ITQuestionListViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITQuestionListViewController: UIViewController {

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
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64-58), style: .plain)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib.init(nibName: "ITQuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionListViewCell")
        self.refreshControl.addTarget(self, action: #selector(randomRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl)
        return tableView
    }()
    
    lazy var listModel: ITModel = {
        if ILeetCoderModel.shared.defaultArray.contains(self.title!) {
            return ILeetCoderModel.shared.defaultData()[self.title!] as! ITModel
            
        } else if ILeetCoderModel.shared.tagsArray.contains(self.title!) {
            return ILeetCoderModel.shared.tagsData()[self.title!] as! ITModel
            
        } else if ILeetCoderModel.shared.enterpriseArray.contains(self.title!) {
            return ILeetCoderModel.shared.enterpriseData()[self.title!] as! ITModel
            
        } else {
            print("no featch title")
            return ITModel()
        }
    }()
    

}


// MARK:- Prive mothod
extension ITQuestionListViewController {
    fileprivate func setUpUI() {
        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let viewDict = [
//            "tableView": tableView
//            ]
//        
//        let vFormat = "V:|[tableView]|"
//        let hFormat = "H:|[tableView]|"
//        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: viewDict)
//        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: nil, views: viewDict)
//        view.addConstraints(vConstraints)
//        view.addConstraints(hConstraints)
    }
    
    @objc public func randomRefresh(sender: AnyObject) {
        self.listModel.result.shuffle()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: Tableview Delegate
extension ITQuestionListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITQuestionListViewCell = tableView.dequeueReusableCell(withIdentifier: "ITQuestionListViewCell") as! ITQuestionListViewCell
        cell.accessoryType = .disclosureIndicator
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
        
        let question = self.listModel.result[indexPath.row]
        cell.numLbl.text =  " #" + question.leetId + " "
        cell.tagLbl.text =  " " + question.difficulty + " "
        cell.tagLbl.backgroundColor = ILeetCoderModel.shared.colorForKey(level: question.difficulty)
        cell.frequencyLbl.text = " " + (question.frequency.count < 3 ? (question.frequency + ".0%") : question.frequency) + " "
        
        if ILeetCoderModel.shared.defaultArray.contains(self.title!) {
            if question.tagString.count > 0 {
                cell.langugeLbl.text =  " " + question.tagString.componentsJoined(by: " · ") + " "
                cell.langugeLbl.backgroundColor = kColorAppGray
                cell.langugeLbl.isHidden = false
            }
            else {
                cell.langugeLbl.text = ""
                cell.langugeLbl.isHidden = true
            }
        }
        
        if ILeetCoderModel.shared.tagsArray.contains(self.title!) {
            cell.langugeLbl.text =  " " + self.title! + "   "
            cell.langugeLbl.backgroundColor = kColorAppGray
            cell.langugeLbl.isHidden = false
        }
        
        
        if false {
            cell.questionLbl.text = question.titleZh
        }else{
            cell.questionLbl.text = question.title
        }
        

//        if question.language == "All" {
//            // 判断当前是语言tabbar 也可以用 self.tabBarController?.selectedIndex 判断，但兼容性不好
//            cell.tagLbl.isHidden = true
//            cell.langugeLbl.isHidden = true
//        }else{
//
//            cell.tagLbl.backgroundColor = ILeetCoderModel.shared.colorForKey(level: question.difficulty)
//            cell.langugeLbl.isHidden = false
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! ITQuestionListViewCell)
    
        let question = self.listModel.result[indexPath.row]
        let questionVC = ITQuestionDetailViewController()
        questionVC.title = self.title
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}


// MARK: 随机数
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


