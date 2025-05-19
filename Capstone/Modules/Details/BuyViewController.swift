//
//  BuyViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 30.04.25.
//

import UIKit
final class BuyViewController: UIViewController{
    
    var foodItem: FoodItemModel!
    var mysteryItem: MysteryPotModel!
    var paymentAmount: String = ""
    
    @IBOutlet weak var amountToPay: UIButton!
    @IBOutlet weak var cardType: UIButton!
    @IBOutlet weak var applePay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountToPay.layer.cornerRadius = amountToPay.frame.height / 2
        amountToPay.clipsToBounds = true
        
        cardType.layer.cornerRadius = amountToPay.frame.height / 2
        cardType.clipsToBounds = true
        cardType.setImage(UIImage(systemName: "creditcard.fill"), for: .normal)
        cardType.tintColor = .white
        
        applePay.layer.cornerRadius = amountToPay.frame.height / 2
        applePay.clipsToBounds = true
        applePay.setTitleColor(.white, for: .normal)
        applePay.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        applePay.tintColor = .white
        
        amountToPay.setTitleColor(.white, for: .normal)
        amountToPay.setTitle("Amount to pay: \(paymentAmount)", for: .normal)
        amountToPay.isUserInteractionEnabled = false
        cardType.setTitleColor(.white, for: .normal)
        
        cardType.setTitle("  Credit/Debit Cards", for: .normal)
        applePay.setTitle("  Buy with Apple Pay", for: .normal)
    }
}
