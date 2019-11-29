//
//  HomeViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeText: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeText.text = "Welcome back, "+UserManager.shared.firstName+"!"
    }
    
    
}

