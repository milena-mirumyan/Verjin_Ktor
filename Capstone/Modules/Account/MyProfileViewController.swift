//
//  MyProfileViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 25.04.25.
//

import UIKit

final class MyProfileViewController: UIViewController{
    @IBOutlet weak var editDetails: UIButton!
    @IBOutlet weak var myProfileDetailsView: UIView!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var fullName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfileDetailsView.layer.borderWidth = 2
        myProfileDetailsView.layer.borderColor = UIColor.appDarkTeal.cgColor
        myProfileDetailsView.layer.cornerRadius = 12
        myProfileDetailsView.layer.masksToBounds = true
        myProfileDetailsView.backgroundColor = .appLightTeal
        
        editDetails.layer.cornerRadius = editDetails.frame.height / 2
        editDetails.clipsToBounds = true
        editDetails.setTitleColor(.white, for: .normal)
        editDetails.tintColor = .white
        editDetails.backgroundColor = .appDarkTeal
        
        if let user = AuthenticationService.shared.currentUser {
            fullName.text = "\(user.firstName) \(user.lastName)" 
            email.text = user.email
            mobileNumber.text = user.mobileNumber
        }
        
    }
}
