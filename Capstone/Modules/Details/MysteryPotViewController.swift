//
//  MysteryPotViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 11.04.25.
//

import UIKit
import MapKit

class MysteryPotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var foodItem: FoodItemModel!
    var foodItems: [FoodItemModel] = []
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var descriptionDetails: UILabel!
    @IBOutlet weak var mysteryPotCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mysteryPotCollectionView.dataSource = self
        mysteryPotCollectionView.delegate = self
        mysteryPotCollectionView.showsHorizontalScrollIndicator = false
        
        foodImage.image = UIImage(named: foodItem.storeImage)
        restaurantName.text = foodItem.storeNameLabel
        shortDescription.text = foodItem.shortDecsription
        descriptionTitle.text = "Description"
        descriptionDetails.text = foodItem.description
        
        address.setTitle(foodItem?.addressSpecific, for: .normal)
        address.addTarget(self, action: #selector(handleAddressButton), for: .touchUpInside)
        address.isHidden = false
        
        foodImage.contentMode = .scaleAspectFill
        foodImage.clipsToBounds = true
        shortDescription.textColor = .appDarkTeal
        address.tintColor = .appDarkTeal
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc private func handleAddressButton() {
        let mapVC = MapViewController(
            centerCoordinate: .init(latitude: foodItem.coordinate.latitude, longitude: foodItem.coordinate.longitude),
            allStores: foodItems,
            preselectedStore: foodItem
        )
        mapVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItem.mysteryPot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MysteryPotCollectionViewCell", for: indexPath) as? MysteryPotCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = foodItem.mysteryPot[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = foodItem
        let selectedMysteryPot = foodItem.mysteryPot[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MysteryPotDetailsViewcontroller") as? MysteryPotDetailsViewcontroller {
              detailVC.foodItem = selectedItem
            detailVC.mysteryPotItem = selectedMysteryPot
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
