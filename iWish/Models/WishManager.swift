//
//  WishManager.swift
//  iWish
//
//  Created by Dariusz Orasin on 20/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

class WishManager {
    
    //Array of Wishes
    var myWishes: [Wish] = []
      
    func createWish() {
        //test
        myWishes.append(Wish(title: "PS4", wishDescription: "I want this", price: 2000))
        myWishes.append(Wish(title: "Samsung 8", wishDescription: "I wannt this for my birthday", price: 6000))
        
        
    }
}
