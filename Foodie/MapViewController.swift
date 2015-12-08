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
    
    var locations = [MKAnnotation]() {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(locations)
        }
    }

    @IBOutlet weak var mapView: MKMapView!

}
