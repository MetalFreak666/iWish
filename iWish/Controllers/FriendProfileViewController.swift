//
//  FriendProfileViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 05/12/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import Firebase
var selectedFriendWishTitle: String?
var selectedFriendWishDescription: String?
var selectedFriendWishPrice: String?
var selectedFriendWishImage: UIImage?
var selectedFriendWishLat: Double?
var selectedFriendWishLong: Double?

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var friendsWishesTableView: UITableView!
    var friendEmail: String?
    var friendWishes: [Wish] = []
    var friendName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            self.friendsWishesTableView.reloadData()
        }
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getFriendInfo ()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendWishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendWish = friendWishes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsWishCell") as! FriendWishTableViewCell
        
        cell.friendWishTitle.text = friendWish.title
        cell.friendWishDescription.text = friendWish.description
        cell.friendWishPrice.text = String(friendWish.price)+" kr"
        cell.friendWishImage?.image = friendWish.image
        
        return cell
  
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriendWish = friendWishes[indexPath.row]
        
        selectedFriendWishTitle = selectedFriendWish.title
        selectedFriendWishDescription = selectedFriendWish.description
        selectedFriendWishPrice = String(selectedFriendWish.price)
        selectedFriendWishImage = selectedFriendWish.image
        selectedFriendWishLat = selectedFriendWish.location?.latitude
        selectedFriendWishLong = selectedFriendWish.location?.longitude
        
        performSegue(withIdentifier: "showFriendWishDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFriendWishDetails") {
            var detailedViewController = segue.destination as! CellDetailViewController
            
            detailedViewController.wTitle = selectedFriendWishTitle
            detailedViewController.wDescription = selectedFriendWishDescription
            detailedViewController.wPrice = selectedFriendWishPrice
            detailedViewController.wImage = selectedFriendWishImage
            
            if(selectedWishLong != nil) {
                detailedViewController.lat = selectedFriendWishLat!
                detailedViewController.long = selectedFriendWishLong!
            } else {
                detailedViewController.lat = 55.36660382646953
                detailedViewController.long = 10.429318644646193
            }
            
        }
        
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
                            self.getFriendWishes(id: key)
                            
                        }
                    }
                    
                }
                
            }
    }
    
    @IBAction func reloadTable(_ sender: UIButton) {
        print("RELOADING!")
        friendsWishesTableView.reloadData()
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

