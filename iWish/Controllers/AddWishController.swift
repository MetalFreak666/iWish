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
import Firebase
import MobileCoreServices

class AddWishController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Defining region for location
    let locationManager = CLLocationManager()
    let regionLatMeters: Double = 200
    let regionLongMeter: Double = 150
    
    var setLocationIsActive = false
    
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
        
        print("Welcome to the Add Wish Screen!");
        
        //Init of WishManager class with some test data
        
        
        //Stars for user input check
        self.titleStar.isHidden = true
        self.priceStar.isHidden = true
    }
    
    
    @IBAction func userLocationIsActive(_ sender: Any) {
        checkIfLocationServiceIsAvailable()
        setLocationIsActive = true
    }
    
    
    
    @IBAction func addWish(_ sender: UIBarButtonItem) {
        
        if let input = wishTitle.text, input.isEmpty {
            self.titleStar.isHidden = false
        } else if let input = wishPrice.text, input.isEmpty {
            self.priceStar.isHidden = false
        } else  {
            
            self.titleStar.isHidden = true
            self.priceStar.isHidden = true
            
            let title: String = wishTitle.text!
            let description: String = wishDescription.text!
            let price = Int(wishPrice.text!)!
            var userLocation:Location?
            
            if setLocationIsActive == true {
                userLocation = Location(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
            } else {
                userLocation = nil
            }
            
            var key = self.addWishToDatabase(title: wishTitle.text!,description: wishDescription.text!,price: Int(wishPrice.text!)!, location: userLocation)
            WishManager.shared.myWishes.append(Wish(id: key, title: title, wishDescription: description, price: price, location: userLocation, Photo: nil))
            
            let alert = UIAlertController(title: "Wish added!!", message: "Your wish has successfully been added!!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_)in
                self.performSegue(withIdentifier: "unwindToMyWishes", sender: self)}))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    func addWishToDatabase (title: String, description: String, price: Int, location: Location?) -> String {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let locationDictionary: NSDictionary = [
            "latitude": location?.latitude,
            "longitude": location?.longitude
        ]
        
        let dictionary: NSDictionary = [
            "title" : title,
            "description" : description,
            "price" : price,
            "location": locationDictionary
        ]
        
        var reference = ref.child("users").child(UserManager.shared.ID).child("wishes").childByAutoId()
        
        reference.setValue(dictionary)
        var key = reference.key!

        
        return key
    }
    
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.present(imagePickerController, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
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
        picker.dismiss(animated: true)
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
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionLatMeters, longitudinalMeters: regionLongMeter)
        locationView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
