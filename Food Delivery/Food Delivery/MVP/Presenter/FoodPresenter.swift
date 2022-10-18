//
//  FoodPresenter.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import Foundation
import Speech
import UIKit

protocol FoodPresentDelegate {
    func presentAppetizers(food: [Request])
    func presentHamburgers(hamburgers: [Request])
    func presentCola(cola: [Request])
    func presentPizzas(pizzas: [Request])
}

typealias Presenter = FoodPresentDelegate & UIViewController

class FoodPresenter {
    
    var foods = [Request]()
    var hamburgers = [Request]()
    var cola = [Request]()
    var pizzas = [Request]()
    var networkService = NetworkService()
    var delegate: Presenter?
    var text = ""
    var tableView: UITableView?
    var button: UIButton?
    var isStart: Bool = false
    
    let audioEngine = AVAudioEngine()
    let speechReconizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru-RU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task : SFSpeechRecognitionTask!
    
    func GetFood() {
        networkService.GetFood { food in
            DispatchQueue.main.async {
                self.foods = food
                self.delegate?.presentAppetizers(food: self.foods)
            }
        }
    }
    
    func GetHamburgers() {
        DispatchQueue.main.async {
            self.hamburgers = [Request(name: "фишбургер", calories: 278, id: 1, carbs: 8, requestDescription: "Фиш Бургер - это филе хорошо прожаренной рыбы (семейства тресковых), которое подается на пропаренной булочке с половинкой кусочка сыра Чеддер, заправленной специальным соусом Тар-Тар.", price: 10.0, protein: 10, imageURL: "https://www.gastronom.ru/binfiles/images/20170531/b5e02efe.jpg"), Request(name: "чизбургер", calories: 303, id: 2, carbs: 30, requestDescription: "Чи́збургер (англ. cheeseburger, от cheese — сыр) — это гамбургер с сыром. Традиционно ломтик сыра кладется поверх мясной котлеты. Сыр обычно добавляют в готовящийся гамбургер незадолго до подачи на стол, что позволяет сыру расплавиться.", price: 10.0, protein: 15, imageURL: "https://www.maggi.ru/data/images/recept/img640x500/recept_3682_avoa.jpg"), Request(name: "блэк бургер", calories: 250, id: 10, carbs: 30, requestDescription: "", price: 10.0, protein: 40, imageURL: "https://irecommend.ru/sites/default/files/product-images/684763/fMRdsudml6qhVdOOcVxpnQ.jpg")]
            self.delegate?.presentHamburgers(hamburgers: self.hamburgers)
        }
    }
    
    func GetCola() {
        DispatchQueue.main.async {
            self.cola = [Request(name: "Coca-Cola 0,5 л", calories: 212, id: 1, carbs: 53, requestDescription: "", price: 74, protein: 10, imageURL: "https://www.vastivr.ru/uploads/shop_prod/300x0/ac7a493144edc0758c9abce332551115.jpg"), Request(name: "Pepsi Cola 0,33л", calories: 230, id: 2, carbs: 11, requestDescription: "", price: 71.9, protein: 15, imageURL: "https://shop.miratorg.ru/upload/iblock/1af/RN015961.jpg"), Request(name: "Sprite 0.25л", calories: 250, id: 3, carbs: 12, requestDescription: "", price: 75.2, protein: 13, imageURL: "https://aqua-life.spb.ru/foto/110595525062020.jpg")]
            self.delegate?.presentCola(cola: self.cola)
        }
    }
    
    func GetPizzas() {
        DispatchQueue.main.async {
            self.pizzas = [Request(name: "Ветчина и Грибы", calories: 400, id: 2, carbs: 10, requestDescription: "Ветчина, шампиньоны, увеличенная порция, моцареллы, томатный соус", price: 345, protein: 35, imageURL: "https://cdn-irec.r-99.com/sites/default/files/imagecache/300o/product-images/138315/z7cDcI7BOszmoOoV7vHD0w.jpg"), Request(name: "Баварские колбаски", calories: 450, id: 3, carbs: 15, requestDescription: "Баварские колбаски, ветчина, пикантная пепперони, острая чоризо, моцарелла, томатный соус", price: 345, protein: 30, imageURL: "https://rp55.ru/wp-content/uploads/2018/03/Ohotnichya-2-600x600.jpg"), Request(name: "Нежный лосось", calories: 494, id: 1, carbs: 0, requestDescription: "Лосось, томаты черри, моцарелла, соус песто", price: 345, protein: 48, imageURL: "https://i0.wp.com/cafelumier.ru/wp-content/uploads/2020/12/6-15.png?fit=600%2C450&ssl=1"), ]
            self.delegate?.presentPizzas(pizzas: self.pizzas)
            print(self.pizzas)
        }
    }
    
    
    func startSpeechRecognization(){
        
        self.button?.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            print("Error comes here for starting the audio listner =\(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            print("Recognization is not allow on your local")
            return
        }
        
        if !myRecognization.isAvailable {
            print("Recognization is free right now, Please try again after some time.")
        }
        
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else {
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Problem in giving the response")
                }
                return
            }
            
            let message = response.bestTranscription.formattedString
            print("Message : \(message)")
            self.text = message
            
            
            var lastString: String = ""
            for segment in response.bestTranscription.segments {
                let indexTo = message.index(message.startIndex, offsetBy: segment.substringRange.location)
                lastString = String(message[indexTo...])
                self.text = String(message[indexTo...])
            }
            
            switch lastString {
                
            case _ where lastString.contains("Предложени") || lastString.contains("предложени"):
                self.scrollTable(section: 0)
                
            case _ where lastString.contains("Вверх") || lastString.contains("вверх"):
                self.scrollTable(section: 0)
                
            case _ where lastString.contains("Вниз") || lastString.contains("вниз"):
                self.scrollTable(section: 5)
                
            case _ where lastString.contains("Категори") || lastString.contains("категори"):
                self.scrollTable(section: 1)
                
            case _ where lastString.contains("Закуски") || lastString.contains("закуски"):
                self.scrollTable(section: 5)
                
            case _ where lastString.contains("Бургер") || lastString.contains("бургер"):
                self.scrollTable(section: 2)
                
            case _ where lastString.contains("Кол") || lastString.contains("кол"):
                self.scrollTable(section: 3)
                
            case _ where lastString.contains("Пицц") || lastString.contains("пицц"):
                self.scrollTable(section: 4)
                
            case _ where lastString.contains("Стоп") || lastString.contains("стоп"):
                self.button?.sendActions(for: .touchUpInside)
                
            default:
                self.text = ""
                
            }
        })
    }
    
    func cancelSpeechRecognization() {
        self.button?.setImage(UIImage(systemName: "mic"), for: .normal)
        audioEngine.stop()
        task?.cancel()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func scrollTable(section: Int) {
        // 1
        let topRow = IndexPath(row: 0,
                               section: section)
        
        // 2
        self.tableView?.scrollToRow(at: topRow,
                                    at: .top,
                                    animated: true)
    }
    
    func SetFoodDelegate(delegate: FoodPresentDelegate & UIViewController) {
        self.delegate = delegate
    }
    
    func SetTable(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func SetButton(button: UIButton) {
        self.button = button
    }
    
}
