import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double?
    let temp_max: Double?
}

struct Weather: Decodable {
    let description: String
}
