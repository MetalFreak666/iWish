//
//  MyWishesController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class MyWishesViewController: UIViewController {
    
    private var wishManager: WishManager!
    private var wishes: [Wish]!
    
    @IBOutlet weak var wishTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init
        wishManager = WishManager()
        wishManager.createWish()
        wishes = wishManager.myWishes
        
        wishTableView.dataSource = self
        wishTableView.delegate = self
        
        print("Welcome to the My Wishes screen!");
    }
   
}

extension MyWishesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wish = wishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishTableViewCell") as! WishTableViewCell
        
        cell.wishTitleLabel.text = wish.title
        cell.wishDescriptionLabel.text = wish.wishDescription
        cell.wishPriceLabel.text = String(wish.price)
        
        return cell
    }
}


