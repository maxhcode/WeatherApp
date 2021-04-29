//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @StateObject var vm: WeatherViewModel
    @ObservedObject var locationManager = LocationService()

    var country: String { ("\(locationManager.locationInformation?.country ?? "---")") }
    var city: String { ("\(locationManager.locationInformation?.locality ?? "---")") }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.flatDarkBackground.ignoresSafeArea()
                VStack(spacing: 50){
                    VStack(spacing: 10){
                        Text("County: \(country)")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                        Text("City: \(city)")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                    }
                    HStack{
                        Text(vm.weatherDescription)
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                    HStack(spacing: 70){
                        VStack{
                        Text("\(vm.temperature)")
                            .font(.system(size: 60))
                            .bold()
                        }
                        Image(systemName: vm.weatherIcon)
                            .foregroundColor(.white)
                            .font(.system(size: 80))
                    }
                    HStack(spacing: 30){
                        ProgressView("Incidence Value", value: vm.circleValue, total: 100)
                            .progressViewStyle(IncidenceProgressBarCircled(circleColor: vm.colorCircle))
                            .onReceive(vm.timer) { _ in
                                vm.requestWeather(city: city)
                                vm.circleColorChange()
                                vm.animationForCircle()
                            }
                    }
                }
            }
                .onAppear{
                    vm.refresh()
                    locationManager.updateLocation()
                }
            .navigationBarTitle("Current  Weather")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        vm.requestWeather(city: city)
                                        locationManager.updateLocation()
                                    }) {
                                        Image(systemName: "location")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                    }
            )
            .foregroundColor(.white)
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(vm: WeatherViewModel(weatherService: WeatherService()))
    }
}

struct IncidenceProgressBarCircled : ProgressViewStyle {
    
    var circleColor: Color
    
    func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        VStack(spacing: 25) {
            configuration.label
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(Color.white)
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.white.opacity(0.5))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                
                Text("\(Int((configuration.fractionCompleted ?? 0) * 100))(In.)")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        } .frame(width: 200, height: 150, alignment: .center)
        .padding()
    }
}
