//
//  CategoryCollectionViewCell.swift
//  Capstone
//
//  Created by Milena Mirumyan on 07.04.25.
//

import UIKit

struct CategoryItemModel {
    let categoryName: String
    var iconName: String
    var isSelected: Bool
}

protocol CategoryCellDelegate: AnyObject {
    func categoryCellDidSelectCategory(categoryName: String)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func configure(with model: CategoryItemModel) {
        categoryLabel.text = model.categoryName
        selectionButton.isSelected = model.isSelected
        
        if let image = UIImage(systemName: model.iconName) {
            selectionButton.setImage(image, for: .normal)
        } else {
            selectionButton.setImage(UIImage(named: model.iconName)?.imageWith(newSize: .init(width: 36, height: 36)), for: .normal)
        }
        
        if model.isSelected {
            selectionButton.backgroundColor = .appLightTeal
        } else {
            selectionButton.backgroundColor = UIColor.clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = selectionButton.frame.size.width
        selectionButton.layer.cornerRadius =  buttonWidth / 2
        selectionButton.clipsToBounds = true
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.categoryCellDidSelectCategory(categoryName: categoryLabel.text ?? "")
    }
}
