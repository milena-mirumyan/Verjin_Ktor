//
//  frequentQsCell.swift
//  Capstone
//
//  Created by Milena Mirumyan on 28.04.25.
//

import UIKit

struct FrequentQsItem {
    let question: String
    let answer: String
}

final class FrequentQsCell: UICollectionViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var cell: UIStackView!
    
    func configure(with item: FrequentQsItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.appDarkTeal.cgColor
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        
        cell.backgroundColor = .appLightTeal
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
}
