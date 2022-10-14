//
//  NetworkService.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import Foundation
import Alamofire

struct NetworkService {
    
    func GetFood(completion: @escaping([Request])->()) {
        AF.request("https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/appetizers").responseData { response in
            guard let data = response.data else {return}
            
            var foodResponse: Food?
            
            do {
                foodResponse = try JSONDecoder().decode(Food.self, from: data)
                guard let foodResponse = foodResponse?.request else {return}
                completion(foodResponse)
            } catch {
                print(error)
            }
        }
    }
}
