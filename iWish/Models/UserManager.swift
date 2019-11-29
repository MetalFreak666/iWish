//
//  WishManager.swift
//  iWish
//
//  Created by Dariusz Orasin on 20/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

class UserManager {

    static let shared = UserManager()
    
    private init() {}

    var ID: String = ""
    
    var fullname: String = ""
    
    var firstName: String = ""
    
    var lastName: String = ""

    var email: String = ""

    var picture: String = ""
    

}
