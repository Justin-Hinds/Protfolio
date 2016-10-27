//
//  MapViewController.swift
//  Hind_Justin_CE6
//
//  Created by Justin Hinds on 10/14/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, Notation {
    let identifier = "pin"
    var gpsArray = [CLLocationCoordinate2D]()
    var pinArray = [Pin]()
    var titleDetail = [String : String]()
    var titleDetail2 = [String : String]()

    var annotationArray = [MKAnnotation]()
    var mapToggle : Bool?
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBAction func userLocationToggle(_ sender: UIButton) {
        mapView.showsUserLocation = !mapView.showsUserLocation
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func mapTypeSegmentedController(_ sender: UISegmentedControl) {
        //
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDetail2 = [
            "#1" : "Big Kahuna Burger",
            "#2" : "The Double Deuce",
            "#3" :"Blazé",
            "#4" : "Metabbean",
            "#5" : "Coco Bongo",
            "#6" :"Pizza Planet",
            "#7" : "The Max",
            "#8" : "Frosty Palace",
            "#9" : "eCola Inc.",
            "#10" :"Aperature Science Labs"
        ]

        mapView.delegate = self
        mapView.region = MKCoordinateRegionMake( CLLocationCoordinate2D(latitude: 46.6059282, longitude: -120.4466878), MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        let status = CLLocationManager.authorizationStatus()
        locationManager.delegate = self
        //switch for location manager status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if  CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            break
        case .notDetermined:
            //requesting access
            locationManager.requestWhenInUseAuthorization()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - CLLocation
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        view?.animatesDrop = true
        view?.pinTintColor = UIColor.black
        
        return view
    }
    func setAnnotation(pinToggle: Bool) {
        mapToggle = pinToggle
        if pinToggle == false{
            addAnnotations()
        }else{
            mapView.removeAnnotations(annotationArray)
        }
    }
    func addAnnotations(){
        let bigKahunaBurger = CLLocationCoordinate2D(latitude: 46.60547649999999, longitude: -120.48128989999998)
        let doubleDuece = CLLocationCoordinate2D(latitude: 46.5653889, longitude: -120.47947469999997)
        let blaze = CLLocationCoordinate2D(latitude: 46.66274629999999, longitude: -120.52186289999997)
        let metabbean = CLLocationCoordinate2D(latitude: 47.3592088, longitude: -122.1691581)
        let cocoBongo = CLLocationCoordinate2D(latitude: 46.6492221, longitude: -120.53101670000001)
        let pizzaPlanet = CLLocationCoordinate2D(latitude: 46.6511489, longitude: -120.52994899999999)
        let theMax = CLLocationCoordinate2D(latitude: 46.5647981, longitude: -120.48141709999999)
        let frostyPalace = CLLocationCoordinate2D(latitude: 46.6059282, longitude: -120.4466878)
        let eCola = CLLocationCoordinate2D(latitude: 46.621568, longitude: -120.50090499999999)
        let aperature = CLLocationCoordinate2D(latitude: 46.613475, longitude: -120.56044309999999)
        titleDetail = [
            "#1" : "Big Kahuna Burger",
            "#2" : "The Double Deuce",
            "#3" :"Blazé",
            "#4" : "Metabbean",
            "#5" : "Coco Bongo",
            "#6" :"Pizza Planet",
            "#7" : "The Max",
            "#8" : "Frosty Palace",
            "#9" : "eCola Inc.",
            "#10" :"Aperature Science Labs"
        ]
        gpsArray.append(bigKahunaBurger)
        gpsArray.append(doubleDuece)
        gpsArray.append(blaze)
        gpsArray.append(metabbean)
        gpsArray.append(cocoBongo)
        gpsArray.append(pizzaPlanet)
        gpsArray.append(theMax)
        gpsArray.append(frostyPalace)
        gpsArray.append(eCola)
        gpsArray.append(aperature)
        //loops for annotations
        for i in gpsArray{
            let coord = i
            let annotation = MKPointAnnotation()

            for place in titleDetail {
                annotation.coordinate = coord
                annotation.title = place.key
                annotation.subtitle = place.value
                annotationArray.append(annotation)
            }
            mapView.addAnnotation(annotation)

        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView : NewViewController = segue.destination as! NewViewController
        if mapView.showsUserLocation == true{
            detailView.locationTitle = "User Location Displayed"
            

        }else{
            detailView.locationTitle = "No User Location"
        }
        detailView.array = titleDetail2
        print(titleDetail2)
        detailView.delegate = self
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
