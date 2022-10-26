//
//  StickyHeaderFoodViewController.swift
//  Food Delivery
//
//  Created by Марк Киричко on 17.10.2022.
//

import UIKit
import SDWebImage

struct Page {
    
    var name = ""
    var vc = UIViewController()
    
    init(with _name: String, _vc: UIViewController) {
        
        name = _name
        vc = _vc
    }
}

struct PageCollection {
    
    var pages = [Page]()
    var selectedPageIndex = 0
}

var topViewInitialHeight : CGFloat = 200

let topViewFinalHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height + 44 //navigation hieght

let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

class StickyHeaderFoodViewController: UIViewController {
    
    let tabContentVC = UIViewController()
    
    let pages = ["Пицца", "Бургеры", "Кола", "Закуски"]
    var pagenumber = [Int]()
    
    let bannerimages = [Banner(text: "пицца", image: "pizza"), Banner(text: "бургеры", image: "hamburger"), Banner(text: "кола", image: "cola")]
    
    var foodpages = [FoodPage]()
    private var oldContentOffset = CGPoint.zero
    
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var BannerCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var MicrophoneButton: UIButton!
    
    @IBAction func SpeechRecognition() {
        presenter.isStart = !presenter.isStart
        if presenter.isStart {
            presenter.startSpeechRecognization()
        } else {
            presenter.cancelSpeechRecognization()
        }
    }
    
    var pageViewController = UIPageViewController()
    var selectedTabView = UIView()
    var pageCollection = PageCollection()
    var presenter = FoodPresenter()
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.SetFoodDelegate(delegate: self)
        presenter.SetTable(tableView: self.tableView)
        presenter.SetButton(button: self.MicrophoneButton)
        presenter.GetPizzas()
        presenter.GetHamburgers()
        presenter.GetCola()
        presenter.GetFood()
        setupCollectionView()
        setupTableView()
        setupPagingViewController()
        populateBottomView()
        addPanGestureToTopViewAndCollectionView()
    }
    
    func setupCollectionView() {
        
        let layout = tabBarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 100, height: 50)
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        tabBarCollectionView.register(UINib(nibName: TabBarCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TabBarCollectionViewCell.identifier)
        
        BannerCollectionView.delegate = self
        BannerCollectionView.dataSource = self
        BannerCollectionView.register(UINib(nibName: BannerCell.identifier, bundle: nil), forCellWithReuseIdentifier: BannerCell.identifier)
        
        setupSelectedTabView()
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: FoodTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FoodTableViewCell.identifier)
    }
    
    func setupSelectedTabView() {
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        label.sizeToFit()
        var width = label.intrinsicContentSize.width
        width = width + 40
        
        selectedTabView.frame = CGRect(x: 20, y: 55, width: width, height: 5)
        selectedTabView.backgroundColor = .black
        tabBarCollectionView.addSubview(selectedTabView)
    }
    
    func setupPagingViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    func populateBottomView() {
        
        for page in pages {
            
            let displayName = page
            let page = Page(with: displayName, _vc: tabContentVC)
            pageCollection.pages.append(page)
        }
        
        let initialPage = 0
        
        pageViewController.setViewControllers([pageCollection.pages[initialPage].vc],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        bottomView.addSubview(pageViewController.view)
        
        pinPagingViewControllerToBottomView()
    }
    
    func pinPagingViewControllerToBottomView() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
    }
    
    func addPanGestureToTopViewAndCollectionView() {
        
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        
        stickyHeaderView.isUserInteractionEnabled = true
        stickyHeaderView.addGestureRecognizer(topViewPanGesture)
        
    }
    
    var dragInitialY: CGFloat = 0
    var dragPreviousY: CGFloat = 0
    var dragDirection: DragDirection = .Up
    
    @objc func topViewMoved(_ gesture: UIPanGestureRecognizer) {
        
        var dragYDiff : CGFloat
        
        switch gesture.state {
            
        case .began:
            
            dragInitialY = gesture.location(in: self.view).y
            dragPreviousY = dragInitialY
            
        case .changed:
            
            let dragCurrentY = gesture.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .Down : .Up
            innerTableViewDidScroll(withDistance: dragYDiff)
            
        case .ended:
            
            innerTableViewScrollEnded(withScrollDirection: dragDirection)
            
        default: return
            
        }
    }
    
    //MARK:- UI Laying Out Methods
    
    func setBottomPagingView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                              direction: navigationDirection,
                                              animated: true,
                                              completion: nil)
    }
    
    func scrollSelectedTabView(toIndexPath indexPath: IndexPath, shouldAnimate: Bool = true) {
        
        UIView.animate(withDuration: 0.3) {
            
            if let cell = self.tabBarCollectionView.cellForItem(at: indexPath) {
                
                self.selectedTabView.frame.size.width = cell.frame.width
                self.selectedTabView.frame.origin.x = cell.frame.origin.x
            }
        }
    }
}

extension StickyHeaderFoodViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case tabBarCollectionView:
            return pageCollection.pages.count
            
        case BannerCollectionView:
            return bannerimages.count
            
        default:
            break
            
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case tabBarCollectionView:
            
            let tabCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier, for: indexPath) as! TabBarCollectionViewCell
            
            tabCell.tabNameLabel.text = pageCollection.pages[indexPath.row].name
            return tabCell
            
        case BannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            
            cell.BannerImage.image = UIImage(named: bannerimages[indexPath.row].image)
            cell.BannerText.text = bannerimages[indexPath.row].text
            return cell
            
        default:
            break
        }
        
        return UICollectionViewCell()
    }
}

extension StickyHeaderFoodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
            
        case 0:
            presenter.scrollTable(section: 0)
            print(0)
            
        case 1:
            presenter.scrollTable(section: 1)
            print(1)
            
        case 2:
            presenter.scrollTable(section: 2)
            print(2)
            
        case 3:
            presenter.scrollTable(section: 3)
            print(3)
            
        default:
            break
        }
        
        if indexPath.item == pageCollection.selectedPageIndex {
            
            return
        }
        
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > pageCollection.selectedPageIndex {
            
            direction = .forward
            
        } else {
            
            direction = .reverse
        }
        
        pageCollection.selectedPageIndex = indexPath.item
        
        tabBarCollectionView.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
        
        scrollSelectedTabView(toIndexPath: indexPath)
        
        setBottomPagingView(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension StickyHeaderFoodViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                
                // go to previous page in array
                
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                
                // go to next page in array
                
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

extension StickyHeaderFoodViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        
        guard let currentVCIndex = pageCollection.pages.firstIndex(where: { $0.vc == currentVC }) else { return }
        
        let indexPathAtCollectionView = IndexPath(item: currentVCIndex, section: 0)
        
        scrollSelectedTabView(toIndexPath: indexPathAtCollectionView)
        tabBarCollectionView.scrollToItem(at: indexPathAtCollectionView,
                                          at: .centeredHorizontally,
                                          animated: true)
    }
}


extension StickyHeaderFoodViewController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        
        headerViewHeightConstraint.constant -= scrollDistance
        
        if headerViewHeightConstraint.constant < topViewFinalHeight {
            
            headerViewHeightConstraint.constant = topViewFinalHeight
        }
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerViewHeightConstraint.constant
        
        if topViewHeight <= topViewFinalHeight + 20 {
            
            scrollToFinalView()
            
        } else if topViewHeight <= topViewInitialHeight - 20 {
            
            switch scrollDirection {
                
            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()
                
            }
            
        } else {
            
            scrollToInitialView()
        }
    }
    
    func scrollToInitialView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewCurrentHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollToFinalView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewFinalHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
}

extension StickyHeaderFoodViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.FoodDescription.text = foodpages[indexPath.section].list[indexPath.row].requestDescription
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

extension StickyHeaderFoodViewController: FoodPresentDelegate {
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

extension StickyHeaderFoodViewController {
    
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


