//
//  CellDetailViewController.swift
//  iWish
//
//  Created by Dariusz Orasinski on 04/12/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import MapKit

class CellDetailViewController: UIViewController  {

    
    @IBOutlet weak var wishTitle: UILabel!
    @IBOutlet weak var wishDescription: UILabel!
    @IBOutlet weak var wishPrice: UILabel!
    @IBOutlet weak var wishPicture: UIImageView!
    @IBOutlet weak var wishLocation: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
