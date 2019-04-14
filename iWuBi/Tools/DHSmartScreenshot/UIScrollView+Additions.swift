import Foundation
import UIKit

extension UIScrollView {
    
    var screenshotOfVisibleContent : UIImage? {
        var croppingRect = self.bounds
        croppingRect.origin = self.contentOffset
        return self.screenshotForCroppingRect(croppingRect: croppingRect)
    }
    
    var screenshotImage : UIImage? {
        let image: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, 0.0);
        
        //先保存原始的格式
        let savedContentOffset = self.contentOffset;
        let savedFrame = self.frame;
        //移设置为零
        self.contentOffset = CGPoint.zero;
        //设置大小
        self.frame = CGRect.init(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
            
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        image = UIGraphicsGetImageFromCurrentImageContext();
        
    
        self.contentOffset = savedContentOffset;
        self.frame = savedFrame;
        
        UIGraphicsEndImageContext();
        
        if (image != nil) {
            return image;
        }
        return nil;
    }
}
