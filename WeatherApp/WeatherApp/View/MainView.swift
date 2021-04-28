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
            WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
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


//MARK: - Extensions Colors for the App

extension UIColor {
    
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
}


extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkBackground: Color {
        return Color(decimalRed: 36, green: 36, blue: 36)
    }
    
    public static var flatDarkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
}
