//
//  ContentView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI

struct WeatherView: View {
    @Binding var searchText: String
    var body: some View {
        NavigationView{
            ZStack{
            Color.flatDarkBackground.ignoresSafeArea()
            SearchBar(text: $searchText)
                .padding(.top)
                }
            }.navigationBarTitle("Navigation")
        }
        
    }


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(searchText: .constant(""))
    }
}
