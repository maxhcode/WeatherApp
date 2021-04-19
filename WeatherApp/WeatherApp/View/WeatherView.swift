//
//  ContentView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine

struct WeatherView: View {
    @State public var circleValue = 10.0
    @State var colorCircle = Color.green
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    init() {UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]}
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.flatDarkBackground.ignoresSafeArea()
                VStack(spacing: 50){
                    HStack(spacing: 10){
                        Text("County")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                        Text("City")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                    }
                    HStack{
                        Text("Cloudy")
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                    HStack{
                        Image(systemName: "cloud.sun.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 80))
                    }
                    HStack(spacing: 30){
                        ProgressView("Incidence Value", value: circleValue, total: 100)
                            .progressViewStyle(CirclerPercentageProgressViewStyle(circleColor: colorCircle))
                            .onReceive(timer) { _ in
                                circleColorChange()
                                if circleValue < 100 {circleValue += 2
                                }
                            }
                    }
                }
            }.navigationBarTitle("Current  Weather")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        print("This should be the location")
                                    }) {
                                        Image(systemName: "location")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                    }
            )
            .foregroundColor(.white)
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

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

struct CirclerPercentageProgressViewStyle : ProgressViewStyle {
    
    var circleColor: Color
    
    func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        VStack(spacing: 25) {
            configuration.label
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(Color.white)
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.white.opacity(0.5))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                
                Text("\(Int((configuration.fractionCompleted ?? 0) * 100))%")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        } .frame(width: 200, height: 150, alignment: .center)
        .padding()
    }
}
