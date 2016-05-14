//
//  DailyWeather.swift
//  Weather Outside
//
//  Created by Sofia  Cepeda
//  
//

import Foundation
import UIKit

struct DailyWeather {
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let humidity: Int?
    let precipChance: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named: "deafult.png")
    var largeIcon: UIImage? = UIImage(named: "default_large.png")
    var sunriseTime: String?
    var sunsetTime: String?
    var day: String?
    let dateFormatter = NSDateFormatter()
    
    
        init(dailyWeatherDict: [String:AnyObject]) {
            maxTemperature = dailyWeatherDict["temperatureMax"] as? Int
            minTemperature = dailyWeatherDict["temperatureMin"] as? Int
            if let humidityFloat = dailyWeatherDict ["humidity"] as? Double {
                humidity = Int(humidityFloat * 100)
            } else {
                humidity = nil
            }
            if let precipChanceFloat = dailyWeatherDict["precipProbability"] as? Double {
                precipChance = Int(precipChanceFloat * 100)
            } else {
                precipChance = nil
            }
            summary = dailyWeatherDict["summary"] as? String
            if let iconString = dailyWeatherDict["icon"] as? String,
                let iconEnum = Icon(rawValue: iconString) {
                (icon, largeIcon) = iconEnum.toImage()
            }
            if let sunriseDate = dailyWeatherDict["sunriseTime"] as? Double {
                sunriseTime = timeString(sunriseDate)
            } else {
                sunriseTime = nil
            }
            if let sunsetDate = dailyWeatherDict["sunsetTime"] as? Double {
                sunsetTime = timeString(sunsetDate)
            } else {
                sunsetTime = nil
            }
            if let time = dailyWeatherDict["time"] as? Double {
                day = dayStringFromTime(time)
            }

        }
    // Gets time, Unix time is defined as seconds since 1970
    func timeString(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        //Returns date formatted as 12 hour time, a shows am or pm after time
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
        }
    
    // Gets date from Forecast.io using Unix time
    func dayStringFromTime(time: Double) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        // ask iphone for current location to set date of week to same format
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    }

