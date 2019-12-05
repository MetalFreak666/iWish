//
//  Wish.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage


class Wish {
    var id: String
    var title: String
    var description: String?
    var price: Int
    var location: Location?
    var imageURL: URL?
    var image:UIImage?

    
    
    init(id: String, title: String, description: String?, price: Int, location: Location?, imageURL: URL?) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.location = location
        self.imageURL = imageURL
        
        setImage(key: id)
    }
    
    func setImage (key: String) {
        
        let storageRef = Storage.storage().reference(withPath: key+".png")
        
        storageRef.getData(maxSize: 40*1024*1024, completion: { (data, error) in
            if let error = error {
                print("Got an error fetching data..")
                print ( error.localizedDescription)
                return
            }
            if let data = data {
                
                self.image = UIImage(data: data)
                
            }
        })
        
    }
    
    
}

