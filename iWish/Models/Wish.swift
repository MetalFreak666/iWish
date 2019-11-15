//
//  Wish.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class Wish: NSObject {
    
    var title: String
    var wishDescription: String
    var price: Int
    //Used later
    //var wishPhoto: UIImage?
    
    init(title: String, wishDescription: String, price: Int) {
        self.title = title
        self.wishDescription = wishDescription
        self.price = price
        //self.wishPhot = wishPhoto
    }
    
}
