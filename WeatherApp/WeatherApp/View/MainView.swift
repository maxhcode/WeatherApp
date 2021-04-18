//
//  MainView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        TabView {
            WeatherView(text: .constant(""))
                .tabItem {
                    Label("Weather", systemImage: "triangle.circle")
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
