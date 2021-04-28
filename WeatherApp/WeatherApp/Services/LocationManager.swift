//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 19.04.21.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
  private let geocoder = CLGeocoder()
  private let locationManager = CLLocationManager()
  let objectWillChange = PassthroughSubject<Void, Never>()

  @Published var status: CLAuthorizationStatus? {
    willSet { objectWillChange.send() }
  }

  @Published var location: CLLocation? {
    willSet { objectWillChange.send() }
  }

  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
   // self.locationManager.startUpdatingLocation()
  }

    func updateLocation(){
        self.locationManager.startUpdatingLocation()
    }
    
    @Published var locationInformation: CLPlacemark? {
       willSet { objectWillChange.send() }
     }

     private func geocode() {
       guard let location = self.location else { return }
        //The completionHandler is an async return value.
        
       geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
         if error == nil {
           self.locationInformation = places?[0]
         } else {
           self.locationInformation = nil
         }
       })
     }
}


extension LocationManager: CLLocationManagerDelegate {
    //When a location update is recived it will set the location and kick off a geocode of the current location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
}


