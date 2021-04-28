//
//  SearchWeatherViewModel.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 25.04.21.
//

import Foundation



class SearchWeatherViewModel: ObservableObject{
    @Published var input: String = ""
   // @Published var weatherList = ["Munich"]
    @Published var array = []
    
    
}


class ListViewModel: ObservableObject{
    @Published var weatherList = ["Munich"]
}
