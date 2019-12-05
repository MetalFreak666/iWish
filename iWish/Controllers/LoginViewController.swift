//
//  LoginViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//
import UIKit
import FacebookLogin
import FacebookCore
import Firebase
import FirebaseStorage

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMyWishes(segue: UIStoryboardSegue) {
    }

    
    @IBAction func facebookLoginHandler(_ sender: UIButton) {
        loginWithReadPermissions()
    }
    
    @IBAction func skip(_ sender: UIButton) {
        redirectToTabBar()
    }
    
    func redirectToTabBar () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(
                title: "Login Cancelled",
                message: "User cancelled login.",
                preferredStyle: .alert
            )
            
        case .failed(let error):
            alertController = UIAlertController(
                title: "Login Fail",
                message: "Login failed with error \(error)",
                preferredStyle: .alert
            )
        case .success(_, _, _):
            setUserData()

        }
            }
    
    @IBAction private func loginWithReadPermissions() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .email],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }


    
    func setUserData () {
        if AccessToken.current?.tokenString != nil {
            GraphRequest(graphPath: "me", parameters:["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! NSDictionary

                    UserManager.shared.ID=dict["id"] as! String
                    UserManager.shared.fullname=dict["name"] as! String
                    UserManager.shared.firstName=dict["first_name"] as! String
                    UserManager.shared.lastName=dict["last_name"] as! String
                    UserManager.shared.picture = (((dict["picture"] as? [String: Any])?["data"] as? [String:Any])?["url"] as? String)!
                    UserManager.shared.email=dict["email"] as! String
                    

                    self.setMyWishes()
                    self.setFollows()
                    self.setUserDetails()
                }
            }
                
            )
        }
    }
    
    func setFollows () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/"+UserManager.shared.ID+"/follows").observeSingleEvent(of: .value){
            (snapshot) in
            let follows = snapshot.value as? [String: Any]
            
            if follows != nil {
                for (key,value) in follows! {
                    
                    var follow = value as! NSString
                    
                    
                    UserManager.shared.follows.append(follow as String)
                    
                    
                    
                }
                
            }
            
        }
        redirectToTabBar()
    }
    
    func setUserDetails () {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(UserManager.shared.ID)/email").setValue(UserManager.shared.email)
        ref.child("users/\(UserManager.shared.ID)/name").setValue(UserManager.shared.fullname)
        
    }

    func setMyWishes () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/"+UserManager.shared.ID+"/wishes").observeSingleEvent(of: .value){
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

                    
                    WishManager.shared.myWishes.append(Wish(id: key, title: title, description: description, price: price, location: location, imageURL: imageURL))
                    
   
                    
                }
                
            }
      
        }
        
       
        
        
        redirectToTabBar()

    }

    
}


