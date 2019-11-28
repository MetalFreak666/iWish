//
//  HomeViewController.swift
//  iWish
//
//  Created by Jebisan H. Nadarajah on 04/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeText: UILabel!
    var fbFirstName : String = "INITIAL"

    
    override func viewWillAppear(_ animated: Bool) {
        
        if AccessToken.current?.tokenString != nil {
            GraphRequest(graphPath: "me", parameters:["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    // print("Result:\(String(describing: result)) "as Any)
                }
                
                let dict = result as! NSDictionary
                
                self.fbFirstName = dict["first_name"] as! String
                self.welcomeText.text = "Welcome back, " + self.fbFirstName + "!"
            }
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to the Home screen!");
  
        
    }
    
    
}

