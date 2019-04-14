//
//  IHTCLearnViewController.swift
//  iWuBi
//
//  Created by HTC on 2019/4/14.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit


class IHTCLearnViewController: UIViewController {
    
    // MARK:- Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-49), style: .grouped)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        tableView.estimatedRowHeight = 55
        return tableView
    }()
    
    lazy var dataArray: Array<Dictionary<String, Array<Any>>> = {
        if let path = Bundle.main.path(forResource: "iWuBi_learning", ofType: "plist") {
            var data = NSArray.init(contentsOfFile: path)
            if let array = data as? Array<Dictionary<String, Array<Any>>> {
                return array
            }
            return Array()
        }
        return Array()
    }()
    
}


extension IHTCLearnViewController
{
    func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// MARK: Tableview Delegate
extension IHTCLearnViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = self.dataArray[section]
        let array = dict[Array(dict.keys).first!]
        return array!.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict = self.dataArray[section]
        return Array(dict.keys).first!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "IHTCLeaningVCViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "IHTCLeaningVCViewCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.selectedBackgroundView = UIView.init(frame: cell!.frame)
            cell!.selectedBackgroundView?.backgroundColor = kColorAppOrange.withAlphaComponent(0.7)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 20:16.5)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 16:12.5)
            cell?.detailTextLabel?.sizeToFit()
        }
        
        let dict = self.dataArray[indexPath.section]
        let array = dict[Array(dict.keys).first!]
        let data = array![indexPath.row] as! Dictionary<String, String>
    
        cell!.textLabel?.text = data["title"]
        cell?.detailTextLabel?.text = (data["content"]?.prefix(8))! + "..."
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict = self.dataArray[indexPath.section]
        let array = dict[Array(dict.keys).first!]
        let data = array![indexPath.row] as! Dictionary<String, String>
        let type = data["type"]
        if type == "image" {
            
            
        } else {
            let vc = IHTCLearnDetailViewController()
            vc.title = data["title"]
            vc.dataDict = data
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
