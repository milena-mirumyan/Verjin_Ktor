//
//  MysteryPotDetailsViewcontroller.swift
//  Capstone
//
//  Created by Milena Mirumyan on 14.04.25.
//

import Foundation
import UIKit

final class MysteryPotDetailsViewcontroller: UIViewController {
    var foodItem: FoodItemModel!
    var mysteryPotItem: MysteryPotModel!
    var isFirstAppear = true

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var minusCount: UIButton!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var plusCount: UIButton!
    @IBOutlet weak var mysteryPotCount: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var countView: UIStackView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tint = UIColor.appDarkTeal
        
        logo.image = UIImage(named: mysteryPotItem.logo)
        logo.superview?.layer.cornerRadius = logo.frame.height / 2
        logo.superview?.addShadow()
        logo.layer.cornerRadius = logo.frame.height / 2
        logo.clipsToBounds = true
        name.text = foodItem.storeNameLabel
        pickUp.text = "Pick Up Today " + foodItem.pickUpTime
        
        count.text = "1"
        mysteryPotCount.text = "Verjin Ktor x " + count.text!
        updateSubtotal()
        
        buyNowButton.layer.cornerRadius = buyNowButton.frame.height / 2
        buyNowButton.clipsToBounds = true
        buyNowButton.backgroundColor = .appDarkTeal
        
        pickUp.numberOfLines = 1
        pickUp.lineBreakMode = .byTruncatingTail 
        pickUp.adjustsFontSizeToFitWidth = true
        
        minusCount.layer.cornerRadius = 20
        minusCount.backgroundColor = tint
        minusCount.setTitleColor(.white, for: .normal)
        minusCount.tintColor = .white

        plusCount.layer.cornerRadius = 20
        plusCount.backgroundColor = tint
        plusCount.setTitleColor(.white, for: .normal)
        plusCount.tintColor = .white
        
        countView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        countView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        countView.layer.cornerRadius = 28
        countView.layer.shadowOpacity = 0.4
        countView.layer.shadowColor = UIColor.black.cgColor
        countView.layer.shadowOffset = CGSize(width: 0, height: 0)
        countView.layer.shadowRadius = 3
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        
        buyNowButton.backgroundColor = tint
        buyNowButton.tintColor = .white
        buyNowButton.setTitleColor(.white, for: .normal)
        
        navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isFirstAppear else { return }
        dividerView.setNeedsLayout()
        dividerView.layoutIfNeeded()
        isFirstAppear = false
        
        let container = verticalStackView.superview!
        container.backgroundColor = .secondarySystemBackground
        container.clipsToBounds = false
        container.layer.masksToBounds = false
        applyZigZagEffect(givenView: container)
        dividerView.addDashedBorder()
    }
    
    @IBAction func plusCountTapped(_ sender: UIButton) {
        let current = Int(count.text ?? "1") ?? 1
        let maxAvailable = mysteryPotItem.count
        
        if current < maxAvailable {
            let updated = current + 1
            count.text = "\(updated)"
            updateSubtotal()
        }
    }
    
    @IBAction func minusCountTapped(_ sender: UIButton) {
        let current = Int(count.text ?? "1") ?? 1
        
        if current > 1 {
            let updated = current - 1
            count.text = "\(updated)"
            updateSubtotal()
        }
    }
    
    func updateSubtotal() {
        guard let item = foodItem else { return }
        
        let quantity = Int(count.text ?? "1") ?? 1
        let price = Int(item.price.replacingOccurrences(of: "$", with: "")) ?? 0
        
        let total = quantity * price
        let shippingFee = 500
        
        subtotalLabel.text = "֏\(shippingFee)"
        viewCount.text = "֏\(price)"
        let totalFee = shippingFee + total
        totalLabel.text = "֏\(totalFee)"
        mysteryPotCount.text = "Mystery Pot x \(quantity)"
    }
    
    @IBAction func detailsButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            detailVC.mysteryItem = mysteryPotItem
            detailVC.foodItem = foodItem
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
        let totalAmount = totalLabel.text!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let buyNow = storyboard.instantiateViewController(withIdentifier: "BuyViewController") as? BuyViewController {
            buyNow.mysteryItem = mysteryPotItem
            buyNow.foodItem = foodItem
            buyNow.paymentAmount = totalAmount
            navigationController?.pushViewController(buyNow, animated: true)
        }
    }
    
    func pathZigZagForView(givenView: UIView) -> UIBezierPath {
        let width = givenView.frame.size.width
        let height = givenView.frame.size.height
        
        let givenFrame = givenView.frame
        let zigZagWidth = givenView.frame.width / 40
        let zigZagHeight = CGFloat(5)
        var yInitial = height-zigZagHeight
        
        let zigZagPath = UIBezierPath(rect: givenFrame.insetBy(dx: 5, dy: 5))
        zigZagPath.move(to: CGPoint(x:0, y:0))
        zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))
        
        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope) - 5
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        
        zigZagPath.addLine(to: CGPoint(x:width,y: 0))
        
        yInitial = 0 + zigZagHeight
        x = CGFloat(width)
        i = 0
        while x > 0 {
            x = width - (zigZagWidth * CGFloat(i))
            let p = zigZagHeight * CGFloat(slope) + 5
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        zigZagPath.close()
        return zigZagPath
    }
    
    func applyZigZagEffect(givenView: UIView) {
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        givenView.backgroundColor = UIColor.clear
        shapeLayer.path = self.pathZigZagForView(givenView: givenView).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.fillColor = UIColor.secondarySystemBackground.cgColor
        shapeLayer.shadowOpacity = 0.4
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 3
        
        givenView.layer.insertSublayer(shapeLayer, at: 0)
    }
}
