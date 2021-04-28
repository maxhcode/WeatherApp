//
//  ListViewModel.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 28.04.21.
//

import Foundation


class ListViewModel: ObservableObject{
    @Published var weatherList = ["Munich", "Berlin", "Paris", "Hamburg"]
    @Published var weatherViewModel = WeatherViewModel(weatherService: WeatherService())
    
//    func refreshBoxes() {
//        for i in weatherList{
//            weatherViewModel.requestWeather(city: i)
//        }
//    }
    
}
