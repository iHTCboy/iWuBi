//
//  iHTCSearchViewController.swift
//  iWuBi
//
//  Created by HTC on 2019/4/12.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCSearchViewController: UIViewController {

    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var optionItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    @IBAction func clickedCancelItem(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedOptionItem(_ sender: UIBarButtonItem) {
        if sender.title == "单字" {
            sender.title = "词组"
            isSingleWord = false
            
        } else {
            sender.title = "单字"
            isSingleWord = true
        }
        
        searchWordList(words: searchBar.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    var selectedCell: ITQuestionListViewCell!
    private var isSingleWord : Bool = true
    var is86Word: Bool = true
    private var searchArray: Array<Dictionary<String, Any>> = []
}


extension IHTCSearchViewController {
    func setupUI() {
        self.searchBar.tintColor = kColorAppOrange
        self.searchBar.becomeFirstResponder()
        self.searchBar.delegate = self
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ITQuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionListViewCell")
        tableView.register(UINib.init(nibName: "IHTCWuBiWordViewCell", bundle: Bundle.main), forCellReuseIdentifier: "IHTCWuBiWordViewCell")
        
        if is86Word {
            naviBar.topItem?.title = "86-Search"
        } else {
            naviBar.topItem?.title = "96-Search"
        }
        
    }
    
    func searchWordList(words: String) {
        if words.count == 0 {
            self.searchArray.removeAll()
            self.tableView.reloadData()
            return
        }
        
        if isSingleWord {
            searchSingleWords(words: words)
        } else {
            searchPhraseWords(words: words)
        }
    }
    
    func searchSingleWords(words: String) {
        self.searchArray.removeAll()
        var model: Dictionary<String, Dictionary<String, Any>>
        if is86Word {
            model = IHTCModel.shared.search86Dict
        } else {
            model = IHTCModel.shared.search98Dict
        }
        for word in words {
            var dict = ["word": String.init(word), "codes": Array<String>()] as [String : Any]
            if let dic = model[String.init(word)] {
                dict = dic
            }
            
            self.searchArray.append(dict)
        }
        
        self.tableView.reloadData()
    }
    
    func searchPhraseWords(words: String) {
        self.searchArray.removeAll()
        var model: Dictionary<String, Dictionary<String, Any>>
        if is86Word {
            model = IHTCModel.shared.search86Dict
        } else {
            model = IHTCModel.shared.search98Dict
        }
        
        switch words.count {
        case 1:
            var dict = ["word": String.init(words), "codes": Array<String>()] as [String : Any]
            if let dic = model[String.init(words)] {
                dict = dic
            }
            self.searchArray.append(dict)
            break
        case 2:
            let w1 = String.init(words.first!)
            let w2 = String.init(words.last!)
            var code = ""
            if let dic1 = model[String.init(w1)] {
                let codes1 = dic1["codes"] as! Array<String>
                code += codes1.last!.prefix(2)
            } else {
                code += "ZZ"
            }
            
            if let dic2 = model[String.init(w2)] {
                let codes2 = dic2["codes"] as! Array<String>
                code += codes2.last!.prefix(2)
            } else {
                code += "ZZ"
            }
            
            let dict = ["word": String.init(words), "codes": [code]] as [String : Any]
            self.searchArray.append(dict)
            break
        case 3:
            let w1 = words.subString(from: 0, to: 1)
            let w2 = words.subString(from: 1, to: 2)
            let w3 = words.subString(from: 2, to: 3)
            var code = ""
            if let dic1 = model[String.init(w1)] {
                let codes1 = dic1["codes"] as! Array<String>
                code += codes1.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            if let dic2 = model[String.init(w2)] {
                let codes2 = dic2["codes"] as! Array<String>
                code += codes2.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            if let dic3 = model[String.init(w3)] {
                let codes3 = dic3["codes"] as! Array<String>
                code += codes3.last!.prefix(2)
            } else {
                code += "ZZ"
            }
            
            let dict = ["word": String.init(words), "codes": [code]] as [String : Any]
            self.searchArray.append(dict)
            break
        default:
            let w1 = words.subString(from: 0, to: 1)
            let w2 = words.subString(from: 1, to: 2)
            let w3 = words.subString(from: 2, to: 3)
            let w4 = words.subString(from: words.count-1, to: words.count)
            var code = ""
            if let dic1 = model[String.init(w1)] {
                let codes1 = dic1["codes"] as! Array<String>
                code += codes1.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            if let dic2 = model[String.init(w2)] {
                let codes2 = dic2["codes"] as! Array<String>
                code += codes2.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            if let dic3 = model[String.init(w3)] {
                let codes3 = dic3["codes"] as! Array<String>
                code += codes3.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            if let dic4 = model[String.init(w4)] {
                let codes4 = dic4["codes"] as! Array<String>
                code += codes4.last!.prefix(1)
            } else {
                code += "Z"
            }
            
            let dict = ["word": String.init(words), "codes": [code]] as [String : Any]
            self.searchArray.append(dict)
            break
        }
        
        self.tableView.reloadData()
    }
    
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}

extension IHTCSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWordList(words: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWordList(words: searchBar.text ?? "")
    }
    
}


extension IHTCSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}


// MARK: Tableview Delegate
extension IHTCSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSingleWord {

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
            
            let question = self.searchArray[indexPath.row]
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
            
            let imgArray = [cell.img1, cell.img2, cell.img3, cell.img4]
            let code = codeArray.first
            for (index, imgView) in imgArray.enumerated() {
                if code != nil && index < code!.count {
                    imgView?.isHidden = false
                    let index = code!.index(code!.startIndex, offsetBy: index)
                    let key = code![index].uppercased()
                    if self.is86Word {
                        imgView?.image = IHTCImgModel.shared.image86Dict[key]
                    } else {
                        imgView?.image = IHTCImgModel.shared.image98Dict[key]
                    }
                } else {
                    imgView?.isHidden = true
                }
            }
            
            return cell
        } else {
            let cell: IHTCWuBiWordViewCell = tableView.dequeueReusableCell(withIdentifier: "IHTCWuBiWordViewCell") as! IHTCWuBiWordViewCell
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.num1Lbl.layer.cornerRadius = 3
            cell.num1Lbl.layer.masksToBounds = true
            cell.num1Lbl.adjustsFontSizeToFitWidth = true
            cell.num1Lbl.baselineAdjustment = .alignCenters
            cell.num1Lbl.backgroundColor = kColorAppBlue
            
            let question = self.searchArray[indexPath.row]
            
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
                    if is86Word {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let question = self.searchArray[indexPath.row]
        let questionVC = IHTCSearchDetailVC()
        questionVC.title = question["word"] as? String
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}
