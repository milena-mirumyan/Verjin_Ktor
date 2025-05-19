//
//  HomeViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 02.04.25.
//

import UIKit
import MapKit
import CoreLocation
import Lottie

final class HomeViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, CategoryCellDelegate, UISearchBarDelegate {
    
    @IBAction func notificationTapped(_ sender: Any) {
        let vc = NotificationsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationItem.backBarButtonItem?.tintColor = .appDarkTeal
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        let mapVC = MapViewController(
            centerCoordinate: CLLocationCoordinate2D.init(latitude: 40.1931, longitude: 44.5044),
            allStores: foodItems,
            preselectedStore: nil
        )
        mapVC.hidesBottomBarWhenPushed = true
        navigationItem.backBarButtonItem?.tintColor = .appDarkTeal
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var map: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let emptyView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    private var placeholderView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var placeholderImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        return image
    }()
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Artboard 1-2")
        view.loopMode = .loop
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private var coverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let storageService = StorageService.shared
    var isFavorites = false
    var selectedCategoryName: String = "All"
    var categoryItems: [CategoryItemModel] = [
        CategoryItemModel(categoryName: "All", iconName: "food", isSelected: true),
        CategoryItemModel(categoryName: "Burger", iconName: "burger",isSelected: false),
        CategoryItemModel(categoryName: "Pizza", iconName: "pizza", isSelected: false),
        CategoryItemModel(categoryName: "Sushi", iconName: "sushi", isSelected: false),
        CategoryItemModel(categoryName: "Organic", iconName: "vegetable", isSelected: false),
        CategoryItemModel(categoryName: "Sweets", iconName: "cake", isSelected: false)
    ]
    var foodItems: [FoodItemModel] = []
    var originalFoodItems: [FoodItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityLabel = "home"
        view.addSubview(emptyView)
        emptyView.addSubview(placeholderView)
        placeholderView.addSubview(animationView)
        placeholderView.addSubview(coverView)
        placeholderView.addSubview(placeholderImage)
        placeholderView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.leadingAnchor, constant: 32),
            placeholderView.topAnchor.constraint(greaterThanOrEqualTo: emptyView.topAnchor, constant: 32),

            animationView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 30),
            animationView.widthAnchor.constraint(equalToConstant: 256),
            animationView.heightAnchor.constraint(equalToConstant: 256),
            
            placeholderImage.topAnchor.constraint(equalTo: placeholderView.topAnchor, constant: 20),
            placeholderImage.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderImage.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 32),
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor),
            
            coverView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -20),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        navigationItem.title = "Ready to rescue a meal?"
        storageService.subscribe(subscriber: self, perform: { [weak self] newItems in
            guard let self else { return }
            if isFavorites {
                originalFoodItems = newItems.filter({ $0.favoriteButton })
                
                searchBar.placeholder = "Search by name or category..."
                navigationItem.title = "Your Favorites"
            } else {
                originalFoodItems = newItems
            }
            applyFilters()
            foodCollectionView.reloadData()
        })
        
        if isFavorites {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            
            categoryCollectionView.isHidden = true
            categoryHeightConstraint.constant = 0
            
            originalFoodItems = originalFoodItems.filter({ $0.favoriteButton })
        }
        
        foodCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.allowsSelection = true

        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.allowsSelection = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = true
        searchBar.isHidden = false
        searchBar.placeholder = "Search by name or category..."
        searchBar.tintColor = .appDarkTeal
        
        foodItems = originalFoodItems
        
        if let categoryCells = categoryCollectionView.visibleCells as? [CategoryCollectionViewCell] {
            for cell in categoryCells {
                cell.delegate = self
            }
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton

        categoryCellDidSelectCategory(categoryName: "All")
        dimissOnTap()
    }
    
    func categoryCellDidSelectCategory(categoryName: String) {
        selectedCategoryName = categoryName
        
        for (index, var category) in categoryItems.enumerated() {
            category.isSelected = false
            categoryItems[index] = category
        }
        
        let indexPath = categoryItems.firstIndex(where: { $0.categoryName == categoryName })!
        var selectedCategory = categoryItems[indexPath]
        selectedCategory.isSelected = true
        categoryItems[indexPath] = selectedCategory
        
        applyFilters()
        foodCollectionView.reloadData()
        categoryCollectionView.reloadData()
    }
    
    func applyFilters() {
        let searchText = searchBar.text?.lowercased() ?? ""
        
        foodItems = originalFoodItems.filter { item in
            let matchesCategory = (selectedCategoryName == "All" || item.category == selectedCategoryName)
            let matchesSearch = searchText.isEmpty ||
            item.storeNameLabel.lowercased().contains(searchText) ||
            item.category.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }
        
        if foodItems.isEmpty {
            emptyView.isHidden = false
            foodCollectionView.isHidden = true
            
            if searchText.isEmpty {
                if isFavorites {
                    if animationView.isHidden {
                        placeholderImage.isHidden = true
                        animationView.isHidden = false
                        animationView.play()
                    }

                    placeholderLabel.text = "You haven’t added any\nfavorites yet."
                    placeholderImage.image = .init(systemName: "heart.fill")?.withConfiguration(
                        UIImage.SymbolConfiguration(pointSize: 64, weight: .medium)
                    )
                } else {
                    placeholderImage.isHidden = false
                    animationView.isHidden = true
                    animationView.stop()
                    placeholderLabel.text = ""
                }
            } else {
                placeholderImage.isHidden = false
                animationView.isHidden = true
                animationView.stop()
                placeholderLabel.text = "No results found.\nTry adjusting your filters."
                placeholderImage.image = .init(systemName: "magnifyingglass")?.withConfiguration(
                    UIImage.SymbolConfiguration(pointSize: 64, weight: .medium)
                )
            }
            
        } else {
            emptyView.isHidden = true
            foodCollectionView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == foodCollectionView {
            return foodItems.count
        } else {
            return categoryItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == foodCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? FoodCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = foodItems[indexPath.item]
            cell.configure(with: item)
            cell.delegate = self
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = categoryItems[indexPath.item]
            cell.configure(with: item)
            cell.delegate = self
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == foodCollectionView {
            let selectedItem = foodItems[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "MysteryPotViewController") as? MysteryPotViewController {
                detailVC.foodItem = selectedItem
                detailVC.foodItems = self.originalFoodItems
                navigationItem.backBarButtonItem?.tintColor = .white
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView === self.foodCollectionView {
            .init(width: collectionView.bounds.width - 32, height: 256)
        } else {
            .init(width: 128, height: 128)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView === self.foodCollectionView {
            return 28
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === self.foodCollectionView {
            return .init(top: 16, left: 0, bottom: 20, right: 0)
        }
        
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }
}

extension HomeViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilters()
        foodCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        foodItems = originalFoodItems
        foodCollectionView.reloadData()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: FoodCollectionViewCellDelegate {
    func didTapFavoriteButton(in cell: FoodCollectionViewCell, item: FoodItemModel) {
        storageService.update(id: item.id, isFavorite: !item.favoriteButton)
    }
}

extension HomeViewController {
    static func create() -> UIViewController {
        HomeTabBarViewController()
    }
}

final class GradientView: UIView {
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}
