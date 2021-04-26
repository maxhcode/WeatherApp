//
//  ContentView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine

struct WeatherView: View {
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    @StateObject var weatherViewModel = WeatherViewModel()
    //@ObservedObject var wm = WeatherManager()

    @ObservedObject var viewModel: WeatherViewModel2
    @ObservedObject var lm = LocationManager()

    var latitude: String  { return("\(lm.location?.latitude ?? 0)") }
    var longitude: String { return("\(lm.location?.longitude ?? 0)") }
    var country: String { return("\(lm.placemark?.country ?? "XXX")") } //.description
    var city: String { return("\(lm.placemark?.locality ?? "XXX")") }
    var status: String    { return("\(lm.status)") }
    
//    init() {
//       // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        //lm.updateLocation()
//    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.flatDarkBackground.ignoresSafeArea()
                VStack(spacing: 50){
                    VStack(spacing: 10){
                        Text("County: \(self.country)")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                        Text("City: \(self.city)")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                    }
                    HStack{
                        Text(viewModel.weatherDescription)
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                    HStack(spacing: 70){
                        VStack{
                        Text("\(viewModel.temperature)")
                            .font(.system(size: 60))
                            .bold()
                        }
                        Image(systemName: viewModel.weatherIcon)
                            .foregroundColor(.white)
                            .font(.system(size: 80))
                    }
                    HStack(spacing: 30){
                        ProgressView("Incidence Value", value: weatherViewModel.circleValue, total: 100)
                            .progressViewStyle(CirclerPercentageProgressViewStyle(circleColor: weatherViewModel.colorCircle))
                            .onReceive(timer) { _ in
                                viewModel.requestWeather(City: self.city)
                                lm.updateLocation()
                                weatherViewModel.circleColorChange()
                                weatherViewModel.animationForCircle()
                            }
                    }
                }
            }
            .onAppear(perform: viewModel.refresh) //NEW
            .navigationBarTitle("Current  Weather")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        //wm.fetchWeather(cityName: self.city)
                                        lm.updateLocation()
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

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel2(weatherService: WeatherService()))
    }
}

struct CirclerPercentageProgressViewStyle : ProgressViewStyle {
    
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
                
                Text("\(Int((configuration.fractionCompleted ?? 0) * 100))%")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        } .frame(width: 200, height: 150, alignment: .center)
        .padding()
    }
}
