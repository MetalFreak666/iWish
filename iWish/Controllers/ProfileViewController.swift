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

class ProfileViewController: UIViewController {
    
    var fbId : String = "INITIAL"
    var fbEmail : String = "INITIAL"
    var fbName : String = "INITIAL"
    var fbPickUrl : String = "INITIAL"
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to your profile!");
        setUserData()
        


        /*var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").setValue(["username": "Jebisan"])
        */
        
    }
    
    func setUserData (){
        if AccessToken.current?.tokenString != nil {
            GraphRequest(graphPath: "me", parameters:["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    // print("Result:\(String(describing: result)) "as Any)
                }
                
                let dict = result as! NSDictionary
                
                self.fbId = dict["id"] as! String
                self.fbName = dict["name"] as! String
                self.fbEmail = dict["email"] as! String
                self.fbPickUrl = (((dict["picture"] as? [String: Any])?["data"] as? [String:Any])?["url"] as? String)!
                
                print("TEST FRA PROFIL");
                print(self.fbName)
                self.downloadImage(from: URL(string: self.fbPickUrl)!)
                self.nameLabel.text = self.fbName
                self.emailLabel.text = self.fbEmail
                
            }
            )
        }
    }

    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
    
}
