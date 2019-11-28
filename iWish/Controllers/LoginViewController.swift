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



class LoginViewController: UIViewController {

    var fbId : String = "INITIAL"
    var fbEmail : String = "INITIAL"
    var fbFirstName : String = "INITIAL"
    var fbPickUrl : String = "INITIAL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBAction func facebookLoginHandler(_ sender: UIButton) {
        loginWithReadPermissions()
    }
    
    func redirectToTabBar () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        redirectToTabBar()
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
    
}


