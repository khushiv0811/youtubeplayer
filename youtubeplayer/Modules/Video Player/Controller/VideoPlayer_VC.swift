//
//  VideoPlayer_VC.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 06/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit
import YoutubePlayerView
class VideoPlayer_VC: UIViewController
{
    //MARK:- Outlets
     @IBOutlet weak var playerView: YoutubePlayerView!
    ///
    @IBOutlet weak var lbl_videotitle : UILabel!
    ///
    @IBOutlet weak var lbl_author : UILabel!
    ///
    @IBOutlet weak var btn_play : UIButton!
    

    //MARK:- Variables
    var arr_items : [Itemlist_Model] = [Itemlist_Model]()
    ///
    var currentindex : Int = 0
    ///
    var isplayall : Bool = false
    ///
    let playerVars: [String: Any] =
    [
    "controls" : 2, "playsinline" : 1, "autohide" :1, "showinfo" : 0, "modestbranding" : 0, "cc_load_policy" : 0, "rel" : 1,
    "origin": "https://youtube.com"
    ]
    ///
    var currentstate : YoutubePlayerState?
    
    
    //MARK:- View Controller Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerView.delegate = self
        playerView.loadWithVideoId(arr_items[currentindex].videoid!, with: playerVars)
        setupvalues(item: arr_items[currentindex])
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        playerView.stop()
    }
    
    //MARK:- Set up values
    
    func setupvalues(item : Itemlist_Model)
    {
        lbl_author.text = item.author
        lbl_videotitle.text = item.title
    }
    
    //MARK:- IBActions
    @IBAction func onclick_next(_ sender: UIButton)
    {
        if currentindex + 1 < arr_items.count
        {
        currentindex = currentindex + 1
        print("this is" ,currentindex)
        playerView.stop()
        playerView.loadWithVideoId(arr_items[currentindex].videoid!, with: playerVars)
         setupvalues(item: arr_items[currentindex])
        }
        
    }
    
    @IBAction func onclick_previous(_ sender: UIButton)
    {
       
        if currentindex - 1 >= 0
        {
        currentindex = currentindex - 1
        print("this is" ,currentindex)
            
         playerView.stop()
        playerView.loadWithVideoId(arr_items[currentindex].videoid!, with: playerVars)
             setupvalues(item: arr_items[currentindex])
        }
        
    }
   @IBAction func onclick_playpause(_ sender: UIButton)
    {
        if currentstate == YoutubePlayerState.paused
        {
            playerView.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
            
        }
        else
        {
            playerView.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VideoPlayer_VC: YoutubePlayerViewDelegate
{
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView)
    {
       
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
       
        if state == YoutubePlayerState.queued
        {
            playerView.play()
        }
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState)
    {
        print("Changed to state: \(state)")
        currentstate = state
        if currentstate == YoutubePlayerState.playing
        {
            btn_play.setImage(UIImage(named: "pause"), for: .normal)
        }
        if isplayall == true && state == YoutubePlayerState.ended
        {
            onclick_next(UIButton())
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float)
    {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView?
    {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
}
