//
/*
AddToiletViewController.swift
Created on: 7/5/18

Abstract:
this class will manage all tasks related with adding the toilet.

*/

import UIKit
import MapKit
import Firebase

final class AddToiletViewController: UIViewController {
    
    // MARK: Properties
    /// PRIVATE
    
    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var reviewDescription: UILabel!
    @IBOutlet weak private var name: UITextField!
    @IBOutlet weak private var addressTypeahead: CIAddressTypeahead!
    
    /// ratings buttons
    @IBOutlet weak private var rate1: UIButton!
    @IBOutlet weak private var rate2: UIButton!
    @IBOutlet weak private var rate3: UIButton!
    @IBOutlet weak private var rate4: UIButton!
    @IBOutlet weak private var rate5: UIButton!
    
    private var rate: UInt8 = 5
    private let db = (UIApplication.shared.delegate as! AppDelegate).db
    private var placemark: MKPlacemark?
    private let locationManager = CLLocationManager()
    
    // file constants
    private struct C {
        static let star1Comment = "Never coming back again."
        static let star2Comment = "Managed it, but not coming back."
        static let star3Comment = "Its okay, but they should have cleaned it."
        static let star4Comment = "Its was fine, thank God."
        static let star5Comment = "Thank God, it was Heaven."
    }

    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscriberKeyboardNotifications()
    }
    
    
    // MARK: Button Actions
    
    @IBAction func onTouchReviewStar(_ sender: UIButton) {
        
        // todo: code refactor
        
        switch sender.tag {
        case 1:
            rate1.isSelected = true
            rate2.isSelected = false
            rate3.isSelected = false
            rate4.isSelected = false
            rate5.isSelected = false
            reviewDescription.text = C.star1Comment
        case 2:
            rate1.isSelected = true
            rate2.isSelected = true
            rate3.isSelected = false
            rate4.isSelected = false
            rate5.isSelected = false
            reviewDescription.text = C.star2Comment
        case 3:
            rate1.isSelected = true
            rate2.isSelected = true
            rate3.isSelected = true
            rate4.isSelected = false
            rate5.isSelected = false
            reviewDescription.text = C.star3Comment
        case 4:
            rate1.isSelected = true
            rate2.isSelected = true
            rate3.isSelected = true
            rate4.isSelected = true
            rate5.isSelected = false
            reviewDescription.text = C.star4Comment
        case 5:
            rate1.isSelected = true
            rate2.isSelected = true
            rate3.isSelected = true
            rate4.isSelected = true
            rate5.isSelected = true
            reviewDescription.text = C.star5Comment
        default:
            print("Review Selection Invalid")
        }
        rate = UInt8(sender.tag)
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
        onAdd()
    }
    
    @IBAction func onMyLocation(_ sender: UIButton) {
        getCurrentLocation()
    }
}

// MARK: Private helper functions

private extension AddToiletViewController {
    /**
     gets current location.
     */
    func getCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    /**
     sets up the whole UI configurations in this function
     - focus the map to Kerala
     - todo:
     - check if we can gray out the outside area.
     - auto zoom to the user location when he enabled the location.
     */
    func configureUI() {
        setRegion(Constants.Kerala.FullViewCoordinates.latitude,
                  longitude: Constants.Kerala.FullViewCoordinates.longitude,
                  delta: Constants.Kerala.FullViewCoordinates.delta)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func onLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let toilet = Toilet()
            let location: Location = Location(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            let geometry: Geometry = Geometry(location: location)
            toilet.geometry = geometry
            let loc = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { [unowned self] (placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error \(error!.localizedDescription)")
                    return
                }

                if (placemarks?.count ?? 0) > 0 {
                    let pm: CLPlacemark = placemarks![0]
                    self.placemark = MKPlacemark(placemark: pm)
                    var name = ""
                    if let sublocality = pm.subLocality {
                        name += sublocality
                    }
                    
                    if let subAdministrativeArea = pm.subAdministrativeArea {
                        name += ", \(subAdministrativeArea)"
                    }
                    
                    if let administrativeArea = pm.administrativeArea, let postalCode = pm.postalCode {
                        name += ", \(administrativeArea) \(postalCode)"
                    }
                    
                    toilet.name = name
                    toilet.address = pm.postalCode
                    self.addressTypeahead.text = name
                    self.addressTypeahead.becomeFirstResponder()
                    self.mapView.addAnnotation(toilet)
                }
            })
        }
    }
    
    /**
     sets the region on the map
     */
    func setRegion(_ latitude: Double, longitude: Double, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta,
                                    longitudeDelta: delta)
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func onAdd() {
        // GUARD: valid name
        guard let name = self.name.text else {
            return
        }
        
        // GUARD: valid coordinate
        guard let coordinate = placemark?.coordinate else {
            return
        }
        
        // GUARD: valid address
        guard let address = placemark?.title else {
            return
        }
        
        onSave(name,
               rating: rate,
               address: address,
               coordinate: GeoPoint(latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
        ) {[unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     saves the information to Firebase realtime database
     - parameters:
        - name: name of the toilet
        - rating: rating from the user
        - address: address of the toilet
        - coordinate: coordinates of the toilet
        - completion: self descriptive
     */
    func onSave(_ name: String,
                rating: UInt8,
                address: String,
                coordinate: GeoPoint,
                completion: @escaping () -> Void) {
        
        db?.collection(Constants.Firestore.Keys.TOILETS).addDocument(data: [
            Constants.Firestore.Keys.NAME: name,
            Constants.Firestore.Keys.RATING: rating,
            Constants.Firestore.Keys.ADDRESS: address,
            Constants.Firestore.Keys.COORDINATE: coordinate
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completion()
            }
        }
    }
}

// MARK: AddToiletViewController -> CIAddressTypeaheadProtocol

extension AddToiletViewController: CIAddressTypeaheadProtocol {
    func didSelectAddress(placemark: MKPlacemark) {
        self.placemark = placemark
    }
}

// MARK: AddToiletViewController -> CLLocationManagerDelegate

extension AddToiletViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = manager.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: location.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
        }
        
    }
}

extension AddToiletViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddToiletViewController {
    func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscriberKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardShown(notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardHide(notification: Notification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}

