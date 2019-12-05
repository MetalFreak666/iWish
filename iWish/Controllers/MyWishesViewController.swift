//
//  MyWishesController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

var selectedWishTitle: String?
var selectedWishDescription: String?
var selectedWishPrice: String?
var selectedWishImage: UIImage?
var selectedWishLat: Double?
var selectedWishLong: Double?

class MyWishesViewController: UIViewController {
    

    @IBOutlet weak var wishTableView: UITableView!
    
    @IBAction func unwindToMyWishes(segue: UIStoryboardSegue) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init
        wishTableView.dataSource = self
        wishTableView.delegate = self
        print("Welcome to the My Wishes screen!");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishTableView.reloadData()
    }
    
}

extension MyWishesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishManager.shared.myWishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wish = WishManager.shared.myWishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishTableViewCell") as! WishTableViewCell
        
        cell.wishTitleLabel.text = wish.title
        cell.wishDescriptionLabel.text = wish.description
        cell.wishPriceLabel.text = String(wish.price) + " kr"
        cell.imageView?.image = wish.image
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wishSelected = WishManager.shared.myWishes[indexPath.row]
        selectedWishTitle = wishSelected.title
        selectedWishDescription = wishSelected.description
        selectedWishPrice = String(wishSelected.price)
        selectedWishImage = wishSelected.image
        selectedWishLat = wishSelected.location?.latitude
        selectedWishLong = wishSelected.location?.longitude
        
        performSegue(withIdentifier: "showWishDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showWishDetails") {
            var detailedViewController = segue.destination as! CellDetailViewController
            detailedViewController.wTitle = selectedWishTitle
            detailedViewController.wDescription = selectedWishDescription
            detailedViewController.wPrice = selectedWishPrice
            detailedViewController.wImage = selectedWishImage
            if(selectedWishLong != nil) {
                detailedViewController.lat = selectedWishLat!
                detailedViewController.long = selectedWishLong!
            } else {
                detailedViewController.lat = 0.0
                detailedViewController.long = 0.0
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
}


