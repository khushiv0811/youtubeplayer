//
//  CommonMethods.swift
// Zivello KIOSK
//
//  Created by Khushboo Vasant on 02/05/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {
    ///
    static var activityIndicator: ViewControllerUtils = ViewControllerUtils()
    
    // MARK: - HUD Methods
    /// Show Progress HUD.
    class func showProgressHud(inView view: UIView) {
        view.endEditing(true)
        activityIndicator.showActivityIndicator(uiView: view)
    }
    
    /// Hide Progress HUD.
    class func hideProgressHud() {
        activityIndicator.hideActivityIndicator()
    }
}
