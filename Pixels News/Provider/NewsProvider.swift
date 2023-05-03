//
//  NewsProvider.swift
//  Pixels News
//
//  Created by Alief Azies on 22/10/21.
//

import Foundation
import Alamofire

let API_KEY = "HptKz2x94RAK5It2SWIGdGrPnZ2rjA9k"
let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"

class NewsProvider {
    static let shared: NewsProvider = NewsProvider()
    private init() { }
    
    func loadTopNews(completion: @escaping (Result<[News], Error>) -> Void) {
        AF.request(
            "\(BASE_URL)/viewed/1.json",
            method: .get,
            parameters: ["api-key": API_KEY]
        ).responseData { dataResponse in
            if let data = dataResponse.data {
                do {
                    let response = try JSONDecoder().decode(TopNewsResponse.self, from: data)
                    completion(.success(response.results))
                }
                catch {
                    completion(.failure(error))
                }
            }
            else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
                completion(.failure(error))
            }
        }
    }
    
    func loadNews(completion: @escaping(Result<[News], Error>)-> Void) {
        AF.request("\(BASE_URL)/viewed/30.json", method: HTTPMethod.get, parameters: ["api-key": API_KEY]).responseData { dataResponse in
            if let data = dataResponse.data{
                do{
                    let response = try JSONDecoder().decode(TopNewsResponse.self, from: data)
                    completion(.success(response.results))
                }
                catch{
                    completion(.failure(error))
                }
            }
            else{
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
                completion(.failure(error))
            }
        }
    }
}
