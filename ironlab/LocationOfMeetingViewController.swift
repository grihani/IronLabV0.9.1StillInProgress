//
//  LocationOfMeetingViewController.swift
//  ironlab
//
//  Created by CSC CSC on 28/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationOfMeetingViewController: UIViewController {
    
    let MINIMUM_ZOOM_ARC: CLLocationDegrees = 0.014
    let ANNOTATION_REGION_PAD_FACTOR: CLLocationDegrees = 1.45
    let MAX_DEGREES_ARC: CLLocationDegrees = 360
    
    
    @IBOutlet weak var locationMapView: MKMapView!
    var meeting: MeetingsModel!
    let mapManager = MapManager()
    var locationManager: CLLocationManager!
    var locationStatus : NSString = "Not Started"
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        locationMapView.delegate = self
        geolocalise(meeting: meeting, mapView: locationMapView)
        println(meeting.adressMeeting)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //        locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
    }
    
    func geolocalise (#meeting: MeetingsModel, mapView: MKMapView){
        
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(meeting.adressMeeting, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location.coordinate
                annotation.title = meeting.adressMeeting
                annotation.subtitle = meeting.dateBeginMeeting
                mapView.addAnnotation(annotation)
                mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    
}

extension LocationOfMeetingViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
//        mapManager.directions(from: newLocation.coordinate, to: meeting.adressMeeting) { (route, directionInformation, boundingRegion, error) -> () in
//            if (error != nil) {
//                
//                println(error!)
//            }else{
//                
//                if let web = self.locationMapView{
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        
//                        web.addOverlay(route!)
//                        web.setVisibleMapRect(boundingRegion!, animated: true)
//                        
//                    }
//                    
//                }
//            }
//        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
            
//            mapManager.directions(from: coord, to: meeting.adressMeeting) { (route, directionInformation, boundingRegion, error) -> () in
//                if (error != nil) {
//                    
//                    println(error!)
//                }else{
//                    
//                    if let web = self.locationMapView{
//                        
//                        dispatch_async(dispatch_get_main_queue()) {
//                            
//                            web.addOverlay(route!)
//                            web.setVisibleMapRect(boundingRegion!, animated: true)
//                            
//                        }
//                        
//                    }
//                }
//            }
            
        }
    }
}

extension LocationOfMeetingViewController: MKMapViewDelegate {
    
    func zoomMapViewToFitAnnotations(mapView: MKMapView, animated: Bool) {
        let annotations: NSArray = mapView.annotations
        let count = mapView.annotations.count
        if count == 0 {
            return
        }
        var points = UnsafeMutablePointer<MKMapPoint>.alloc(count)
        for i in 0..<count {
            let coordinates: CLLocationCoordinate2D = (annotations.objectAtIndex(i) as! MKAnnotation).coordinate
            points[i] = MKMapPointForCoordinate(coordinates)
        }
        let mapRect = MKPolygon(points: points, count: count).boundingMapRect
        
        var region = MKCoordinateRegionForMapRect(mapRect)
        region.span.latitudeDelta = region.span.latitudeDelta * ANNOTATION_REGION_PAD_FACTOR
        region.span.longitudeDelta = region.span.longitudeDelta * ANNOTATION_REGION_PAD_FACTOR
        
        if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC }
        if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC }
        
        if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC }
        if( region.span.longitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta  = MINIMUM_ZOOM_ARC }
        
        if( count == 1 ) {
            region.span.latitudeDelta = MINIMUM_ZOOM_ARC
            region.span.longitudeDelta = MINIMUM_ZOOM_ARC
        }
        
        mapView.setRegion(region, animated: animated)
        
        points.dealloc(count)
        
        
    }
    
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        zoomMapViewToFitAnnotations(mapView, animated: true)
    }
}
