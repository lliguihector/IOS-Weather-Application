//
//  WeatherManager.swift
//  SimpleWeather
//
//  Created by Hector Lliguichuzca on 3/31/23.
//

import Foundation
import CoreLocation

//enum APIError{
//
//    case requestFailed
//    case responseFaield
//    case jsonDecodingFailed
//    case jsonEncodingFaield
//    case invalidCoardinates
//    case invalidURLString
//
//}


protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
    
}





//Enums for custome api Error Throw
struct WeatherManager{
    
    
    
    var delegate: WeatherManagerDelegate?
    
    
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees){
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitute)&appid=c559ca70e5146c7481621e1d0a05da20&units=imperial"
        
        performRequest(with: urlString)
    }
    
 
    

       func performRequest(with urlString: String){
           
           //create a url optional binding
           if let url = URL(string: urlString){
               
            //Create a url session
               let session = URLSession(configuration:  .default)
               
               //Give a url session a task dataTask is a method of the urlsession class to perform a network request asynchronously the method takes a completion handler as an argument, which is called when the request completes or fails.
               let task = session.dataTask(with: url){ data, response, error in
                   
                   
                   if error != nil{
                       self.delegate?.didFailWithError(error: error!)
                       return
                   }
                   
                   
                   if let safeData = data{
                       
                       if let weather  = self.parseJSON(safeData){
                           
                           self.delegate?.didUpdateWeather(self, weather: weather)
                       }
//                       let dataString = String(data: safeData, encoding: .utf8)
//                       print(dataString)
                       
                   }
                   
                   
                   
               }
               //Start the task
               task.resume()
           }
          
           
       }
       
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
           let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let desc = decodedData.weather[0].description
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: desc)
            
            return weather
            
        }catch{
            
            
            delegate?.didFailWithError(error: error)
            
            return nil
            
            
        }
    }
    

    
    
}
