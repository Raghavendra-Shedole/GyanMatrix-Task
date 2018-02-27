//
//  CustomImageView.swift
//  GyanMatrix
//
//  Created by Raghavendra Shedole on 27/02/18.
//  Copyright © 2018 Raghavendra Shedole. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

@IBDesignable
class CustomImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(url:String) {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        indicator.frame = self.bounds
        indicator.color = UIColor.black
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(indicator)
        indicator.startAnimating()
        let trimmedString = url.trimmingCharacters(in: .whitespaces)
        self.kf.setImage(with: URL(string: trimmedString),
                         placeholder: self.image,
                         options: [.transition(ImageTransition.fade(1))],
                         progressBlock: { receivedSize, totalSize in
        },
                         completionHandler: { image, error, cacheType, imageURL in
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()
        })
    }
    
    @IBInspectable public var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
