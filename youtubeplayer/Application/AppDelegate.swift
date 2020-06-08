//
//  AppDelegate.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 03/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Initialize Google sign-in.
      //  GIDSignIn.sharedInstance().clientID = "854956822608-u17cdf4joa3phi5fh1rbnh3g1u6v8vmj.apps.googleusercontent.com"
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       
    
    }

  /*  func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }*/

   @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    

}
