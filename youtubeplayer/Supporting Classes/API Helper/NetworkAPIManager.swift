//
//  APIManager.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 KHUSHBOO. All rights reserved.
//

import UIKit
import Alamofire

/// Manage API Manager
class NetworkAPIManager: NSObject {

    // MARK: - Variables
    ///
    let baseurl : String = "https://www.googleapis.com/youtube/v3/"
    let accesskey : String = "AIzaSyDMVs1bqkfcvhKvr5aQ9uF3c50h72VYzjQ"
  
    ///
    class var sharedInstance: NetworkAPIManager
    {
        ///
        struct Static
        {
            ///
            static var instance: NetworkAPIManager?
        }
        if Static.instance == nil {
            Static.instance = NetworkAPIManager()
        }
        return Static.instance ?? NetworkAPIManager() // change
    }
    
    /// requestFor
    ///
    /// - Parameters:
    ///   - url: API URL
    ///   - param: API parameter
    ///   - httpMethod: API method
    ///   - headerParam: header data
    ///   - encodingType: header encoding type
    ///   - completion: completion block for API call back result
    func getAPI(url: String, param: [String: Any]?, httpMethod: HTTPMethod = .get, headerParam: HTTPHeaders? = nil, encodingType: ParameterEncoding = URLEncoding.default, completion:@escaping (_ response: Any?, _ success: Bool) -> Void) {
        if Connectivity.isConnectedToInternet()
        {
            AF.request(url, method: httpMethod, parameters: param, encoding: encodingType, headers: headerParam).responseJSON { response in
                switch response.result
                {
                case .success(let json):
                print(json as! NSDictionary)
                completion(json, true)
                case .failure:
                completion(response, false)
                }
            }
        }
        
        else
        {
            let title = "Error!"
            completion(title, false)
        }
    }
    
    /// Post JSON string
    /// - Parameters:
    ///   - url: url
    ///   - param: json string
    ///   - completion: response and success value of API
    func postJsonString(url: String, param: String, completion:@escaping (_ response: Any?, _ success: Bool) -> Void) {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if url.contains("OrderUp") {
            let cid = UserDefaults.standard.object(forKey: "CompanyID") as? String
            let lid = UserDefaults.standard.object(forKey: "LocationID") as? String
            headers = [
                "Content-Type": "application/json",
                "CompanyID": cid ?? "",
                "LocationID": lid ?? ""
            ]
        }
        guard let data = param.data(using: .utf8) else { return }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if Connectivity.isConnectedToInternet() {
            AF.request(url, method: .post, parameters: anyResult as? [String: Any], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                    
                case .success(let json):
                    print(json as! NSDictionary)
                    completion(json, true)
                case .failure:
                    completion(response, false)
                }
            }
        } else {
            let title = "Error!"
            completion(title, false)
        }
    }
    
    /// POS API
    /// - Parameters:
    ///   - url: url string
    ///   - params: [String: Any]
    ///   - completion: with any and boolean value
    func POSTAPI(_ url: String, _ params: [String: Any], _ completion:@escaping(Any, Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Version": "1.0",
            "Content-Type": "application/json"
        ]
        if Connectivity.isConnectedToInternet() {
            AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
                switch response.result {
                case .success:
                    print(response)
                    completion(response, true)
                case .failure:
                    completion(response, false)
                }
            }
        } else {
            let title = "Error!"
            completion(title, false)
        }
    }
    
    /// FileManager path
    /// - Returns: file path
    func applicationDocumentsDirectory() -> String? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path).last
    }
    
    
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
