//
//  ImageLoadable.swift
//  aasoa
//
//  Created by KHUSHBOO on 12/03/19.
//  Copyright © 2019 KHUSHBOO. All rights reserved.
//

import Foundation
//import SDWebImage
import Kingfisher
import UIKit

// MARK: -  Protocol dalegate for manage custome actions
protocol ImageLoadable {
    // MARK:  Protocol dalegate for manage custome actions methods
    ///
    func loadImage(for URL: URL)
    ///
    func cancelLoading()
}

// MARK: - UIImageView extension for image-load
extension UIImageView: ImageLoadable {
    // MARK: UIImageView extension for image-load methods
    ///
    func cancelLoading() {
        
    }
    ///
    func loadImage(for URL: URL) {
        self.kf.setImage(with: URL, placeholder: UIImage(named: "noimage"))
//        self.sd_setShowActivityIndicatorView(true)
//        self.sd_setIndicatorStyle(.gray)
//        self.sd_setImage(with: URL , placeholderImage: R.image.noimage())
    }
    
    /* func cancelLoading() {
     Nuke.cancelRequest(for: self)
     }*/
}
