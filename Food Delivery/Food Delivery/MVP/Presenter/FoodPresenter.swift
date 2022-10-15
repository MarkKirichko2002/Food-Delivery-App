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
    func presentHamburgers(hamburgers: [Request])
}

typealias Presenter = FoodPresentDelegate & UIViewController

class FoodPresenter {
    
    var foods = [Request]()
    var hamburgers = [Request]()
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
    
    func GetHamburgers() {
        DispatchQueue.main.async {
            self.hamburgers = [Request(name: "фишбургер", calories: 278, id: 1, carbs: 8, requestDescription: "Фиш Бургер - это филе хорошо прожаренной рыбы (семейства тресковых), которое подается на пропаренной булочке с половинкой кусочка сыра Чеддер, заправленной специальным соусом Тар-Тар.", price: 10.0, protein: 10, imageURL: "https://www.gastronom.ru/binfiles/images/20170531/b5e02efe.jpg"), Request(name: "чизбургер", calories: 303, id: 2, carbs: 30, requestDescription: "Чи́збургер (англ. cheeseburger, от cheese — сыр) — это гамбургер с сыром. Традиционно ломтик сыра кладется поверх мясной котлеты. Сыр обычно добавляют в готовящийся гамбургер незадолго до подачи на стол, что позволяет сыру расплавиться.", price: 10.0, protein: 15, imageURL: "https://www.maggi.ru/data/images/recept/img640x500/recept_3682_avoa.jpg"), Request(name: "блэк бургер", calories: 10, id: 10, carbs: 30, requestDescription: "", price: 10.0, protein: 40, imageURL: "https://irecommend.ru/sites/default/files/product-images/684763/fMRdsudml6qhVdOOcVxpnQ.jpg")]
            self.delegate?.presentHamburgers(hamburgers: self.hamburgers)
        }
    }
    
    func SetFoodDelegate(delegate: FoodPresentDelegate & UIViewController) {
        self.delegate = delegate
    }
}
