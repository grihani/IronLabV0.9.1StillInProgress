//
//  MapForMeetingsOfDayViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 03/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import MapKit


class MapForMeetingsOfDayViewController: UIViewController {

    var date: NSDate!
    var address: String!
    var account: AccountsModel!
    
    let MINIMUM_ZOOM_ARC: CLLocationDegrees = 0.014
    let ANNOTATION_REGION_PAD_FACTOR: CLLocationDegrees = 1.45
    let MAX_DEGREES_ARC: CLLocationDegrees = 360
    
    @IBOutlet var addressesMapView: MKMapView! {
        didSet {
            addressesMapView.delegate = self
        }
    }
    
    var didRenderMapViewFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var locations: [MKPointAnnotation] = []
        let meetingsOfDay = DetailsOfAccountAPI.sharedInstance.getMeetingsAndAccountsOfDay(date)
        for meetingAndAccount in meetingsOfDay {
            geolocalise(account: meetingAndAccount.account, meeting: meetingAndAccount.meeting, mapView: addressesMapView)
        }
        if address != "" {
            geolocalise(address, account: account , mapView: addressesMapView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func geolocalise (#account: AccountsModel, meeting: MeetingsModel, mapView: MKMapView){
        
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(meeting.adressMeeting, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location.coordinate
                annotation.title = account.nameAccount
                let dateFormatter = NSDateFormatter()
                annotation.subtitle = getDate(meeting.dateBeginMeeting) + " to " + getDate(meeting.dateEndMeeting)
                mapView.addAnnotation(annotation)
//                mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    
    func geolocalise (address: String , account: AccountsModel, mapView: MKMapView){
        
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location.coordinate
                annotation.title = account.nameAccount
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .ShortStyle
                annotation.subtitle = dateFormatter.stringFromDate(self.date)
                mapView.addAnnotation(annotation)
                mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapForMeetingsOfDayViewController: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        
        if !didRenderMapViewFirstTime {
            
            
            didRenderMapViewFirstTime = true
        }
    }
    
    
    
    
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