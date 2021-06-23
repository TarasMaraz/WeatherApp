//
//  NetworkManager.swift
//  WeatherApp
//

import Foundation

// enum для каждого типа ошибок
enum NetworkManagerError {
    case wrongUrl
    case wrongResponse
    case httpError
    case dataError
    case jsonError
}

// Метод httpGetRequest возвращает enum NetworkManagerResponse который содержит либо success, либо failure
enum NetworkManagerResponse<T: Codable> {
    case success(data: T)
    case failure(error: NetworkManagerError, message: String)
}

class NetworkManager {
    lazy private var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json; charset=UTF-8"]
        config.waitsForConnectivity = false
        
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    func httpGetRequest<T: Codable>(url: String, completionHandler: @escaping (NetworkManagerResponse<T>) -> Void) {
        // строку преобразовываем в URL
        guard let encodeUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlPath = URL(string: encodeUrl) else {
            completionHandler(.failure(error: .wrongUrl, message: "Wrong url \(url) passed"))
            return
        }
        // тут формируем URLRequest
        let urlRequest = URLRequest(url: urlPath)
        
        // тут выполняем сам get-запрос
        let task = defaultSession.dataTask(with: urlRequest) { data, response, error in
            
            // если пришла ошибка, возвращаем failure
            guard error == nil else {
                completionHandler(.failure(error: .httpError, message: "General HTTP error: \(error!.localizedDescription)"))
                
                return
            }
            
            // если ответ сервера содержит недопустимый http-код, то возвращаем failure
            guard let urlResponse = response as? HTTPURLResponse, (200..<300).contains(urlResponse.statusCode) else {
                completionHandler(.failure(error: .wrongResponse, message: "Wrong HTTP response"))
                return
            }
            
            // пытаемся извлечь данные из ответа
            guard let data = data else {
                completionHandler(.failure(error: .dataError, message: "Wrong HTTP response"))
                return
            }
            
            do {
                // декодируем данные в модель и возвращаем success. JSONDecoder.decode может вернуть ошибку во время декодирования, поэтому он требует чтобы было обернуто в do { ... } catch ( ... ) { ... }
                let jsonData = try JSONDecoder().decode(T.self, from: data)
            
                completionHandler(.success(data: jsonData))
            } catch (let error) {
                completionHandler(.failure(error: .jsonError, message: "Json parse error: \(error.localizedDescription)"))
            }
        }
        
        task.resume()
    }
}
