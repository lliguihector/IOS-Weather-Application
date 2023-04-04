//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Hector Lliguichuzca on 3/31/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherManagerDelegate{

    
    
  //OUTLETS
    @IBOutlet weak var citiNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
     
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°F"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.citiNameLabel.text = weather.cityName
            self.descriptionLabel.text = weather.description
        }
      
        
        
        
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    


}


//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            weatherManager.fetchWeather(latitude: lat, longitute: lon)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
