//
//  MapViewController.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Public API
    
    var locations = [String]() {
        didSet {
            if mapView != nil {
                mapView.removeAnnotations(mapView.annotations)
            }
            updateMap()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - UI
    
    private func updateMap() {
        for address in locations {
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = address
            // request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler {
                [ weak weakSelf = self ] (response, error) -> Void in
                if error == nil && response != nil {
                    var pins = [MapPin]()
                    for item in response!.mapItems {
                        let pin = MapPin(coordinate: item.placemark.coordinate)
                        self.mapView.addAnnotation(pin)
                        pins.append(pin)
                    }
                    weakSelf?.mapView.showAnnotations(pins, animated: false)
                }
            }
        }
        
    }
    
}