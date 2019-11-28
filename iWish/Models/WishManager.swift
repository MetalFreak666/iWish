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
    
    //Function used to add wish to the array
    func addWish(wish_title: String, wish_desc: String, wish_price: Int) {
        myWishes.append(Wish(title: wish_title, wishDescription: wish_desc, price: wish_price))
        
        //test
        for element in myWishes {
            print(element)
        }
        
        myWishesDidChange()
    }
    
    func createWish() {
        //test items
        myWishes.append(Wish(title: "PS4", wishDescription: "I want this", price: 2000))
        myWishes.append(Wish(title: "Samsung 8", wishDescription: "I wannt this for my birthday", price: 6000))
    }
    
    func myWishesDidChange() {
        
    }
}
