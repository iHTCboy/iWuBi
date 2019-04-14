//
//  IHTCAppleServiceUtil.swift
//  iWuBi
//
//  Created by HTC on 2019/4/14.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit
import SafariServices

class IAppleServiceUtil: NSObject {
    class func showWebView(url: String, tintColor: UIColor, vc: UIViewController) {
        let sf = SFSafariViewController(url: URL(string: url
            )!, entersReaderIfAvailable: true)
        if #available(iOS 10.0, *) {
            sf.preferredBarTintColor = tintColor
            sf.preferredControlTintColor = UIColor.white
        }
        if #available(iOS 11.0, *) {
            sf.dismissButtonStyle = .close
        }
       vc.present(sf, animated: true)
    }
    
    class func shareWithImage(image: UIImage, text: String, url: String,  vc: UIViewController) {
        let iURL = NSURL(string: url) ?? NSURL.init()
        let activityController = UIActivityViewController(activityItems: [image , iURL, text], applicationActivities: nil)
        vc.present(activityController, animated: true, completion: nil)
    }
    
    class func shareImage(image: UIImage, vc: UIViewController) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        vc.present(activityController, animated: true, completion: nil)
    }
}

class ImageHandle: NSObject {
    //MARK - 压缩一张图片 最大宽高1280 类似于微信算法
    class func weixinShareImage(image: UIImage) -> UIImage? {
        return ImageHandle.getJPEGImagerImg(image: image, MaxCompressibility: 1280.00)
    }
    
    // 压缩一张图片 自定义最大宽高
    class func getJPEGImagerImg(image: UIImage, MaxCompressibility: CGFloat) -> UIImage? {
        var oldImg_WID = image.size.width
        var oldImg_HEI = image.size.height
        if oldImg_WID > MaxCompressibility || oldImg_HEI > MaxCompressibility {
            //超过设置的最大宽度 先判断那个边最长
            if(oldImg_WID > oldImg_HEI){
                //宽度大于高度
                oldImg_HEI = (MaxCompressibility * oldImg_HEI)/oldImg_WID;
                oldImg_WID = MaxCompressibility;
            }else{
                oldImg_WID = (MaxCompressibility * oldImg_WID)/oldImg_HEI;
                oldImg_HEI = MaxCompressibility;
            }
        }
        
        let newImage = ImageHandle.imageWithImage(image: image, newSize: CGSize.init(width: oldImg_WID, height: oldImg_HEI))
        var dJpeg: Data
        if let jpeg = newImage.jpegData(compressionQuality: 0.5) {
            dJpeg = jpeg
        }else{
            dJpeg = newImage.pngData() ?? Data()
        }
        
        return UIImage.init(data: dJpeg)
    }
    
    // 压缩一张图片 自定义最大宽高
    class func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage ?? UIImage()
    }
    
    
    class func slaveImageWithMaster(masterImage: UIImage, headerImage: UIImage,  footerImage: UIImage) -> UIImage? {
        var size = masterImage.size
        size.height += headerImage.size.height
        size.height += footerImage.size.height
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        //Draw header
        headerImage.draw(in: CGRect.init(x: 0, y: 0, width: headerImage.size.width, height: headerImage.size.height))
        
        //Draw master
        masterImage.draw(in: CGRect.init(x: 0, y: headerImage.size.height, width: masterImage.size.width, height: masterImage.size.height))
        
        //Draw masterfootImage
        footerImage.draw(in: CGRect.init(x: 0, y: headerImage.size.height + masterImage.size.height, width: footerImage.size.width, height: footerImage.size.height))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultImage
    }
}
