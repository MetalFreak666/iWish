//
//  User.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 29/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var email: String
    var picture: URL
    
    init(name: String, email: String, picture: URL) {
        self.email = email
        self.name = name
        self.picture = picture
    }
    
}
