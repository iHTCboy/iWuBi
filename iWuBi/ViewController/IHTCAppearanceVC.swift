//
//  IHTCAppearanceVC.swift
//  iWuBi
//
//  Created by HTC on 2020/3/29.
//  Copyright © 2020 HTC. All rights reserved.
//


import UIKit

class IHTCAppearanceVC: UITableViewController {

    let language = ["跟随系统", "浅色主题", "深色主题"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = "设置主题"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return language.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "IHTCAppearanceTableViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "IHTCAppearanceTableViewCell")
        }
        
        cell?.accessoryType = .none
        switch IHTCUserDefaults.shared.getAppAppearance() {
        case .Default:
            if indexPath.row == 0 {
                cell?.accessoryType = .checkmark
            }
            break
        case .Light:
            if indexPath.row == 1 {
                cell?.accessoryType = .checkmark
            }
            break
        case .Dark:
            if indexPath.row == 2 {
                cell?.accessoryType = .checkmark
            }
            break
        }
        
        cell?.textLabel?.text = language[indexPath.row]
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            IHTCUserDefaults.shared.setDefaultAppAppearance(style: .Default)
            break
        case 1:
            IHTCUserDefaults.shared.setDefaultAppAppearance(style: .Light)
            break
        case 2:
            IHTCUserDefaults.shared.setDefaultAppAppearance(style: .Dark)
            break
        default:break
            
        }
        tableView.reloadData()
            
    }
}

