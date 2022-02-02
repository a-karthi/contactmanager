//
//  NetworkManager.swift
//  contactmanager
//
//  Created by @karthi on 14/01/22.
//
import Foundation

class NetworkManager {
    
    //get contatcts api call
    static func getContacts<T: Decodable>(offset:Int,
                                          responseType: T.Type,
                                          completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        let stringUrl = "http://shielded-ridge-19050.herokuapp.com/api/?offset=\(offset)"
        guard let serviceUrl = URL(string: stringUrl) else { return }
        var networkRequest = URLRequest(url: serviceUrl)
        networkRequest.httpMethod = "GET"
        networkRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: networkRequest) { (data, response, error) in

            if let data = data, let httpStatus = response as? HTTPURLResponse {

                switch httpStatus.statusCode {
                case 200:
                    do {
                        let dataObj = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(.success(dataObj))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completionHandler(.failure(error!))
                    }
                }

            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(error!))
                }
            }

        }.resume()
    }
    
    //download task from url
    static func loadPicture(from server: URL, completion: @escaping (Data) -> Void) {
        
        URLSession.shared.dataTask(with: server) { data, response, error in
                   guard let data = data, error == nil else { return }
                   DispatchQueue.main.async {
                       completion(data)
                   }
           }.resume()
        
    }
}


