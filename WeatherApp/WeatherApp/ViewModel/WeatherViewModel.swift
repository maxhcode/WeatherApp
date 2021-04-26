//
//  WeatheerViewModel.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 25.04.21.
//

import Foundation
import SwiftUI


private let defaultIcon = "?"
private let iconMap = [
    "Drizzle": "cloud.drizzle.fill",
    "Thunderstorm": "cloud.bolt.fill",
    "Rain": "cloud.rain.fill",
    "Snow": "cloud.snow.fill",
    "Clear": "sun.max.fill",
    "Clouds": "cloud.fill",
]

public class WeatherViewModel2: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService){
        self.weatherService = weatherService
        //self.weatherService.makeDataRequest(City: "Hamburg")
    }
    
    func requestWeather(City: String){
        weatherService.makeDataRequest(City: City)
    }
    
    public func refresh(){
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
    
}

class WeatherViewModel: ObservableObject{
    @Published var circleValue = 10.0
    @Published var colorCircle = Color.green
    

    func animationForCircle(){
        if circleValue < 100 {
            circleValue += 2
        }
    }
    
    func circleColorChange(){
        if circleValue == 10{
            colorCircle = .green
        }
        if circleValue == 20{
            colorCircle = .green
        }
        if circleValue == 30{
            colorCircle = .green
        }
        if circleValue == 40{
            colorCircle = .yellow
        }
        if circleValue == 50{
            colorCircle = .yellow
        }
        if circleValue == 60{
            colorCircle = .orange
        }
        if circleValue == 70{
            colorCircle = .orange
        }
        if circleValue == 80{
            colorCircle = .red
        }
        if circleValue == 90{
            colorCircle = .red
        }
        if circleValue == 100{
            colorCircle = .red
        }
    }
}


//    @EnvironmentObject var learningQuizViewModel: LearningQuizViewModel
//
//    @StateObject var learningViewModel = LearningViewModel()
//        .environmentObject(learningViewModel)
//
//    struct LearningView_Previews: PreviewProvider {
//        static var previews: some View {
//            LearningView(learningViewModel: LearningViewModel())
//        }
//    }

