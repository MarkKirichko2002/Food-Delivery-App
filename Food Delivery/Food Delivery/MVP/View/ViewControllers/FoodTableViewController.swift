//
//  FoodTableViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 16.10.2022.
//

import UIKit
import SDWebImage

class FoodTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MicrophoneButton: UIButton!
    
    var foodpages = [FoodPage]()
    var presenter = FoodPresenter()
    
    @IBAction func SpeechRecognition() {
        presenter.isStart = !presenter.isStart
        if presenter.isStart {
            presenter.startSpeechRecognization()
        } else {
            presenter.cancelSpeechRecognization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.SetFoodDelegate(delegate: self)
        presenter.SetTable(tableView: self.tableView)
        presenter.SetButton(button: self.MicrophoneButton)
        presenter.GetFood()
        presenter.GetHamburgers()
        presenter.GetCola()
        presenter.GetPizzas()
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 0, name: "Баннер", list: [Request(name: "скидка 20%", calories: 303, id: 0, carbs: 30, requestDescription: "", price: 10.0, protein: 10, imageURL: "https://www.maggi.ru/data/images/recept/img640x500/recept_3682_avoa.jpg"), Request(name: "скидка 10%", calories: 300, id: 0, carbs: 0, requestDescription: "", price: 8.99, protein: 0, imageURL: "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg"), Request(name: "скидка 30%", calories: 212, id: 0, carbs: 53, requestDescription: "", price: 5.0, protein: 0, imageURL: "https://www.vastivr.ru/uploads/shop_prod/300x0/ac7a493144edc0758c9abce332551115.jpg")]))
            self.foodpages.append(FoodPage(id: 1, name: "Категории", list: [Request(name: "Закуски", calories: 10, id: 1, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg"), Request(name: "Бургеры", calories: 10, id: 2, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://www.maggi.ru/data/images/recept/img640x500/recept_3682_avoa.jpg"), Request(name: "Кола", calories: 10, id: 3, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://www.vastivr.ru/uploads/shop_prod/300x0/ac7a493144edc0758c9abce332551115.jpg"), Request(name: "Пицца", calories: 10, id: 4, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://static.pizzasushiwok.ru/images/menu_new/6-1300.jpg")]))
        }
    }
}

extension FoodTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return foodpages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodpages[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier, for: indexPath) as! FoodTableViewCell
        cell.FoodImage.sd_setImage(with: URL(string: "\(foodpages[indexPath.section].list[indexPath.row].imageURL)"))
        cell.FoodName.text = "\(foodpages[indexPath.section].list[indexPath.row].name)"
        //cell.FoodPrice.text = "\(foodpages[indexPath.section].list[indexPath.row].price)$"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return foodpages[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.text = foodpages[section].name
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if foodpages[indexPath.section].name == "Категории" {
            switch indexPath.row {
                
            case 0:
                presenter.scrollTable(section: 5)
                
            case 1:
                presenter.scrollTable(section: 2)
                
            case 2:
                presenter.scrollTable(section: 3)
                
            case 3:
                presenter.scrollTable(section: 4)
                
            default:
                break
            }
        }
        
        if foodpages[indexPath.section].name != "Категории" {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController {
                vc.imageURL = foodpages[indexPath.section].list[indexPath.row].imageURL
                vc.name = foodpages[indexPath.section].list[indexPath.row].name
                vc.price = foodpages[indexPath.section].list[indexPath.row].price
                vc.carbs = foodpages[indexPath.section].list[indexPath.row].carbs
                vc.calories = foodpages[indexPath.section].list[indexPath.row].calories
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension FoodTableViewController: FoodPresentDelegate {
    func presentAppetizers(food: [Request]) {
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 1, name: "Закуски", list: food))
            self.tableView.reloadData()
        }
    }
    
    func presentHamburgers(hamburgers: [Request]) {
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 2, name: "Бургеры", list: hamburgers))
            self.tableView.reloadData()
        }
    }
    
    func presentCola(cola: [Request]) {
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 3, name: "Кола", list: cola))
            self.tableView.reloadData()
        }
    }
    
    func presentPizzas(pizzas: [Request]) {
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 4, name: "Пицца", list: pizzas))
            self.tableView.reloadData()
        }
    }
    
}
