//
//  MapTableViewCell.swift
//  Foodie
//
//  Created by Chuiwen Ma on 12/5/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var address: String? {
        didSet {
            if mapView != nil {
                mapView.removeAnnotations(mapView.annotations)
            }
            updateMap()
        }
    }
    
    // MARK: Private Implementation
    
    @IBOutlet private weak var mapView: MKMapView!
    
    private func updateMap() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { [ weak weakSelf = self ] (response, error) -> Void in
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
