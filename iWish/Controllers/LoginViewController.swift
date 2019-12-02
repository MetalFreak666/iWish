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
        self.present(viewController, animated: false, completion: nil)
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
            
        case .success(let grantedPermissions, _, _):
            alertController = UIAlertController(
                title: "Login Success",
                message: "Login succeeded with granted permissions: \(grantedPermissions)",
                preferredStyle: .alert
            )
            
            setUserData()
           
            redirectToTabBar()
        }
        self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction private func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let alertController = UIAlertController(
            title: "Logout",
            message: "Logged out.",
            preferredStyle: .alert
        )
        present(alertController, animated: true, completion: nil)
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
                }
            }
                
            )
        }
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
                    let description = dictionary["description"] as! String
                    let price = dictionary["price"] as! Int
                    let location = dictionary["location"] as? Location

                    
                    WishManager.shared.myWishes.append(Wish(title: title, wishDescription: description, price: price, location: location))
                    
                }
                
            }
      
        }
    }

    
}


