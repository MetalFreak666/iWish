//
//  WishTableViewCell.swift
//  iWish
//
//  Created by Dariusz Orasin on 20/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class WishTableViewCell: UITableViewCell {

    @IBOutlet weak var wishTitleLabel: UILabel!
    @IBOutlet weak var wishDescriptionLabel: UILabel!
    @IBOutlet weak var wishPriceLabel: UILabel!
    @IBOutlet weak var wishImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
