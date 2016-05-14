//
//  ForecastService.swift
//  Weather Outside
//
//  Created by Sofia  Cepeda
//
//
import Foundation



public class ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    public init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(latitude: Double, longitude: Double, completion: (Forecast? -> Void)) {
        
        if let forecastURL = NSURL(string: "\(latitude),\(longitude)", relativeToURL: forecastBaseURL) {
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                // Pass value to callback
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }

    
}
