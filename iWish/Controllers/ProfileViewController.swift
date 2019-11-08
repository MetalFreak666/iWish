//
//  ProfileViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to your profile!");

        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("users").setValue(["username": "Jebisan"])

    }
    
    
}

