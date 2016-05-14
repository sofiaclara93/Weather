//
//  WeeklyTableViewController.swift
//  Weather Outside
//
//  Created by Sofia Cepeda
//
// "https://github.com/WERUreo?tab=repositories" helped lear API 
//

import UIKit
import CoreLocation

class WeeklyTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    @IBOutlet weak var currentLocationLabel: UILabel?
    
    var locationManager = CLLocationManager()
    
    // Location coordinates
    var coordinate: (latitude: Double, longitude : Double) = (37.8267,-122.423)
    
    var weeklyWeather: [DailyWeather] = []
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Asks for permission to have user location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        configureView()
        retrieveWeatherForecast()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        // Set table view's background view property
        tableView.backgroundView = BackgroundView()
        
        // Set custom height for table view row
        tableView.rowHeight = 64
        
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        // Add refresh above the background 
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
    }

    @IBAction func refreshWeather() {
        retrieveWeatherForecast()
        refreshControl?.endRefreshing()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    func getAPIKey() -> String?
    {
        var keys: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("APIKey", ofType: "plist")
        {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys
        {
            let apiKey = dict["forecastAPIKey"] as? String
            return apiKey
        }
        
        return nil
    }
    
    //Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDaily" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
            }
        }
    }


    //Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return weeklyWeather.count
    }
    
    // Creates header over weekly forecast
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }
    
    // Creates a new cell for each instance of a day
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        
        return cell
    }
    
    // Delgate Methods
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 229/255.0, green: 155/255.0, blue: 182/255.0, alpha: 1.0)
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel!.textColor = UIColor.whiteColor()
        }
    }
        override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.contentView.backgroundColor = UIColor(red: 229/255.0, green: 155/255.0, blue: 182/255.0, alpha: 1.0)
            let highlightView = UIView()
            highlightView.backgroundColor = UIColor(red: 229/255.0, green: 155/255.0, blue: 182/255.0, alpha: 1.0)
            cell?.selectedBackgroundView = highlightView
        }
    
    //Weather Fetching
    
    func retrieveWeatherForecast()
    {
        guard let apiKey = getAPIKey() else
        {
            fatalError("Could not find an API key.  Make sure you have an APIKey.plist file that contains your API key")
        }
        
        let forecastService = ForecastService(APIKey: apiKey)
        forecastService.getForecast(coordinate.latitude, longitude: coordinate.longitude) {
            (let forecast) -> Void in
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather
            {
                // update UI
                dispatch_async(dispatch_get_main_queue()) {
                    // Execute closure
                    if let temperature = currentWeather.temperature
                    {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    if let precipitation = currentWeather.precipProbability
                    {
                        self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                    }
                    if let icon = currentWeather.icon
                    {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    self.weeklyWeather = weatherForecast.weekly
                    
                    if let highTemp = self.weeklyWeather.first?.maxTemperature,
                        let lowTemp = self.weeklyWeather.first?.minTemperature
                    {
                        self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                    }

                    
                    self.tableView.reloadData()
                }
            }
        }
    }



//Location

func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
{
    var placemark: CLPlacemark!
    locationManager.stopUpdatingLocation()
    
    if let currentLocation = manager.location
    {
        coordinate.latitude = currentLocation.coordinate.latitude
        coordinate.longitude = currentLocation.coordinate.longitude
        
        retrieveWeatherForecast()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            if error == nil && placemarks!.count > 0
            {
                placemark = placemarks![0] as CLPlacemark
                let locationName = "\(placemark.locality!), \(placemark.administrativeArea!)"
                self.currentLocationLabel?.text = locationName
            }
        }
    }
}


func displayLocationInfo(placemark: CLPlacemark)
{
    locationManager.stopUpdatingLocation()
    }
}


