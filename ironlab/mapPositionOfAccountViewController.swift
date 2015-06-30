//
//  mapPositionOfAccountViewController.swift
//  IronLab
//
//  Created by CSC CSC on 10/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit
import MapKit

class mapPositionOfAccountViewController: UIViewController {
    
    var account: AccountsModel!

    let MINIMUM_ZOOM_ARC: CLLocationDegrees = 0.014
    let ANNOTATION_REGION_PAD_FACTOR: CLLocationDegrees = 1.45
    let MAX_DEGREES_ARC: CLLocationDegrees = 360
    
    @IBOutlet var addressesMapView: MKMapView! {
        didSet {
            addressesMapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geolocalise(account: account, mapView: addressesMapView)
        // Do any additional setup after loading the view.
    }
    
    func geolocalise (#account: AccountsModel, mapView: MKMapView){
        
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(account.adressAccount, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location.coordinate
                annotation.title = account.nameAccount
                annotation.subtitle = account.phoneAccount
                mapView.addAnnotation(annotation)
                mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension mapPositionOfAccountViewController: MKMapViewDelegate {
    
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