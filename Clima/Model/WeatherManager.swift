import Foundation

struct WeatherManager {
    let baseApiUrl = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=\(Secrets().apiKey)"
    
    func fetchWeather(cityName: String) {
        let replaced = cityName.replacingOccurrences(of: " ", with: "")
        let url = "\(baseApiUrl)&q=\(replaced)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let jsonResponse = try decoder.decode(WeatherData.self, from: weatherData)
            print(jsonResponse)
        } catch {
            print(error)
        }
    }
}
