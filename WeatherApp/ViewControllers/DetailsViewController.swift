//
//  DetailsViewController.swift
//  WeatherApp
//

import UIKit



class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    var city: City? // Модель города
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
        configureByDay()
    }
    
    // MARK: - Methods
    private func configureView() {
        createLabelForUserActions()
        
        cityNameLabel.text = city?.cityName
        
        if let temp = city?.weatherData?.main.temp {
            let newTempString = String(format: "%.1f", temp)
            temperatureLabel.text = "\(newTempString)º"
        }
        
        // достаем экземпляр структуры WeatherElement
        if city?.weatherData!.weather.indices != nil {
            let weather = city?.weatherData!.weather[0]
            
            weatherDescriptionLabel.text = weather?.weatherDescription
            
            guard let iconFromApi = weather?.icon else { return }
            
            weatherImage.image = UIImage(named: iconFromApi)
        }
    }
    
    // делаем лейбл для подсказок пользователю
    @discardableResult private func createLabelForUserActions() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        label.center = CGPoint(x: view.frame.midX, y: view.frame.maxY - 100)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Halvetica", size: 22)
        
        // в зависимости от градусов делаем подсказки пользователю
        if let temperature = city?.weatherData?.main.temp {
            switch Int(temperature) {
            case 0...9:
                label.text = WeatherUserAction.wearVeryWarmClothes.rawValue
            case 10...15:
                label.text = WeatherUserAction.wearWarmClothes.rawValue
            case 16...23:
                label.text = WeatherUserAction.wearLightClothes.rawValue
            case 23...50:
                label.text = WeatherUserAction.eatIceCreamAndSwim.rawValue
            default:
                break
            }
        }
        
        // добавляем лейбл на экран
        self.view.addSubview(label)
        
        // возвращаем лейбл, чтобы потом менять его цвет со всеми лейблами
        return label
    }
    
    private func configureByDay() {
        let userActionLabel = createLabelForUserActions()
        let labels = [cityNameLabel,
                      weatherDescriptionLabel,
                      temperatureLabel,
                      userActionLabel]
        let labelTextColor: UIColor?
        
        // достаем экземпляр структуры WeatherElement
        if city?.weatherData!.weather.indices != nil {
            let weather = city?.weatherData!.weather[0]
            let weatherIcon = String(weather!.icon.suffix(1))
            
            switch weatherIcon {
            case "d":
                view.setGradientBackground(
                    from: UIColor(named: "dayGradientStart")!,
                    to: UIColor(named: "dayGradientEnd")!)
                
                navigationController?.navigationBar.tintColor = UIColor(named: "dayTextColor")
                
                labelTextColor = UIColor(named: "dayTextColor")
            default:
                view.setGradientBackground(
                    from: UIColor(named: "nightGradientStart")!,
                    to: UIColor(named: "nightGradientEnd")!)
                
                navigationController?.navigationBar.tintColor = UIColor(named: "nightTextColor")
                
                labelTextColor = UIColor(named: "nightTextColor")
                break
            }
            
            labels.forEach { label in
                label?.textColor = labelTextColor
            }
            
        }
    }
}
