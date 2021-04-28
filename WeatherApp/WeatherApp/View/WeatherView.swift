//
//  ContentView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject var viewModel: WeatherViewModel
    @ObservedObject var locationManager = LocationManager()

    var country: String { return("\(locationManager.locationInformation?.country ?? "---")") }
    var city: String { return("\(locationManager.locationInformation?.locality ?? "---")") }
    
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
                        ProgressView("Incidence Value", value: viewModel.circleValue, total: 100)
                            .progressViewStyle(CirclerPercentageProgressViewStyle(circleColor: viewModel.colorCircle))
                            .onReceive(viewModel.timer) { _ in
                                viewModel.requestWeather(City: self.city)
                                locationManager.updateLocation()
                                viewModel.circleColorChange()
                                viewModel.animationForCircle()
                            }
                    }
                }
            }
            .onAppear(perform: viewModel.refresh)
            .navigationBarTitle("Current  Weather")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        viewModel.requestWeather(City: self.city)
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

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
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
