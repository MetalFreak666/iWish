//
//  FriendWishTableViewCell.swift
//  iWish
//
//  Created by Dariusz Orasinski on 05/12/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class FriendWishTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var friendWishImage: UIImageView!
    @IBOutlet weak var friendWishTitle: UILabel!
    @IBOutlet weak var friendWishDescription: UILabel!
    @IBOutlet weak var friendWishPrice: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
