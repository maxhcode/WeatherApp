//
//  ListView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI


struct ListView: View {
    init() {UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]}
    
    @ObservedObject var weatherViewModel = WeatherViewModel(weatherService: WeatherService())
    @EnvironmentObject var searchWeatherViewModel: SearchWeatherViewModel
    @StateObject var vm = ListViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.flatDarkBackground.ignoresSafeArea()
                VStack{
                    ScrollView{
                        ForEach(vm.weatherList, id: \.self) { city in
                            Box(city: city, viewModel: WeatherViewModel(weatherService: WeatherService()))
                        }
                    }
                }
            }.navigationBarTitle(Text("Weather List"))
            .navigationBarItems(trailing:
                                    Button(action: {
//                                        vm.refreshBoxes()
//                                        for i in vm.weatherList{
//                                            weatherViewModel.requestWeather(city: i)
//                                        }
//                                        weatherViewModel.refresh()
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                    }
            )
            
        }.environmentObject(vm)
    }
}



struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

struct Box: View{
    
    var city: String
    var temperature = "--"
    @State public var circleValue = 10.0
    @State var colorCircle = Color.green
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ZStack{
            HStack(spacing: 20){
                
                HStack(){
                    Text(city)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    HStack {
                        Text("\(viewModel.temperature)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                    }.onAppear{
                        viewModel.requestWeather(city: city)
                        viewModel.refresh()
                    }
                }.frame(width: 70, height: 70, alignment: .center)
                
                
                HStack(spacing: 10) {
                    VStack{
                        Text("Incidence")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Text("Value")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    }
                    ProgressView("Incidence Value", value: circleValue, total: 100)
                        .progressViewStyle(
                            BoxProgressBarCircled(circleColor: colorCircle))
                }
                
                
            }
            
        }.frame(width: 380, height: 100, alignment: .center)
        .background(Color.flatDarkCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct BoxProgressBarCircled : ProgressViewStyle {
    
    var circleColor: Color
    
    func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 8.0)
                    .opacity(0.3)
                    .foregroundColor(Color.accentColor.opacity(0.5))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                
                Text("\(Int((configuration.fractionCompleted ?? 0) * 100))%")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        } .frame(width: 70, height: 70, alignment: .center)
        .padding()
    }
}



