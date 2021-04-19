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
            WeatherView(searchText: .constant(""))
                .tabItem {
                    Label("Weather", systemImage: "triangle.circle")
                }
            
            WeatherView2()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            ListView(searchText: .constant(""))
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
