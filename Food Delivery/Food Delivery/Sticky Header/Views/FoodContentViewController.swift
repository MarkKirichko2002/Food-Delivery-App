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
    
    var numberOfCells: Int = 0
    
    var foods = [Request]()
    
    var presenter = FoodPresenter()
    
    var number = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        presenter.SetFoodDelegate(delegate: self)
        
        switch number {
        case 0:
            presenter.GetPizzas()
            
        case 1:
            presenter.GetHamburgers()
            
        case 2:
            presenter.GetCola()
            
        case 3:
            presenter.GetFood()
            
        default:
            break
        }
        
        setupTableView()
    }
    
    func presentAppetizers(food: [Request]) {
        DispatchQueue.main.async {
            self.foods = food
            self.tableView.reloadData()
        }
    }
    
    func presentHamburgers(hamburgers: [Request]) {
        DispatchQueue.main.async {
            self.foods = hamburgers
            self.tableView.reloadData()
        }
    }
    
    func presentCola(cola: [Request]) {
        DispatchQueue.main.async {
            self.foods = cola
            self.tableView.reloadData()
        }
    }
    
    func presentPizzas(pizzas: [Request]) {
        DispatchQueue.main.async {
            self.foods = pizzas
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: TabTableViewCellID, bundle: nil),
                           forCellReuseIdentifier: TabTableViewCellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
    }
}

extension FoodContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: TabTableViewCellID) as? FoodTableViewCell {
            
            cell.FoodImage.sd_setImage(with: URL(string: foods[indexPath.row].imageURL))
            cell.FoodName.text = foods[indexPath.row].name
            cell.FoodDescription.text = "\(foods[indexPath.row].requestDescription)"
            cell.PriceButton.setTitle("от \(foods[indexPath.row].price)", for: .normal)
            cell.PriceButton.layer.cornerRadius = cell.PriceButton.frame.width / 6
            cell.PriceButton.layer.borderWidth = 1
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController else {return}
        vc.imageURL = foods[indexPath.row].imageURL
        vc.name = foods[indexPath.row].name
        vc.price = foods[indexPath.row].price
        vc.carbs = foods[indexPath.row].carbs
        vc.calories = foods[indexPath.row].calories
        self.navigationController?.pushViewController(vc, animated: true)
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


