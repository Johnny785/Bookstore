//
//  AddViewController.swift
//  Bookstore
//
//  Created by Johnny Yang on 12/5/22.
//

import Foundation
import UIKit
import CoreLocation

class AddViewController:UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewField: UITextField!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingBar: UISlider!
    @IBOutlet weak var ShareLocation: UILabel!
    @IBOutlet weak var locSwitch: UISwitch!
    
    let manager = CLLocationManager()
    let decoder = CLGeocoder.init()
    var userAddress:String = ""
    var auth = false // If we can access location of user
    
    // Initialize properties for location manager and ask for permission
    override func viewDidLoad() {
        super.viewDidLoad()
        locSwitch.isOn = false
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 100
        self.manager.requestWhenInUseAuthorization()
        auth = (manager.authorizationStatus == .authorizedWhenInUse||manager.authorizationStatus == .authorizedAlways)
        let gesture = UITapGestureRecognizer(target:self, action:#selector(self.backgroundTapped(_:)))
        gesture.numberOfTapsRequired=1
        self.view.addGestureRecognizer(gesture)
        reviewField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
    }
    
    // When background is tapped dismiss keyboard
    @objc func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        reviewField.resignFirstResponder()
    }
    
    // Parse the location of user and update accordingly
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first{
            let latitude = loc.coordinate.latitude
            let longitude = loc.coordinate.longitude
            decoder.reverseGeocodeLocation(CLLocation.init(latitude:latitude, longitude:longitude)){(placemakers,error) in
                    if let allAddr = placemakers{
                        let pm = allAddr[0] as CLPlacemark
                        let city = (pm.locality != nil) ? pm.locality! + ", ":""
                        let country = (pm.country ?? "") as String
                        self.userAddress = "\(city)\(country)"
                }
                
            }
        }
    }
    
    // If request denied, set the switch and the auth flag
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locSwitch.isOn = false
        auth = false
    }
    
    // Append the new review to current product
    @IBAction func submitReview(_ sender: UIButton) {
        if let user = userModel.currentUser{
            let location = locSwitch.isOn ? userAddress:""
            let review:review = review(firstName:user.firstName,lastName:user.lastName,review:reviewField.text!,location:location)
            productModel.shared.currentProduct!.reviews.append(review)
            productModel.shared.currentProduct!.rating = (productModel.shared.currentProduct!.rating*Double(productModel.shared.products.count)+Double(5*ratingBar.value))/(Double(productModel.shared.products.count+1))
        }
        else{
            let alertController = UIAlertController(title: "Warning", message: "You are not logged in, please login",
            preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated:true)
        }
        reviewField.text = ""
        ratingBar.value = 0
        ratingLabel.text = "0.0"
    }
    
    // Check if we could turn on the switch, and tell manager to start/stop updating locations accordingly
    @IBAction func switchChange(_ sender: UISwitch) {
        if(sender.isOn){
            if auth{
                self.manager.startUpdatingLocation()
            }
            else{
                self.locSwitch.isOn = false
            }
        }
        else{
            self.manager.stopUpdatingLocation()
        }
        locSwitch.resignFirstResponder()
    }
    
    
    // Change rating label according to slider
    @IBAction func ratingChanged(_ sender: UISlider) {
        ratingLabel.text=String(5*Double(sender.value))
    }
}
