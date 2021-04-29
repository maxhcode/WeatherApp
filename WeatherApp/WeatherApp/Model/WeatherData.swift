//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import Foundation


struct ApiResponse: Decodable{
    let name: String
    let main: ApiResponseMain
    let weather: [ApiResponseWeather]
}

struct ApiResponseMain: Decodable{
    let temp: Double
}

struct ApiResponseWeather: Decodable{
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

public struct Weather{
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: ApiResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}
