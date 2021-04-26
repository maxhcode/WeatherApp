//
//  MainView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI

struct MainView: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
        }
    var body: some View {
        
        TabView {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel2(weatherService: weatherService)
            WeatherView(viewModel: WeatherViewModel2(weatherService: WeatherService()))
                .tabItem {
                    Label("Weather", systemImage: "triangle.circle")
                }
            
            SearchWeatherView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            ListView()
                .tabItem {
                    Label("List", systemImage: "book.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
