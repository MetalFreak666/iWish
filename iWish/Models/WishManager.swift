//
//  WishManager.swift
//  iWish
//
//  Created by Dariusz Orasin on 20/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

class WishManager {

    
    static let shared = WishManager()
    
    var myWishes: [Wish] = []
    
    private init() {}
    
    func getWishes () -> [Wish] {
        return myWishes
    }
    
    
    
    
}
