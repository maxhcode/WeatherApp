//
//  Test.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 19.04.21.
//

import SwiftUI
import Foundation
import Combine
import CoreLocation
//I finished the location view just need to udnerstand it
//And Review it Link: https://adrianhall.github.io/swift/2019/11/05/swiftui-location/

//https://stackoverflow.com/questions/47835946/the-apps-info-plist-must-contain-an-nslocationwheninuseusagedescription-key-wit

struct ContentView: View {
    @ObservedObject var lm = LocationManager()

    var someVar: String  { return("\(lm.someVar ?? 0)") }

    var body: some View {
        VStack {
            Text("someVar: \(self.someVar)")
            Button(action: { self.lm.someVar = self.lm.someVar + 2 }) {
              Text("Add more")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
}

class LocationManager: NSObject, ObservableObject {
private let geocoder = CLGeocoder()
  private let locationManager = CLLocationManager()
  let objectWillChange = PassthroughSubject<Void, Never>()

      @Published var someVar: Int = 0 {
        willSet { objectWillChange.send() }
      }

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
    self.locationManager.startUpdatingLocation()
  }

    @Published var placemark: CLPlacemark? {
       willSet { objectWillChange.send() }
     }

     private func geocode() {
       guard let location = self.location else { return }
       geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
         if error == nil {
           self.placemark = places?[0]
         } else {
           self.placemark = nil
         }
       })
     }
}

struct CityListScene: View {
    @ObservedObject var lm = LocationManager()

    var latitude: String  { return("\(lm.location?.latitude ?? 0)") }
    var longitude: String { return("\(lm.location?.longitude ?? 0)") }
    var placemark: String { return("\(lm.placemark?.description ?? "XXX")") }
    var status: String    { return("\(lm.status)") }

    var body: some View {
        VStack {
            Text("Latitude: \(self.latitude)")
            Text("Longitude: \(self.longitude)")
            Text("Placemark: \(self.placemark)")
            Text("Status: \(self.status)")
        }
    }
}

struct CityListScene_Previews: PreviewProvider {
    static var previews: some View {
        CityListScene()
    }
}

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
