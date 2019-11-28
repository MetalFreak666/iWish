//
//  AddWishController.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class AddWishController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var wishManager: WishManager!
    private var wishes: [Wish]!
    
    //TextFields title and description
    @IBOutlet weak var wishTitle: UITextField!
    @IBOutlet weak var wishDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wishPrice: UITextField!
    
    @IBOutlet weak var titleStar: UILabel!
    @IBOutlet weak var priceStar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to the Add Wish Screen!");
        
        //Stars for user input check
        self.titleStar.isHidden = true
        self.priceStar.isHidden = true
    }
    
    @IBAction func addWish(_ sender: UIBarButtonItem) {
        
        print("Wish added!")
        
        if let input = wishTitle.text, input.isEmpty {
            self.titleStar.isHidden = false
        } else if let input = wishPrice.text, input.isEmpty {
            self.priceStar.isHidden = false
            //Proceed from her
        } else {
            //Converting values from inputText
            let title: String = wishTitle.text!
            let description: String = wishDescription.text!
            let price = Int(wishPrice.text!)!
            
            wishManager.myWishes.append(Wish(title: title, wishDescription: description,price: price ))
            
            self.titleStar.isHidden = true
            self.priceStar.isHidden = true

        }
    }
    
  
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                } else {
                print("Device has no camera..")
                }
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

    self.present(actionSheet, animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.originalImage] as! UIImage
        imageView.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
       
    
}
