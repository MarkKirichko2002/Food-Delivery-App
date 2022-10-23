//
//  FoodContentViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 17.10.2022.
//

import UIKit
import SDWebImage

enum DragDirection {
    
    case Up
    case Down
}

protocol InnerTableViewScrollDelegate: class {
    
    var currentHeaderHeight: CGFloat { get }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
}

class FoodContentViewController: UIViewController, FoodPresentDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    var foodpages = [FoodPage]()
    var presenter = FoodPresenter()
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.SetFoodDelegate(delegate: self)
        presenter.SetTable(tableView: self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: TabTableViewCellID, bundle: nil), forCellReuseIdentifier: TabTableViewCellID)
        presenter.GetFood()
        presenter.GetHamburgers()
        presenter.GetCola()
        presenter.GetPizzas()
        
        DispatchQueue.main.async {
            self.foodpages.append(FoodPage(id: 1, name: "Категории", list: [Request(name: "Закуски", calories: 10, id: 1, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg"), Request(name: "Бургеры", calories: 10, id: 2, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://www.maggi.ru/data/images/recept/img640x500/recept_3682_avoa.jpg"), Request(name: "Кола", calories: 10, id: 3, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://www.vastivr.ru/uploads/shop_prod/300x0/ac7a493144edc0758c9abce332551115.jpg"), Request(name: "Пицца", calories: 10, id: 4, carbs: 0, requestDescription: "", price: 0, protein: 0, imageURL: "https://static.pizzasushiwok.ru/images/menu_new/6-1300.jpg")]))
        }
        
        switch number {

        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presenter.scrollTable(section: 3)
            }
            
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presenter.scrollTable(section: 1)
            }
            
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presenter.scrollTable(section: 2)
            }
            
        case 3:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presenter.scrollTable(section: 4)
            }
            

        default:
            break

        }
    }
}

extension FoodContentViewController: UITableViewDataSource {
    
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
        cell.FoodDescription.text = "\(foodpages[indexPath.section].list[indexPath.row].requestDescription)"
        cell.PriceButton.setTitle("\(foodpages[indexPath.section].list[indexPath.row].price) р", for: .normal)
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if foodpages[indexPath.section].name == "Категории" {
            switch indexPath.row {
                
            case 0:
                presenter.scrollTable(section: 4)
                
            case 1:
                presenter.scrollTable(section: 1)
                
            case 2:
                presenter.scrollTable(section: 2)
                
            case 3:
                presenter.scrollTable(section: 3)
                
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

extension FoodContentViewController {
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


extension FoodContentViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            if delta > 0,
               topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
               scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            if delta < 0,

               scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}


