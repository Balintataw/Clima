import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let baseApiUrl = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=\(Secrets().apiKey)"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let replaced = cityName.replacingOccurrences(of: " ", with: "")
        let url = "\(baseApiUrl)&q=\(replaced)"
        performRequest(with: url)
    }
    
    func fetchLocalWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let url = "\(baseApiUrl)&lat=\(lat)&lon=\(lon)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let jsonResponse = try decoder.decode(WeatherData.self, from: weatherData)
            let id = jsonResponse.weather[0].id
            let temp = jsonResponse.main.temp
            let city = jsonResponse.name
            
            let weather = WeatherModel(conditionId: id, cityName: city, temp: temp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
