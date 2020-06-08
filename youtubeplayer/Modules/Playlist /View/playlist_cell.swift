//
//  playlist_cell.swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit

class playlist_cell: UITableViewCell
{
    @IBOutlet weak var lbl_playlistname : UILabel!
    @IBOutlet weak var lbl_count : UILabel!
    @IBOutlet weak var img_thumbnail : UIImageView!
    
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

}
