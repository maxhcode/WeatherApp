//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 19.04.21.
//

import Foundation
import MapKit
//
//class LocationManager2: NSObject, CLLocationManagerDelegate{
//    private let locationManager = CLLocationManager()
//    var location: CLLocation? = nil
//
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.distanceFilter = kCLDistanceFilterNone
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//    }
//
//
//}
//
//extension LocationManager2: CLLocationManagerDelegate{
//
//    func locationManager2(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        guard let location = locations.last else{
//            return
//        }
//        self.location = location
//    }
//
//}
