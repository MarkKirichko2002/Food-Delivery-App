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
    func presentFood(food: [Request])
    func presentHamburgers(hamburgers: [Request])
}

typealias Presenter = FoodPresentDelegate & UIViewController

class FoodPresenter {
    
    var foods = [Request]()
    var hamburgers = [Request]()
    var networkService = NetworkService()
    var delegate: Presenter?
    var text = ""
    var scrollView: UIScrollView?
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
                
            case _ where lastString.contains("Вверх") || lastString.contains("вверх"):
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.button?.setImage(UIImage(systemName: "arrow.up"), for: .normal)
                        self.scrollView?.contentOffset.y = 0.0
                    }, completion: nil)
                }
                
            case _ where lastString.contains("Вниз") || lastString.contains("вниз"):
                if self.scrollView?.contentOffset.y == 0.0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.button?.setImage(UIImage(systemName: "arrow.down"), for: .normal)
                            self.scrollView?.contentOffset.y = (self.scrollView?.contentOffset.y ?? 0) + 550
                        }, completion: nil)
                    }
                }
                
            case _ where lastString.contains("Закуски") || lastString.contains("закуски"):
                if self.scrollView?.contentOffset.y == 0.0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.button?.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                            self.scrollView?.contentOffset.y = (self.scrollView?.contentOffset.y ?? 0) + 380
                        }, completion: nil)
                    }
                }
                
            case _ where lastString.contains("Бургеры") || lastString.contains("бургеры"):
                if self.scrollView?.contentOffset.y == 0.0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.button?.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                            self.scrollView?.contentOffset.y = (self.scrollView?.contentOffset.y ?? 0) + 550
                        }, completion: nil)
                    }
                }
                
            case _ where lastString.contains("Стоп") || lastString.contains("стоп"):
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.button?.sendActions(for: .touchUpInside)
                        self.scrollView?.contentOffset.y = (self.scrollView?.contentOffset.y ?? 0) - (self.scrollView?.contentOffset.y ?? 0)
                    }, completion: nil)
                }
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
    
    func SetFoodDelegate(delegate: FoodPresentDelegate & UIViewController) {
        self.delegate = delegate
    }
    
    func SetScroll(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func SetButton(button: UIButton) {
        self.button = button
    }
    
}
