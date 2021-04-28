//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 25.04.21.
//

import Foundation

public class WeatherService: NSObject {
    
    private let API_KEY = "291d66446cec9ca2f0b770a285ded58d"
    private let unit = "metric"
    private var completionHandler: ((Weather) -> Void)?
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather)) -> Void){
        self.completionHandler = completionHandler
    }
    
    public func makeApiRequest(city: String) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?&q=\(city)&appid=\(API_KEY)&units=\(unit)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(ApiResponse.self, from: data){
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService {
    public func locationManager(){
        makeApiRequest(city: "Berlin")
    }
}
