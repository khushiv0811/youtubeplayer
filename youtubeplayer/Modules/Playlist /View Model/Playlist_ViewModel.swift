//
//  Playlist_ViewModel.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import Foundation

/// Manage API call for Playlists

class Playlist_ViewModel : NSObject
{
    // MARK: - Variables
    ///
    var arr_playlists : [playlist_Model] = [playlist_Model]()
    // MARK: - API call mathods
       
       /// Help to get category
       /// - Parameter completion: for Success and array of categorymodel
       func getplaylistsdata(_ completion:@escaping(Bool, [playlist_Model]) -> Void)
       {
        let urlstr : String = String(format: "%@playlists?part=snippet,contentDetails&channelId=%@&key=%@",NetworkAPIManager.sharedInstance.baseurl , UserDefaults.standard.value(forKey: "Channelid") as! CVarArg , NetworkAPIManager.sharedInstance.accesskey )
      
         NetworkAPIManager.sharedInstance.getAPI(url: urlstr, param: nil, completion:
        {(_ result: Any, _ success: Bool) -> Void in
         if success
         {
            let dict_json : NSDictionary = result as! NSDictionary
            let arr_items  : NSArray = dict_json["items"] as! NSArray
            for i in 0 ..< arr_items.count
            {
                let idict : NSDictionary = arr_items[i] as! NSDictionary
                let pm : playlist_Model = playlist_Model()
                pm.playlistid = idict["id"] as? String
                
                pm.title = (idict["snippet"]
                as? [String: Any])?["title"] as? String
                
                pm.img_url =  (((idict["snippet"] as? [String: Any])?["thumbnails"] as? [String: Any])?["standard"] as? [String: Any])?["url"] as? String
                
                pm.counter = (idict["contentDetails"] as? [String: Any])?["itemCount"] as? Int
                print( pm.title! )
                print(pm.img_url!)
                print( pm.counter!)
               
                self.arr_playlists.append(pm)
            }
                      
            completion(success, self.arr_playlists)
        }
         else
         {
            //self.showtoast(message: "Error")
            completion(success, [])
        }
        })
    }
}
