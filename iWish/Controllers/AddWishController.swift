//
//  AddWishController.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class AddWishController: UIViewController {
    
    private var wish: Wish?
        
    //TextFields title and description
    @IBOutlet weak var wishTitle: UITextField!
    @IBOutlet weak var wishDescription: UITextField!
    @IBOutlet weak var test: UITextField!
    
    @IBAction func onActionAddWish(_ sender: UIButton) {
        wish = Wish(title: wishTitle.text, description: wishDescription.text)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to the Add Wish Screen!");
        
    }
}
