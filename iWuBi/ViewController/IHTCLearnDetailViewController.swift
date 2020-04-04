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

        setupUI(isChange: false)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // trait发生了改变
        if #available(iOS 13.0, *) {
            if (self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                // 执行操作
                setupUI(isChange: true)
            }
        }
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
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        var webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 20, right: 0)
        webView.isOpaque = false;
        if #available(iOS 13.0, *) {
            webView.backgroundColor = .tertiarySystemGroupedBackground
        } else {
            webView.backgroundColor = .groupTableViewBackground
        }
        return webView
    }()
}


extension IHTCLearnDetailViewController {
    func setupUI(isChange: Bool) {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedPageView))
        navigationItem.rightBarButtonItems = [shareItem]
        
        switch dataDict["type"] {
            case "text":
                setTextContent(isChange: isChange)
                break
            case "html":
                setHTMLContent(isChange: isChange)
                break
            default: break
        }
    }
    
    
    func setTextContent(isChange: Bool) {
        if isChange {
            return
        }
        
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
                          NSAttributedString.Key.font: DeviceType.IS_IPAD ? UIFont.systemFont(ofSize: 18) :  UIFont.systemFont(ofSize: 16)
        ]
        textView.attributedText = NSAttributedString.init(string: dataDict["content"] ?? "", attributes: attributes)
        if #available(iOS 13.0, *) {
            textView.backgroundColor = .secondarySystemGroupedBackground
            textView.textColor = .secondaryLabel
        }
        textView.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
    }
    
    func setHTMLContent(isChange: Bool) {
        if isChange {
            webView(webView, didFinish: nil)
            return
        }
        
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
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if #available(iOS 13.0, *) {
            var js = ""
            switch IHTCUserDefaults.shared.getAppAppearance() {
            case .Default:
                if (UITraitCollection.current.userInterfaceStyle == .dark) {
                    js = "document.body.style.background='#2b2c2e'; document.body.style.color='white';"
                } else {
                    js = "document.body.style.background='white'; document.body.style.color='black';"
                }
                break
            case .Light:
                js = "document.body.style.background='white'; document.body.style.color='black';"
                break
            case .Dark:
                js = "document.body.style.background='#2b2c2e'; document.body.style.color='white';"
                break
            }
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}
