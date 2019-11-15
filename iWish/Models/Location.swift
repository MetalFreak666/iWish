//
//  Location.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit

class Location {
    
    var latitude: Double
    var longitude: Double
    var date: Date
    var dateString: String
    var description: String
    
    init(latitude: Double, longitude: Double, date: Date, dateString: String, description: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.dateString = dateString
        self.description = description
    }
    
}
