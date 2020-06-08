//
//  Itemlist_VC.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit


class Itemlist_TVC: UITableViewController, UITextFieldDelegate
{
    //MARK:- Variables
    ///
    var playlist : playlist_Model = playlist_Model()
    ///
    var isSearch = false
    ///
    var arr_searched : [Itemlist_Model] = [Itemlist_Model]()
    ///
    var arr_itemlists : [Itemlist_Model] = [Itemlist_Model]()
    var selectedindex : Int = -1
    ///
     let db: DBHelper = DBHelper()
    
    ///
    var viewModel: itemlist_VM?
    
    //MARK:- Outlets

    @IBOutlet weak var lbl_playlistname : UILabel!
    @IBOutlet weak var lbl_count : UILabel!
    @IBOutlet weak var img_playlist : UIImageView!
    @IBOutlet weak var tbl_items : UITableView!
    @IBOutlet weak var tf_search : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupvalues()
        getplaylist()
    }
    
    deinit
    {
        viewModel = nil
        // dataSource = nil
    }
    
    //MARK:-  Get Item List
 func getplaylist()
 {
    CommonMethods.showProgressHud(inView: view)
    if viewModel == nil
    {
        viewModel = itemlist_VM()
    }
    
    viewModel?.getitemlistsdata(playlistid: playlist.playlistid!)
    { (success, arr_pl) in
    guard success else
        {
            // self.showtoast(message: "Error")
            return
        }
        if arr_pl.count > 0
        {
        self.arr_itemlists = arr_pl
       
        self.tbl_items.reloadData()
        }
        else
        {
            self.showtoast(message: "No Videos found")
        }
         CommonMethods.hideProgressHud()
       
    }
 }
    
   
    
     //MARK:- set up values
    func setupvalues()
    {
        lbl_playlistname.text = playlist.title
        lbl_count.text = String(format : "%d Videos" , playlist.counter!)
        if playlist.img_url!.count > 0
    {
        let escapedAddress = playlist.img_url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if escapedAddress != nil && escapedAddress != ""
        {
            let URL1 : URL = URL(string: escapedAddress!)!
            img_playlist.loadImage(for: URL1)
        }
    }
    else
    {
        img_playlist.image = UIImage(named: "noimage")
    }
        
    }
    //MARK:- IBActions
     @IBAction func onclick_playall(_ sender: UIButton)
     {
        selectedindex = -1
        
         self.performSegue(withIdentifier: "video_segue", sender: self)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearch == true
        {
            return arr_searched.count
        }
        else
        {
        return arr_itemlists.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item_cell", for: indexPath) as! Item_cell
        var currentitem : Itemlist_Model?
        
        if isSearch == true
        {
            currentitem = arr_searched[indexPath.row]
        }
        else
        {
            currentitem = arr_itemlists[indexPath.row]
        }
       
        cell.setupcellvalues(item: currentitem!)
        // download button setup
        if currentitem!.hidedownloadbtn == true
        {
            cell.btn_download.isUserInteractionEnabled = false
            cell.btn_download.isHidden = true
        }
        else
        {
        cell.btn_download.isUserInteractionEnabled = true
        cell.btn_download.isHidden = false
        cell.btn_download.tag = indexPath.row
        
        cell.btn_download.addTarget(self, action: #selector(self.onclick_downloadvideo),for: .touchUpInside)
        }
        
       

        return cell
    }
    
//MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        selectedindex = indexPath.row
        self.performSegue(withIdentifier: "video_segue", sender: self)
        
    }
    
    //MARK:-  Cell button Actions
    
    @IBAction func onclick_downloadvideo(_ sender: UIButton)
    {
        sender.isHidden = true
        CommonMethods.showProgressHud(inView: self.view)
        
        let videoid : String = arr_itemlists[sender.tag].videoid!
        let item : Itemlist_Model = self.arr_itemlists[sender.tag]
        
        if viewModel == nil
        {
          viewModel = itemlist_VM()
        }
         
        
       
        viewModel!.extractvideourl(videoid: videoid, completion:
        { (url_str ,success  ) in
            DispatchQueue.main.async
            {
                
            self.savevideo(videourl: url_str , videoid: videoid, item:item )
            }
        })
    }
    
    func savevideo(videourl : String , videoid : String , item : Itemlist_Model)
    {
       
          if viewModel == nil
          {
            viewModel = itemlist_VM()
          }
       
      
        self.viewModel?.downloadAndSaveVideoFile(videourl, videoid:videoid , completion:
        { (str ,success  ) in
                      
        if success
        {
            item.videourl = str
            let success : Bool =  self.db.insert(item)
            if success
            {
                 
                self.showtoast(message: "Video Downloaded Successfully")
                CommonMethods.hideProgressHud()
                
               
            }
                          // save data to sqlite here
        }
        else
        {
            
            self.showtoast(message:str)
            
            
        }
                      
        })
    }
    
    //MARK: - UITextField Delegate -
       ///
       func textFieldDidChange(textField: UITextField)
       {
           arr_searched.removeAll()
           if (tf_search.text?.count)! > 0
           {
               isSearch = true
           } else
           {
               isSearch = false
           }
       }
       ///
       func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == tf_search
           {
               UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                   self.view.layoutIfNeeded()
               })
               { (finished) in
                   textField.becomeFirstResponder()
               }
               if isSearch
               {
                   return
               }
               isSearch = true
               arr_searched.removeAll()
           }
       }
       ///
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
           {
           
           if textField == tf_search
           {
               let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
               NSLog("%@", newString)
               if newString.count == 0
               {
                   isSearch = false
                self.tbl_items.reloadData()
               } else
               {
                   //  let sanitized: String = newString.stringByReplacingOccurrencesOfString("'", withString: "''")
                   let sanitize : String = newString.replacingOccurrences(of: "'", with: "''")
                   arr_searched.removeAll()
                   self.filteredArray(searchString: sanitize as NSString)
               }
           }
           return true
       }
       ///
       func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {
           if textField == tf_search
           {
               if textField.text?.count == 0
               {
                   isSearch = false
               } else {
                   isSearch = true
               }
               
               tbl_items.reloadData()
           }
           return textField.resignFirstResponder()
       }
       ///
       func filteredArray(searchString:NSString)
       {
           isSearch = true
           arr_searched.removeAll()
        
        arr_searched = arr_itemlists.filter({$0.title!.lowercased().range(of: searchString.lowercased) != nil})
           
          
           tbl_items.reloadData()
       }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "video_segue"
        {
            let vc = segue.destination as! VideoPlayer_VC
            if isSearch == true
            {
                vc.arr_items = arr_searched
            }
            else
            {
            vc.arr_items = arr_itemlists
            }
            
            if selectedindex == -1
            {
                vc.isplayall = true
                vc.currentindex = 0
                
            }
            else
            {
                vc.currentindex = selectedindex
            }
        }
    }
    

}
