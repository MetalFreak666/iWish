//
//  ProfileViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase

var followEmail: String?

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var followsTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        
        self.nameLabel.text = UserManager.shared.fullname
        self.emailLabel.text = UserManager.shared.email
        self.downloadImage(from: URL(string: UserManager.shared.picture)!)
        
        self.getUsers()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.follows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = UserManager.shared.follows[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = UserManager.shared.follows[indexPath.row]
        followEmail = selectedFriend
        
        performSegue(withIdentifier: "friendProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "friendProfile"){
            var friendProfileViewController = segue.destination as! FriendProfileViewController
            friendProfileViewController.friendEmail = followEmail
        }
    }
    
    
    func getUsers () {
        ref.child("users").observeSingleEvent(of: .value){
            (snapshot) in
            let users = snapshot.value as? [String: Any]
            
            if users != nil {
                for (key,value) in users! {
                    
                    let dictionary = value as! NSDictionary
                    
                    
                    let email = dictionary["email"] as! String
                    
                    UserManager.shared.allUserEmails.append(email)
                }
                
            }
        }
    }
    
    func checkIfEmailExist () -> Bool {
         for email in UserManager.shared.allUserEmails {
            if followEmail == email {
                return true
            }
        }
        return false
    }
    
    func checkIfAlreadyFollows () -> Bool {
        for email in UserManager.shared.follows {
            if followEmail == email {
                return true
            }
        }
        return false

    }
    
    @IBAction func followHandler(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Follow", message: "Please input the email", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Follow", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            followEmail = textField.text!
            self.follow()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
        
        
        
            
        }
    
    func follow () {
        
        
        
        if (checkIfAlreadyFollows()==true){
            let alert = UIAlertController(title: "Error", message: "You are already following this user.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        if (checkIfEmailExist()==false){
            let alert = UIAlertController(title: "Error", message: "This user does not exist.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        if (checkIfEmailExist()==true && checkIfAlreadyFollows()==false) {
            var reference = ref.child("users").child(UserManager.shared.ID).child("follows").childByAutoId()
            var key = reference.key!
            reference.setValue(followEmail)
            
            
            let alert = UIAlertController(title: "Success", message: "You are now following "+followEmail!+"!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            UserManager.shared.follows.append(followEmail!)
            followsTable.reloadData()
            return
        }
    
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        WishManager.shared.myWishes.removeAll()
        let loginManager = LoginManager()
        loginManager.logOut()
        
        
        dismiss(animated: true, completion: nil)
    }
    

    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
}
