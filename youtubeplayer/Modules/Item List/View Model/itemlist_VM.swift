//
//  itemlist_VM.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 05/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import Foundation
import YoutubeDirectLinkExtractor

class itemlist_VM : NSObject
{
    // MARK: - Variables
      ///
      var arr_itemslist : [Itemlist_Model] = [Itemlist_Model]()
    ///
    let db: DBHelper = DBHelper()
          // MARK: - API call mathods
         
         /// Help to get category
         /// - Parameter : playlistid 
    /// completion: for Success and array of Itemlistmoded
    func getitemlistsdata( playlistid : String , _ completion:@escaping(Bool, [Itemlist_Model]) -> Void)
         {
            let url_str1 : String = String(format: "%@playlistItems?part=contentDetails&part=snippet&playlistId=%@&key=%@",NetworkAPIManager.sharedInstance.baseurl,playlistid , NetworkAPIManager.sharedInstance.accesskey)
           // let url_str : String = String (format : "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&part=snippet&playlistId=%@&key=AIzaSyDMVs1bqkfcvhKvr5aQ9uF3c50h72VYzjQ" , playlistid)
       
            var videoid : String = ""
            
            NetworkAPIManager.sharedInstance.getAPI(url: url_str1, param: nil, completion:
          {(_ result: Any, _ success: Bool) -> Void in
           if success
           {
              let dict_json : NSDictionary = result as! NSDictionary
            
            let arr_items  : NSArray = dict_json["items"] as! NSArray
            for i in 0 ..< arr_items.count
            {
                let idict : NSDictionary = arr_items[i] as! NSDictionary
                let im : Itemlist_Model = Itemlist_Model()
                im.title = (idict["snippet"]
                as? [String: Any])?["title"] as? String
                im.img_url =  (((idict["snippet"] as? [String: Any])?["thumbnails"] as? [String: Any])?["standard"] as? [String: Any])?["url"] as? String
                im.videoid = ((idict["snippet"] as? [String: Any])?["resourceId"] as? [String: Any])?["videoId"] as? String
                im.hidedownloadbtn = self.db.checkforvideo(videoid: im.videoid!)
              
                videoid.append("&id=")
                videoid.append(im.videoid!)
                
                self.arr_itemslist.append(im)
               
            }
            
            
            let videourl : String = String(format: "%@videos?part=contentDetails&part=snippet%@&key=%@",NetworkAPIManager.sharedInstance.baseurl,videoid,NetworkAPIManager.sharedInstance.accesskey )
           
            NetworkAPIManager.sharedInstance.getAPI(url: videourl, param: nil, completion:
            {(_ result: Any, _ success: Bool) -> Void in
                if success
                {
                    let vdict_json : NSDictionary = result as! NSDictionary
                    
                    let arr_videodetails  : NSArray = vdict_json["items"] as! NSArray
                   
                    for i in 0 ..< self.arr_itemslist.count
                    {
                        let vdict = arr_videodetails[i] as! NSDictionary
                        
                        self.arr_itemslist[i].author = ((vdict["snippet"]
                        as? [String: Any])?["channelTitle"] as? String)!
                         print(self.arr_itemslist[i].author!)
                        let duration : String = ((vdict["contentDetails"]
                            as? [String: Any])?["duration"] as? String)!
                        
                        self.arr_itemslist[i].videoduration = duration.parseVideoDurationOfYoutubeAPI(videoDuration: duration) as String
                       
                        
                    }
                
                    
                completion(success, self.arr_itemslist)
                
                }
                else
                 {
                    //self.showtoast(message: "Error")
                    completion(success, [])
                }
              })
            
                        
              
          }
           else
           {
              //self.showtoast(message: "Error")
              completion(success, [])
          }
          })
      }
    
    //MARK:- Extract Video URL
    func extractvideourl(videoid : String , completion: @escaping (String , Bool) -> Void)
       {
           
          
           let y = YoutubeDirectLinkExtractor()
           y.extractInfo(for: .id(videoid), success:
           {
               info in
               
             completion(info.lowestQualityPlayableLink! , true)
           })
           {
            error in
            print(error)
            completion("", false)
            }
               
           
       }
    
    //MARK:- Download Video
    
func downloadAndSaveVideoFile(_ videourl: String , videoid : String, completion: @escaping (String , Bool) -> Void)
{
    let homeDirectory = NSURL.fileURL(withPath: NSHomeDirectory(), isDirectory: true)
        
    let fileURL = homeDirectory.appendingPathComponent(String(format: "%@.mp4", videoid))
    let urlData = NSData(contentsOf:URL(string: videourl)!)
    urlData?.write(to: fileURL, atomically: true)
    
    completion("" , true)
}
    
    
}
    
       
    

