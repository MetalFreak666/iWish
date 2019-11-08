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
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var wishTitle: UITextField!
    @IBOutlet weak var wishDescription: UITextField!
    @IBOutlet weak var wishPrice: UITextField!
    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var test: UILabel!
    
    //Getting wish title and description
    @IBAction func onActionAddWish(_ sender: UIButton) {
        //Checking if title or price field is empty
        if let input = wishTitle.text, input.isEmpty {
            test.text = "Title cannot be empty"
        } else if let input = wishPrice.text, input.isEmpty {
            test.text = "Price cannot be empty"
        //Proceed from her
        } else {
            wish = Wish(title: wishTitle.text, description: wishDescription.text, price: wishPrice.text)
            test.text = nil
            //Test
            print(wish!)
        }
    }
    
    //Used to taking photo
    @IBAction func onActionTakePhoto(_ sender: Any) {
        //imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        //imagePicker.sourceType = .camera
        //present(imagePicker, animated: true, completion: nil)
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to the Add Wish Screen!");
        
    }
}
