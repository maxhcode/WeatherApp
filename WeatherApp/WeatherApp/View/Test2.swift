import SwiftUI
import CoreLocation

struct WeatherView2: View {
    
    @ObservedObject var viewModel: WeatherViewModel2
    
    var body: some View{
        VStack{
            Text(viewModel.cityName).font(.largeTitle)
                .padding()
            Text(viewModel.temperature)
                .font(.system(size: 70))
                .bold()
            Text(viewModel.weatherIcon)
                .font(.largeTitle)
                .padding()
            Text(viewModel.weatherDescription)
            
        }.onAppear(perform:viewModel.refresh)
    }
}

struct WeatherView2_Previews: PreviewProvider {
    static var previews: some View{
        WeatherView2(viewModel: WeatherViewModel2(weatherService: WeatherService()))
    }
}
