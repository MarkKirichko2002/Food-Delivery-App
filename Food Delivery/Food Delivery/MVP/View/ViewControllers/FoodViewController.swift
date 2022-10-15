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
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var banner = [Banner(text: "скидка 20%", image: "hamburger"), Banner(text: "скидка 30%", image: "cola"), Banner(text: "cкидка 10%", image: "appetizer")]
    var categories = [FoodCategory(id: 1, name: "закуски", icon: "appetizer"), FoodCategory(id: 2, name: "бургеры", icon: "hamburger")]
    var presenter = FoodPresenter()
    var foods = [Request]()
    var hamburgers = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.SetFoodDelegate(delegate: self)
        presenter.GetFood()
        presenter.GetHamburgers()
        registerCells()
        AppetizersCollectionView.delegate = self
        AppetizersCollectionView.dataSource = self
        HamburgersCollectionView.delegate = self
        HamburgersCollectionView.dataSource = self
    }
    
    private func registerCells() {
        BannerCollectionView.register(UINib(nibName: BannerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        CategoriesCollectionView.register(UINib(nibName: CategoriesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        AppetizersCollectionView.register(UINib(nibName: AppetizersCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AppetizersCollectionViewCell.identifier)
        HamburgersCollectionView.register(UINib(nibName: HamburgersCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HamburgersCollectionViewCell.identifier)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppetizersCollectionViewCell.identifier, for: indexPath) as! AppetizersCollectionViewCell
            cell.configure(appetizers: foods[indexPath.row])
            return cell
        case HamburgersCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HamburgersCollectionViewCell.identifier, for: indexPath) as! HamburgersCollectionViewCell
            cell.configure(hamburgers: hamburgers[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case CategoriesCollectionView:
            
            switch categories[indexPath.row].id {
                
            case 1:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 380
                    }, completion: nil)
                }
            
            case 2:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.ScrollView.contentOffset.y = self.ScrollView.contentOffset.y + 550
                    }, completion: nil)
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
            
            
        default:
            break
            
        }
    }
    
    func presentFood(food: [Request]) {
        DispatchQueue.main.async {
            self.foods = food
            self.AppetizersCollectionView.reloadData()
            self.HamburgersCollectionView.reloadData()
            print(food)
        }
    }
    
    func presentHamburgers(hamburgers: [Request]) {
        DispatchQueue.main.async {
            self.hamburgers = hamburgers
            self.HamburgersCollectionView.reloadData()
            print(hamburgers)
        }
    }
}
