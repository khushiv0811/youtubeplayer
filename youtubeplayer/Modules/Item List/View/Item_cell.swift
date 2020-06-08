//
//  Item_swift
//  youtubeplayer
//
//  Created by KHUSHBOO on 04/06/20.
//  Copyright © 2020 Khushboo. All rights reserved.
//

import UIKit

class Item_cell: UITableViewCell
{
    @IBOutlet weak var lbl_itemtitle : UILabel!
    @IBOutlet weak var lbl_author : UILabel!
    @IBOutlet weak var lbl_duration : UILabel!
    @IBOutlet weak var btn_download : UIButton!
    @IBOutlet weak var img_thumbnail : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupcellvalues (item : Itemlist_Model)
    {
        lbl_itemtitle.text = item.title
               lbl_author.text = item.author
               lbl_duration.text = item.videoduration
               
               if item.img_url!.count > 0
                      {
                         
                          let escapedAddress = item.img_url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                          if escapedAddress != nil && escapedAddress != ""
                          {
                              let URL1 : URL = URL(string: escapedAddress!)!
                              img_thumbnail.loadImage(for: URL1)
                          }
                      } else
                      {
                          img_thumbnail.image = UIImage(named: "noimage")
                      }
               
    }
}
