//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abdulsamet Bakmaz on 5.10.2022.
//

import UIKit
import MarqueeLabel

class ViewController: UIViewController{
    
    var cityName = String()
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var humidtyLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var feelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let cityName = cityNameTextField.text ?? ""
        if cityName.isEmpty {
            
            let alert = UIAlertController(title: "UYARI!", message: "Lütfen şehir adı giriniz.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }else{
            cityNameTextField.text = cityName
            getWeatherResult(city: cityName)
        }
    }
    func getWeatherResult(city : String) {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=a19544b852d9e7ce370ddad18581222a") {
                   
                   let request = URLRequest(url: url)
                   
                   let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                       
                       if error == nil {
                           
                           if let incomingData = data {
                               
                               do {
                                   
                                   let json = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                   
                                   print(json)
                                                    
                                   if let main = json["main"] as? NSDictionary {
                                       
                                       if let temp = main["temp"] as? Double {
                                           let state = Int(temp - 273.15)
                                           DispatchQueue.main.sync {
                                               self.cityNameLabel.text = city.uppercased()
                                               self.tempLabel.text = String(state)
                                           }
                                       }
                                       if let feel = main["feels_like"] as? Double {
                                           let state = Int(feel - 273.15)
                                           DispatchQueue.main.sync {
                                               self.feelLabel.text = String(state)
                                           }
                                       }
                                       if let maxTemp = main["temp_max"] as? Double {
                                           let state = Int(maxTemp - 273.15)
                                           DispatchQueue.main.sync {
                                               self.maxTempLabel.text = String(state)
                                           }
                                       }
                                       if let minTemp = main["temp_min"] as? Double {
                                           let state = Int(minTemp - 273.15)
                                           DispatchQueue.main.sync {
                                               self.minTempLabel.text = String(state)
                                           }
                                       }
                                       if let humidity = main["humidity"] as? Int {
                                           DispatchQueue.main.sync {
                                               self.humidtyLabel.text = String(humidity)
                                           }
                                       }
                                   }
                                   if let wind = json["wind"] as? NSDictionary {
                                       if let windInfo = wind["speed"] as? Double {
                                           DispatchQueue.main.sync {
                                               self.windLabel.text = String(format:"%.2f",windInfo*1.85)
                                           }
                                       }
                                   }
                                   if let sys = json["sys"] as? NSDictionary {
                                       if let country = sys["country"] as? String {
                                           DispatchQueue.main.sync {
                                               self.countryLabel.text = "(" + country + ")"
                                           }
                                       }
                                   }
                                }catch{
                                   print("bir hata oluştu.")
                               }
                           }
                        }
                   }
            task.resume()
        }
    }
}
