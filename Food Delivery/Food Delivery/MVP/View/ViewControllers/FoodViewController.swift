//
//  FoodViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 13.10.2022.
//

import UIKit

class FoodViewController: UIViewController, FoodPresentDelegate {

    @IBOutlet weak var BannerCollectionView: UICollectionView!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var AppetizersCollectionView: UICollectionView!
    @IBOutlet weak var HamburgersCollectionView: UICollectionView!
    @IBOutlet weak var ColaCollectionView: UICollectionView!
    @IBOutlet weak var PizzaCollectionView: UICollectionView!
    @IBOutlet weak var MicrophoneButton: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var banner = [Banner(text: "скидка 20%", image: "hamburger"), Banner(text: "скидка 30%", image: "cola"), Banner(text: "cкидка 10%", image: "appetizer")]
    var categories = [FoodCategory(id: 1, name: "закуски", icon: "appetizer"), FoodCategory(id: 2, name: "бургеры", icon: "hamburger"), FoodCategory(id: 3, name: "кола", icon: "cola"), FoodCategory(id: 4, name: "пицца", icon: "pizza")]
    var presenter = FoodPresenter()
    var foods = [Request]()
    var hamburgers = [Request]()
    var cola = [Request]()
    var pizzas = [Request]()
    
    @IBAction func SpeechRecognition() {
        presenter.isStart = !presenter.isStart
        if presenter.isStart {
         //   presenter.startSpeechRecognization()
        } else {
            presenter.cancelSpeechRecognization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.SetFoodDelegate(delegate: self)
        //presenter.SetScroll(scrollView: self.ScrollView)
        presenter.SetButton(button: self.MicrophoneButton)
        presenter.GetFood()
        presenter.GetHamburgers()
        presenter.GetCola()
        presenter.GetPizzas()
        registerCells()
        AppetizersCollectionView.delegate = self
        AppetizersCollectionView.dataSource = self
        HamburgersCollectionView.delegate = self
        HamburgersCollectionView.dataSource = self
        ColaCollectionView.delegate = self
        ColaCollectionView.dataSource = self
        PizzaCollectionView.delegate = self
        PizzaCollectionView.dataSource = self
    }
    
    private func registerCells() {
        BannerCollectionView.register(UINib(nibName: BannerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        CategoriesCollectionView.register(UINib(nibName: CategoriesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        AppetizersCollectionView.register(UINib(nibName: FoodCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        HamburgersCollectionView.register(UINib(nibName: FoodCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        ColaCollectionView.register(UINib(nibName: FoodCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        PizzaCollectionView.register(UINib(nibName: FoodCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
    }
    
}

extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case BannerCollectionView:
            return banner.count
        case CategoriesCollectionView:
            return categories.count
        case AppetizersCollectionView:
            return foods.count - 2
        case HamburgersCollectionView:
            return hamburgers.count
        case ColaCollectionView:
            return cola.count
        case PizzaCollectionView:
            return pizzas.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case BannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
            cell.configure(banner: banner[indexPath.row])
            return cell
        case CategoriesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
            cell.configure(categories: categories[indexPath.row])
            return cell
        case AppetizersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.configure(food: foods[indexPath.row])
            return cell
        case HamburgersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.configure(food: hamburgers[indexPath.row])
            return cell
        case ColaCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.configure(food: cola[indexPath.row])
            return cell
        case PizzaCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.configure(food: pizzas[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case CategoriesCollectionView:
            
            switch categories[indexPath.row].id {
                
            case 1:
                if self.ScrollView.contentOffset.y == 0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 380
                        }, completion: nil)
                    }
                }
                
            case 2:
                if self.ScrollView.contentOffset.y == 0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 550
                        }, completion: nil)
                    }
                }
                
            case 3:
                if self.ScrollView.contentOffset.y == 0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 750
                        }, completion: nil)
                    }
                }
                
            case 4:
                if self.ScrollView.contentOffset.y == 0 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                            self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 950
                        }, completion: nil)
                    }
                }
                
            default:
                break
            }
            
        case AppetizersCollectionView:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController {
                vc.imageURL = foods[indexPath.row].imageURL
                vc.name = foods[indexPath.row].name
                vc.price = foods[indexPath.row].price
                vc.carbs = foods[indexPath.row].carbs
                vc.calories = foods[indexPath.row].calories
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case HamburgersCollectionView:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController {
                vc.imageURL = hamburgers[indexPath.row].imageURL
                vc.name = hamburgers[indexPath.row].name
                vc.price = hamburgers[indexPath.row].price
                vc.carbs = hamburgers[indexPath.row].carbs
                vc.calories = hamburgers[indexPath.row].calories
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case ColaCollectionView:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController {
                vc.imageURL = cola[indexPath.row].imageURL
                vc.name = cola[indexPath.row].name
                vc.price = cola[indexPath.row].price
                vc.carbs = cola[indexPath.row].carbs
                vc.calories = cola[indexPath.row].calories
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case PizzaCollectionView:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FoodDetailViewController") as? FoodDetailViewController {
                vc.imageURL = pizzas[indexPath.row].imageURL
                vc.name = pizzas[indexPath.row].name
                vc.price = pizzas[indexPath.row].price
                vc.carbs = pizzas[indexPath.row].carbs
                vc.calories = pizzas[indexPath.row].calories
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            break
        }
    }
    
    func presentAppetizers(food: [Request]) {
        DispatchQueue.main.async {
            self.foods = food
            self.AppetizersCollectionView.reloadData()
        }
    }
    
    func presentHamburgers(hamburgers: [Request]) {
        DispatchQueue.main.async {
            self.hamburgers = hamburgers
            self.HamburgersCollectionView.reloadData()
        }
    }
    
    func presentCola(cola: [Request]) {
        DispatchQueue.main.async {
            self.cola = cola
            self.ColaCollectionView.reloadData()
        }
    }
    
    func presentPizzas(pizzas: [Request]) {
        DispatchQueue.main.async {
            self.pizzas = pizzas
            self.PizzaCollectionView.reloadData()
        }
    }
}
