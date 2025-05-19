//
//  MysteryPotCollectionViewCell.swift
//  Capstone
//
//  Created by Milena Mirumyan on 13.04.25.
//


import UIKit

struct MysteryPotModel: Codable {
    let potImage: String
    let logo: String
    let count: Int
    let price: String
    let originalPrice: String
    let description: String
    let ingredients: String
    let dietPreference: String
//    let shortDescription: String
//    let descriptionDetails: String
}


class MysteryPotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mysteryImage: UIImageView!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var count: UILabel!
    
    func configure(with model: MysteryPotModel) {
        mysteryImage.image =  UIImage(named: model.potImage)
        count.text = "\(model.count) items left"
        price.text = "֏\(model.price)"
        let attributedString = NSAttributedString(
            string: "֏\(model.originalPrice)",
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.appRed,
                .foregroundColor: UIColor.appRed
            ]
        )
        originalPrice.attributedText = attributedString
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 3
        layer.borderColor = UIColor.appLightTeal.cgColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
