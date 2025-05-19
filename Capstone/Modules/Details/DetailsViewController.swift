//
//  DetailsViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 15.04.25.
//

import UIKit

class DetailsViewController: UIViewController{
    
    var foodItem: FoodItemModel!
    var mysteryItem: MysteryPotModel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dietPreferences: UILabel!
    @IBOutlet weak var detailsView: UIStackView!
    @IBOutlet weak var descriptionView: UIStackView!
    @IBOutlet weak var ingredientsView: UIStackView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var ingredientText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = foodItem.category
        dietPreferences.text = mysteryItem.dietPreference
        
        descriptionText.text = mysteryItem.description
        ingredientText.text = mysteryItem.ingredients
        
        detailsView.layer.borderWidth = 2
        detailsView.layer.backgroundColor = UIColor.appLightTeal.cgColor
        detailsView.layer.borderColor = UIColor.appDarkTeal.cgColor
        detailsView.layer.cornerRadius = 12
        detailsView.layer.masksToBounds = true
        
        descriptionView.layer.borderWidth = 2
        descriptionView.layer.backgroundColor = UIColor.appLightTeal.cgColor
        descriptionView.layer.borderColor = UIColor.appDarkTeal.cgColor
        descriptionView.layer.cornerRadius = 12
        descriptionView.layer.masksToBounds = true
        
        ingredientsView.layer.borderWidth = 2
        ingredientsView.layer.backgroundColor = UIColor.appLightTeal.cgColor
        
        ingredientsView.layer.borderColor = UIColor.appDarkTeal.cgColor
        ingredientsView.layer.cornerRadius = 12
        ingredientsView.layer.masksToBounds = true
        
        descriptionText.numberOfLines = 0
        descriptionText.lineBreakMode = .byTruncatingTail
        descriptionText.adjustsFontSizeToFitWidth = true
        
        ingredientText.numberOfLines = 0
        ingredientText.lineBreakMode = .byTruncatingTail
        ingredientText.adjustsFontSizeToFitWidth = true
    }
}
