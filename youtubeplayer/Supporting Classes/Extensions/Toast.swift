//
//  Toast.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 07/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import Foundation
import JonAlert

// MARK: - UIViewController extension for show toast
extension UIViewController
{
    // MARK: UIViewController extension for show toast methods
    
    /// Show toast
    /// - Parameter message: message in string
    func showtoast(message : String) {
        JonAlert.show(message: message)
    }
}
