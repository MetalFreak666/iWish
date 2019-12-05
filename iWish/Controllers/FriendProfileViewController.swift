//
//  FriendProfileViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 05/12/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var friendsWishesTableView: UITableView!
    var friendEmail: String?
    var friendWishes: [Wish] = []
    var friendName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendInfo ()
        print("THIS IS THE FRIENDS EMAIL:")
        print(friendEmail)
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendWishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendWish = friendWishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsWishCell") as! FriendWishTableViewCell
        
        cell.friendWishTitle.text = friendWish.title
        cell.friendWishDescription.text = friendWish.description
        cell.friendWishPrice.text = String(friendWish.price)
        cell.friendWishImage?.image = friendWish.image
        
        return cell
  
    }
    

    func getFriendInfo () {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            ref.child("users").observeSingleEvent(of: .value){
                (snapshot) in
                let users = snapshot.value as? [String: Any]
                
                if users != nil {
                    for (key,value) in users! {
                        
                        let dictionary = value as! NSDictionary
                        let email = dictionary["email"] as! String
                        let name = dictionary["name"] as? String
                        
                        if(email == self.friendEmail) {
                            self.friendsNameLabel.text = name! + "'s wishes"
                            print("GETTING WISHES BY:")
                            print(name)
                            print("KEY")
                            print(key)
                            self.getFriendWishes(id: key)
                            
                        }
                     //   WishManager.shared.myWishes.append(Wish(id: key, title: title, description: description, price: price, location: location, imageURL: imageURL))
                    }
                    
                }
                
            }
    }
    
    func getFriendWishes (id: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id).child("wishes").observeSingleEvent(of: .value){
            (snapshot) in
            let wishes = snapshot.value as? [String: Any]
            
            if wishes != nil {
                for (key,value) in wishes! {
                    
                    let dictionary = value as! NSDictionary
                    
                    
                    let title = dictionary["title"] as! String
                    let description = dictionary["description"] as? String
                    let price = dictionary["price"] as! Int
                    let location = dictionary["location"] as? Location
                    let imageURL = dictionary["imageURL"] as? URL
                    
                    self.friendWishes.append(Wish(id: key, title: title, description: description, price: price, location: location, imageURL: imageURL))
                    self.friendsWishesTableView.reloadData()

                    
                }
                
            }
            
        }
    }
    


}

