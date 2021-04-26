import SwiftUI
import CoreLocation

public class WeatherService: NSObject, CLLocationManagerDelegate {
    
    //private let locationManager = CLLocationManager()
    private let API_KEY = "291d66446cec9ca2f0b770a285ded58d"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
       // locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather)) -> Void){
        self.completionHandler = completionHandler
       // locationManager.requestWhenInUseAuthorization()
      // locationManager.startUpdatingLocation()
    }
    
    public func makeDataRequest(City: String) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?&q=\(City)&appid=291d66446cec9ca2f0b770a285ded58d&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
    
}

extension WeatherService {
    public func locationManager(){
//        guard let location = locations.first else { return}
        makeDataRequest(City: "Berlin")
    }
//    public func locationManager(
//        _ manager: CLLocationManager,
//        didFailWithError error: Error
//    ){
//        print("Somethign went wrong: \(error.localizedDescription)")
//    }
}

struct APIResponse: Decodable{
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable{
    let temp: Double
}

struct APIWeather: Decodable{
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

public struct Weather{
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}


private let defaultIcon = "?"
private let iconMap = [
    "Drizzle": "sun.max",
    "Thunderstorm": "sun.max",
    "Rain": "sun.max",
    "Snow": "sun.max",
    "Clear": "sun.max",
    "Clouds": "sun.max",
]

public class WeatherViewModel2: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService){
        self.weatherService = weatherService
        self.weatherService.makeDataRequest(City: "Berlin")
    }
    
    public func refresh(){
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
    
}


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
