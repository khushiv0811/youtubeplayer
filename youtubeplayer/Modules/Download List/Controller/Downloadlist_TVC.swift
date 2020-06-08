//
//  Downloadlist_TVC.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 07/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit
import AVKit

class Downloadlist_TVC: UITableViewController
{
    
    //MARK:- Variables
    ///
    let db: DBHelper = DBHelper()
    ///
    var arr_itemlists : [Itemlist_Model] = [Itemlist_Model]()
    
    
    //MARK:- IBoutlets
    ///
    @IBOutlet weak var tbl_list : UITableView!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getDBData()
    }
    
    //MARK:- Fetch data
    func getDBData()
    {
        CommonMethods.showProgressHud(inView: view)
        arr_itemlists = db.read()
        
       
        CommonMethods.hideProgressHud()
        if arr_itemlists.count == 0
        {
            showtoast(message: "No Downloaded Videos Found")
            
        }
        else
        {
           tbl_list.reloadData()
            
        }
       
    }
    

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return arr_itemlists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "Item_cell", for: indexPath) as! Item_cell
         
         cell.setupcellvalues(item: arr_itemlists[indexPath.row])
       
        return cell
    }
    
//MARK:- Table view Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let homeDirectory = NSURL.fileURL(withPath: NSHomeDirectory(), isDirectory: true)
        
        let fileURL : URL = homeDirectory.appendingPathComponent(String(format: "%@.mp4",arr_itemlists[indexPath.row].videoid!))
               
       let video = AVPlayer(url:fileURL)
         
        let playerViewController = AVPlayerViewController()
        playerViewController.player = video
        present(playerViewController, animated: true, completion:
        {
        video.play()
        })
        
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
