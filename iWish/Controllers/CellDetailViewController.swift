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
    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishLocation: MKMapView!
    
    var wTitle: String?
    var wDescription: String?
    var wPrice: String?
    var wImage: UIImage?
    var lat: Double = 55.36660382646953
    var long: Double = 10.429318644646193
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishTitle.text = wTitle
        wishDescription.text = wDescription
        wishPrice.text = wPrice! + " kr"
        wishImage.image = wImage
        //Setting initial location to user wish
        let wishLocation = CLLocation(latitude: lat, longitude: long)
        centerMapOnLocation(location: wishLocation)
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        wishLocation.setRegion(coordinateRegion, animated: true)
    }
    

}
