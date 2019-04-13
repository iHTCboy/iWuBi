//
//  iHTCSearchViewController.swift
//  iWuBi
//
//  Created by HTC on 2019/4/12.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCSearchViewController: UIViewController {

    
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

    private var isSingleWord : Bool = true
    var is86Word: Bool = true
    private var searchArray: Array<ITQuestionModel> = []
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
        var model: Dictionary<String, ITQuestionModel>
        if is86Word {
            model = (IHTCModel.shared.defaultData().first?.value.dictionKeys)!
        } else {
            model = (IHTCModel.shared.defaultData().first?.value.dictionKeys)!
        }
        for word in words {
            self.searchArray.append(model[String.init(word)] ?? ITQuestionModel(word: String.init(word)))
        }
        
        self.tableView.reloadData()
    }
    
    func searchPhraseWords(words: String) {
        
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



// MARK: Tableview Delegate
extension IHTCSearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
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
        
        let question = self.searchArray[indexPath.row]
        cell.wordLbl.text = question.word
        
        let lblArray = [cell.num1Lbl, cell.num2Lbl, cell.num3Lbl, cell.num4Lbl]
        
        for (index, lbl) in lblArray.enumerated() {
            if index < question.codeArray.count {
                lbl?.isHidden = false
                lbl?.text = question.codeArray[index].uppercased() + "   "
                
            } else {
                lbl?.isHidden = true
            }
        }
        
        let imgArray = [cell.img1, cell.img2, cell.img3, cell.img4]
        let code = question.codeArray.first
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
