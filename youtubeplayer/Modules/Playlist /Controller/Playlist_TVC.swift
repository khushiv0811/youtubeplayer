//
//  Playlist_VCTableViewController.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit
import GoogleSignIn

class Playlist_TVC: UITableViewController
{
    // MARK: - Variables
    ///
    var viewModel: Playlist_ViewModel?
    
    ///
    var arr_playlists : [playlist_Model] = [playlist_Model]()
    
    ///
    var selectedindex : Int?
    
    // MARK:  -  Outlets
    
    @IBOutlet weak var tbl_playlists : UITableView!
    
//MARK:- View Controller Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       self.navigationItem.setHidesBackButton(true, animated: true)
        
        getplaylist()
        
    }
    ///
       deinit
       {
           viewModel = nil
          // dataSource = nil
       }
    //MARK:- Get playlist data
    
    func getplaylist()
    {
         CommonMethods.showProgressHud(inView: view)
        
        if viewModel == nil
               {
                   viewModel = Playlist_ViewModel()
               }
              
               viewModel?.getplaylistsdata(){ (success, arr_pl) in
                
                   CommonMethods.hideProgressHud()
                   guard success else
                   {
                      // self.showtoast(message: "Error")
                       return
                   }
                if arr_pl.count > 0
                {
                   self.arr_playlists = arr_pl
                  self.tbl_playlists.reloadData()
                }
                else
                {
                    self.showtoast(message: "No Playlist Found.")
                }
               }
                            
        
    }
    //MARK:- IBActions
    @IBAction func onclick_downloads(_ sender: Any?)
    {
        self.performSegue(withIdentifier: "downloads_segue", sender:   self)
    }
    
    @IBAction func onclick_TapSignOut(_ sender: AnyObject)
    {
      GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "Channelid")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let rootVC = storyboard.instantiateViewController(withIdentifier: "SignIn_VC") as! SignIn_VC
               self.navigationController?.pushViewController(rootVC, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr_playlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlist_cell", for: indexPath) as! playlist_cell
     //   cell.setupcell()
        cell.lbl_playlistname.text = arr_playlists[indexPath.row].title
        cell.lbl_count.text = String(format : "No. Of Videos : %d" ,arr_playlists[indexPath.row].counter!)
        if arr_playlists[indexPath.row].img_url!.count > 0
        {
           
            let escapedAddress = arr_playlists[indexPath.row].img_url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if escapedAddress != nil && escapedAddress != ""
            {
                let URL1 : URL = URL(string: escapedAddress!)!
                cell.img_thumbnail.loadImage(for: URL1)
            }
        } else
        {
            cell.img_thumbnail.image = UIImage(named: "noimage")
        }

        // Configure the cell...

        return cell
    }
    
    //MARK:- Table View Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedindex = indexPath.row
        self.performSegue(withIdentifier: "itemlist_segue", sender:   self)
        
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
        if segue.identifier == "itemlist_segue"
        {
            let vc = segue.destination as! Itemlist_TVC
            vc.playlist = arr_playlists[selectedindex!]
        }
    }
    

}
