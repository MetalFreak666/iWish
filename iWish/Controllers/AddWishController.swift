//
//  AddWishController.swift
//  iWish
//
//  Created by Dariusz Orasinski on 08/11/2019.
//  Copyright © 2019 SDU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddWishController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var wishManager: WishManager!
    private var wishes: [Wish]!
    
    //Defining region for location
    let locationManager = CLLocationManager()
    let regionLatMeters: Double = 2000
    let regionLongMeter: Double = 1500
    
    //TextFields title and description
    @IBOutlet weak var wishTitle: UITextField!
    @IBOutlet weak var wishDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var wishPrice: UITextField!
    
    @IBOutlet weak var titleStar: UILabel!
    @IBOutlet weak var priceStar: UILabel!
    
    @IBOutlet weak var locationView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLocationServiceIsAvailable()
        print("Welcome to the Add Wish Screen!");
        
        //Init of WishManager class with some test data
        wishManager = WishManager()
        wishManager.createWish()
        wishes = wishManager.myWishes
        
        //Stars for user input check
        self.titleStar.isHidden = true
        self.priceStar.isHidden = true
    }
    
    @IBAction func addWish(_ sender: UIBarButtonItem) {
        
        print("Wish added!")
        
        if let input = wishTitle.text, input.isEmpty {
            self.titleStar.isHidden = false
        } else if let input = wishPrice.text, input.isEmpty {
            self.priceStar.isHidden = false
            //Proceed from her
        } else {
            //Converting values from inputText
            let title: String = wishTitle.text!
            let description: String = wishDescription.text!
            let price = Int(wishPrice.text!)!
            
            wishManager.addWish(wish_title: title, wish_desc: description, wish_price: price)
            
            self.titleStar.isHidden = true
            self.priceStar.isHidden = true

        }
    }
    
  
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                } else {
                print("Device has no camera..")
                }
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

    self.present(actionSheet, animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.originalImage] as! UIImage
        imageView.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Checking if location service is enabled on user device
    func checkIfLocationServiceIsAvailable() {
        if CLLocationManager.locationServicesEnabled() {
            setupOfLocationManager()
            checkAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: "Location service is not available", message: "Please check if your location service is turned on", preferredStyle: .alert)
            
            //alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        }
    }
    
    func centerViewOnUser() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionLatMeters, longitudinalMeters: regionLongMeter)
            locationView.setRegion(region, animated: true)
        }
    }
    
    func setupOfLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationView.showsUserLocation = true
            centerViewOnUser()
            break
        case .denied:
            //Implement alert showing alert that instructing to turn permision
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //alert
            break
        case .authorizedAlways:
            break
        }
    }
    
}

extension AddWishController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        guard let location = locations.last else
        {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionLatMeters, longitudinalMeters: regionLongMeter)
        locationView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
