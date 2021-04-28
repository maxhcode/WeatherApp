//
//  ListView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI


struct ListView: View {
    init() {UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]}
    
    @EnvironmentObject var searchWeatherViewModel: SearchWeatherViewModel
    
    @StateObject var listViewModel = ListViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.flatDarkBackground.ignoresSafeArea()
                VStack{
                    ScrollView{
                        if listViewModel.weatherList.isEmpty == false{
                            ForEach(listViewModel.weatherList, id: \.self) { city in
                                Box(city: city as! String , viewModel: WeatherViewModel2(weatherService: WeatherService()))
                            }
                        }
                        
                        Box(city: "Berlin", viewModel: WeatherViewModel2(weatherService: WeatherService()))
                        Box(city: "Paris", viewModel: WeatherViewModel2(weatherService: WeatherService()))
                        Box(city: "Hamburg", viewModel: WeatherViewModel2(weatherService: WeatherService()))
                    }
                }
            }.navigationBarTitle(Text("Weather List"))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        //Refresh
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(.white)
                                            .font(.system(size: 25))
                                    }
            )
            
        }.environmentObject(listViewModel)
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
    
    @ObservedObject var viewModel: WeatherViewModel2
    
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
                        viewModel.requestWeather(City: city)
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
                            CirclerPercentageProgressViewStyle2(circleColor: colorCircle))
                }
                
                
            }
            
        }.frame(width: 380, height: 100, alignment: .center)
        .background(Color.flatDarkCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct CirclerPercentageProgressViewStyle2 : ProgressViewStyle {
    
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



//
//struct Box_Previews: PreviewProvider {
//    static var previews: some View {
//        Box(country: "Germany", city: "Berlin", temperature: 10)
//    }
//}



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
