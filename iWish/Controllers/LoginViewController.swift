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
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)

    }
    
    func redirectToTabBar () {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        redirectToTabBar()
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
       // self.loginWithReadPermissions()
        
    }
    /*
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


            print("These are your permissions:")
            print(grantedPermissions)
            

            
            self.redirectToTabBar()

        }
        
    }
    */
}


