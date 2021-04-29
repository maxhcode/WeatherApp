//
//  LocationService.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 19.04.21.
//

import Foundation
import Combine
import CoreLocation

class LocationService: NSObject, ObservableObject {
    
  private let geocoder = CLGeocoder()
  private let locationManager = CLLocationManager()
  let objectChanges = PassthroughSubject<Void, Never>()

  @Published var userAuthorizationStatus: CLAuthorizationStatus? {
    willSet { objectChanges.send() }
  }

  @Published var currentLocation: CLLocation? {
    willSet { objectChanges.send() }
  }

  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
  }

    func updateLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    @Published var locationInformation: CLPlacemark? {
       willSet { objectChanges.send() }
     }

     private func geocode() {
       guard let currentLocation = self.currentLocation else { return }

       geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (places, error) in
         if error == nil {
           self.locationInformation = places?[0]
         } else {
           self.locationInformation = nil
         }
       })
     }
}


extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization userAuthorizationStatus: CLAuthorizationStatus) {
        self.userAuthorizationStatus = userAuthorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        self.geocode()
    }
}


