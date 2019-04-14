//
//  IHTCLearnDetailViewController.swift
//  iWuBi
//
//  Created by HTC on 2019/4/14.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit
import WebKit

class IHTCLearnDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    
    var dataDict: Dictionary<String, String> = [:]

    lazy var textView: UITextView = {
        var textView = UITextView.init(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16.5)
        textView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 20, right: 0)
        textView.bounces = true
        textView.bouncesZoom = true
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.isSelectable = true
        return textView
    }()
    
    lazy var webView: WKWebView = {
        var webView = WKWebView.init(frame: CGRect.zero, configuration: WKWebViewConfiguration.init())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 20, right: 0)
        return webView
    }()
}


extension IHTCLearnDetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedPageView))
        navigationItem.rightBarButtonItems = [shareItem]
        
        switch dataDict["type"] {
            case "text":
                setTextContent()
                break
            case "html":
                setHTMLContent()
                break
            default: break
        }
    }
    
    
    func setTextContent() {
        view.addSubview(textView)
        let constraintViews = [
            "textView": textView
        ]
        let vFormat = "V:|-0-[textView]-0-|"
        let hFormat = "H:|-0-[textView]-0-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: DeviceType.IS_IPAD ? UIFont.systemFont(ofSize: 20) :  UIFont.systemFont(ofSize: 18)
        ]
        textView.attributedText = NSAttributedString.init(string: dataDict["content"] ?? "", attributes: attributes)
    }
    
    func setHTMLContent() {
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let constraintViews = [
            "webView": webView
        ]
        let vFormat = "V:|-0-[webView]-0-|"
        let hFormat = "H:|-0-[webView]-0-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()
        
        let url = Bundle.main.url(forResource: dataDict["content"] ?? "", withExtension: nil)!
        webView.loadFileURL(url, allowingReadAccessTo: url)        
    }
    
    @objc func sharedPageView(item: Any) {
        let headerImage = self.navigationController?.navigationBar.screenshot ?? UIImage()
        var masterImage = UIImage()
        switch dataDict["type"] {
            case "text":
                masterImage = textView.screenshotImage ?? UIImage.init(named: "App-share-Icon")!
                break
            case "html":
                masterImage = webView.screenshot ?? UIImage.init(named: "App-share-Icon")!
                break
            default: break
        }
        
        let footerImage = IHTCShareFooterView.footerView(image: UIImage.init(named: "iWuBi-qrcode")!, title: kShareTitle, subTitle: kShareSubTitle).screenshot
        let image = ImageHandle.slaveImageWithMaster(masterImage: masterImage, headerImage: headerImage, footerImage: footerImage!)
        IAppleServiceUtil.shareImage(image: image!, vc: UIApplication.shared.keyWindow!.rootViewController!)
    }
    
}

extension IHTCLearnDetailViewController: WKNavigationDelegate, WKUIDelegate {
    
}
