//
//  FoodCollectionViewCell.swift
//  Capstone
//
//  Created by Milena Mirumyan on 30.03.25.
//


import UIKit
import MapKit
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

struct FoodItemModel: Codable {
    let id: String
    let storeImage: String
    let storeNameLabel: String
    let pickUpTime: String
    let price: String
    let originalPrice: String
    var favoriteButton: Bool
    let category: String
    var location: Bool
    let addressSpecific: String
    let shortDecsription: String
    let description: String
    let mysteryPot: [MysteryPotModel]
    let coordinate: Coordinate
    let rating: Double
}

protocol FoodCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: FoodCollectionViewCell, item: FoodItemModel)
}

final class FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var foodItem: FoodItemModel!
    weak var delegate: FoodCollectionViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
        favoriteButton.clipsToBounds = true
        storeImage.clipsToBounds = true
    }
    
    private func updateButtonImage() {
        if let button = favoriteButton {
            if button.isSelected {
                button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
               
            } else {
                button.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton(in: self, item: foodItem)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        favoriteButton.setBackgroundImage(UIImage(), for: .highlighted)
        favoriteButton.setBackgroundImage(UIImage(), for: .selected)
        
        updateButtonImage()
        addShadow(radius: 7, opacity: 0.5)
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 12

        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
        gradientView.gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.gradientLayer.startPoint = .init(x: 0.4, y: 0.4)
        gradientView.gradientLayer.endPoint = .init(x: 1, y: 1)
    }
    
    func configure(with model: FoodItemModel) {
        foodItem = model
        storeImage.image = UIImage(named: model.storeImage)
        storeNameLabel.text = model.storeNameLabel
        descriptionLabel.text = "Pick up at \(model.pickUpTime)"
        favoriteButton.isSelected = model.favoriteButton
        ratingLabel.text = "\(model.rating)"
        
        updateButtonImage()
    }
}
