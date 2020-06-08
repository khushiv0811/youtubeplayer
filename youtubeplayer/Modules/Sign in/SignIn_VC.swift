//
//  SignIn_VC.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//


import Firebase
import GoogleSignIn
import UIKit

class SignIn_VC: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
  

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        googlesignin()
    }
    //MARK:- Google Sign in
    func googlesignin()
    {
    // Set up google sign
           GIDSignIn.sharedInstance()?.presentingViewController = self
           let scope: NSString = "https://www.googleapis.com/auth/youtube.readonly"
           let currentScopes: NSArray = GIDSignIn.sharedInstance().scopes! as NSArray
           GIDSignIn.sharedInstance().scopes = currentScopes.adding(scope)
           GIDSignIn.sharedInstance().signIn()
           GIDSignIn.sharedInstance().delegate = self
    }

   //MARK:- Get Channel id
    func getchannelid(accesstoken : String)
    {
        let url_str : String = String(format : "%@channels?part=id&mine=true&access_token=%@" , NetworkAPIManager.sharedInstance.baseurl,accesstoken)
           
             NetworkAPIManager.sharedInstance.getAPI(url: url_str, param: nil, completion:
            {(_ result: Any, _ success: Bool) -> Void in
             if success
             {
                let dict_json : NSDictionary = result as! NSDictionary
               if dict_json["items"] != nil
               {
                let arr_items  : NSArray = dict_json["items"] as! NSArray
                let dict : NSDictionary = arr_items[0] as! NSDictionary
                let channelid : String =  dict["id"] as! String
                UserDefaults.standard.set(channelid, forKey: "Channelid")
             self.performSegue(withIdentifier: "playlist_segue", sender: self)
            }
                else
               {
                self.showtoast(message: "Could not Fetch your Youtube channel. Please Create a channel and then try again")
                }
                }
            })
    }
    
    
}

extension SignIn_VC : GIDSignInDelegate
{
    //MARK:- Google Sign in Delegates
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                 withError error: Error!)
       {
         if let error = error
         {
           if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue
           {
             print("The user has not signed in before or they have since signed out.")
           } else
           {
             print("\(error.localizedDescription)")
           }
           return
         }
         // Perform any operations on signed in user here.
           _ = user.userID                  // For client-side use only!
        // let idToken = user.authentication.idToken // Safe to send to the server
       //  let fullName = user.profile.name
        // let givenName = user.profile.givenName
       //  let familyName = user.profile.familyName
      //   let email = user.profile.email
         // ...
          
        if user.authentication.accessToken.isEmpty == false
        {
        self.getchannelid(accesstoken: user.authentication.accessToken)
        }
        else
        {
            showtoast(message: "Could not retrieve your account details")
        }
       }
       
       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                 withError error: Error!)
       {
         // Perform any operations when the user disconnects from app here.
         // ...
       }
}
