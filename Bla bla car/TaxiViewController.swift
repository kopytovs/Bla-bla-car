//
//  TaxiViewController.swift
//  Bla bla car
//
//  Created by Sergey Kopytov on 04.07.2017.
//  Copyright © 2017 AVSI. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import JVFloatLabeledTextField

class TaxiViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    private let pickerNames: [String] = ["Работа → Московские ворота", "Работа → Обводный канал", "Московские ворота → Работа", "Обводный канал → Работа", "Вручную"]
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var fromMarker: GMSMarker?
    private var toMarker: GMSMarker?
    private var isFrom: Bool = true
    private let companyMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 59.9364316, longitude: 30.315622500000018))
    private let mskMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 59.89138579999999, longitude: 30.318388200000072))
    private let obvMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 59.9141291, longitude: 30.329411599999958))
    private var companyPlace: GMSPlace!
    private var mskPlace: GMSPlace!
    private var obvPlace: GMSPlace!
    private var fromPlace: GMSPlace!
    private var toPlace: GMSPlace!
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var getTaxiButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var commentsField: JVFloatLabeledTextView!
    
    @IBOutlet weak var fromWorkButton: UIButton!
    @IBOutlet weak var fromMskButton: UIButton!
    @IBOutlet weak var fromObvButton: UIButton!
    @IBOutlet weak var toWorkButton: UIButton!
    @IBOutlet weak var toMskButton: UIButton!
    @IBOutlet weak var toObvButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setBounds()
        self.setLocation()
    }
    
    private func setBounds(){
        self.getTaxiButton.layer.cornerRadius = self.getTaxiButton.frame.size.width / 16
        self.getTaxiButton.clipsToBounds = true
        self.googleMap.layer.cornerRadius = self.googleMap.frame.size.width / 20
        self.googleMap.clipsToBounds = true
    }
    
    private func setLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        }
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        initGoogleMaps()
        let client = GMSPlacesClient()
        client.lookUpPlaceID("ChIJH9V0um4wlkYR2Mqk2QBGZKo", callback: {(place, error) -> Void in
            self.mskPlace = place
        })
        client.lookUpPlaceID("ChIJVVOrl0wwlkYRbAQ6PzPE2GY", callback: {(place, error) -> Void in
            self.obvPlace = place
        })
        client.lookUpPlaceID("ChIJ9V04txoxlkYRtCvfEq3Ftl4", callback: {(place, error) -> Void in
            self.companyPlace = place
        })
    }
    
    private func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.googleMap.camera = camera
        self.googleMap.delegate = self
        self.googleMap.isMyLocationEnabled = true
        self.googleMap.settings.myLocationButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error while get location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.googleMap.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMap.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMap.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.googleMap.camera = camera
        self.dismiss(animated: true, completion: nil)
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if isFrom{
            fromMarker?.map = nil
            fromMarker = GMSMarker(position: position)
            fromMarker!.title = place.name
            fromMarker!.map = googleMap
            self.fromPlace = place
            self.fromButton.titleLabel?.text = self.fromPlace.name
        } else {
            toMarker?.map = nil
            toMarker = GMSMarker(position: position)
            toMarker!.title = place.name
            toMarker!.map = googleMap
            self.toPlace = place
            self.toButton.titleLabel?.text = self.fromPlace.name
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fromButtonPressed(_ sender: Any) {
        self.isFrom = true
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func toButtonPressed(_ sender: Any) {
        self.isFrom = false
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func fromWorkPressed(_ sender: Any) {
        fromMarker?.map = nil
        fromMarker = companyMarker
        fromMarker!.title = "Работа"
        fromMarker!.map = googleMap
        self.fromPlace = companyPlace
        self.fromButton.titleLabel?.text = self.fromPlace.name
    }
    @IBAction func fromMskPressed(_ sender: Any) {
        fromMarker?.map = nil
        fromMarker = mskMarker
        fromMarker!.title = "Московские ворота"
        fromMarker!.map = googleMap
        self.fromPlace = mskPlace
        self.fromButton.titleLabel?.text = self.fromPlace.name
    }
    @IBAction func fromObvPressed(_ sender: Any) {
        fromMarker?.map = nil
        fromMarker = obvMarker
        fromMarker!.title = "Обводный канал"
        fromMarker!.map = googleMap
        self.fromPlace = obvPlace
        self.fromButton.titleLabel?.text = self.fromPlace.name
    }
    @IBAction func toWorkPressed(_ sender: Any) {
        toMarker?.map = nil
        toMarker = companyMarker
        toMarker!.title = "Работа"
        toMarker!.map = googleMap
        self.toPlace = companyPlace
        self.toButton.titleLabel?.text = self.toPlace.name
    }
    @IBAction func toMskPressed(_ sender: Any) {
        toMarker?.map = nil
        toMarker = mskMarker
        toMarker!.title = "Московские ворота"
        toMarker!.map = googleMap
        self.toPlace = mskPlace
        self.toButton.titleLabel?.text = self.toPlace.name
    }
    @IBAction func toObvPressed(_ sender: Any) {
        toMarker?.map = nil
        toMarker = obvMarker
        toMarker!.title = "Обводный канал"
        toMarker!.map = googleMap
        self.toPlace = obvPlace
        self.toButton.titleLabel?.text = self.toPlace.name
    }
    
    
    
    @IBAction func timePressed(_ sender: Any) {
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! FromViewController
        destinationController.googleApi = googleApi
        let dest = segue.destination as! ToViewController
        dest.googleApi = googleApi
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
