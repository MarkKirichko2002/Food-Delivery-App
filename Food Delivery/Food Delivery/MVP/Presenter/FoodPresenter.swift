//
//  FoodPresenter.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import Foundation
import UIKit

protocol FoodPresentDelegate {
    func presentFood(food: [Request])
}

typealias Presenter = FoodPresentDelegate & UIViewController

class FoodPresenter {
    
    var foods = [Request]()
    var networkService = NetworkService()
    var delegate: Presenter?
    
    func GetFood() {
        networkService.GetFood { food in
            DispatchQueue.main.async {
                self.foods = food
                self.delegate?.presentFood(food: self.foods)
            }
        }
    }
    
    func SetFoodDelegate(delegate: FoodPresentDelegate & UIViewController) {
        self.delegate = delegate
    }
}
