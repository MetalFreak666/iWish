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
import FirebaseStorage
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
    @IBOutlet weak var wishImageView: UIImageView!
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
            print("HELLO FROM HERE!")
            self.titleStar.isHidden = true
            self.priceStar.isHidden = true
            
  
            var userLocation:Location?
            
            if setLocationIsActive == true {
                userLocation = Location(latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
            } else {
                userLocation = nil
            }
            
            print("ABOUT TO ADD TO FIREBASE..")
             addWishToDatabase(title: wishTitle.text!,description: wishDescription.text!,price: Int(wishPrice.text!)!, location: userLocation)
            
            
            let alert = UIAlertController(title: "Wish added!!", message: "Your wish has successfully been added!!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_)in
                self.performSegue(withIdentifier: "unwindToMyWishes", sender: self)}))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    func addWishToDatabase (title: String, description: String, price: Int, location: Location?)  {
        print("HELLO FROM FIREBASE METHOD")
        var imageURL:URL?
        var ref: DatabaseReference!
        ref = Database.database().reference()
    
        var reference = ref.child("users").child(UserManager.shared.ID).child("wishes").childByAutoId()
        var key = reference.key!
        let locationDictionary: NSDictionary = [
            "latitude": location?.latitude,
            "longitude": location?.longitude
        ]

        
        let storageRef = Storage.storage().reference().child(key+".png")

        if let uploadData = self.wishImageView.image!.pngData(){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error)in
                if error != nil {
                    print (error)
                    return
                }
                print(metadata)
                
                storageRef.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print("Failed to download url:", error!)
                        return
                    } else {
                        imageURL = url
                        print("HERE COMES THE URL:")
                        print(url!)
                        
 
                        let dictionary: NSDictionary = [
                            "title" : title,
                            "description" : description,
                            "price" : price,
                            "location": locationDictionary,
                            "imageURL": imageURL?.absoluteString
                        ]
                        reference.setValue(dictionary)
                        
                        WishManager.shared.myWishes.append(Wish(id: key, title: title, description: description, price: price, location: location, imageURL: imageURL))
                        
                        
                    }
                    
                })
            })
        }
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
        

        var newImg = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))
        
        wishImageView.image = newImg
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker was cancelled")
        picker.dismiss(animated: true)
    }
    
    
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
