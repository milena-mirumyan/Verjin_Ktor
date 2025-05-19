//
//  FillingEmailViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 01.05.25.
//

import UIKit

protocol FillingEmailViewInputProtocol: AnyObject {
    func setUpEmailFlow()
    func setUpLoginFlow()
    func setUpRegistrationFlow()
    func setUpHint(message: String)
    
    func showValidationError(error: FieldValidationService.Errors)
    func showAuthError(error: AuthenticationService.Errors)
}

protocol FillingEmailViewOutpuProtocol: AnyObject {
    func viewDidLoad()
    func userDidTapContinue(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        mobileNumber: String,
        confirmPassword: String
    )
}

final class FillingEmailViewController: UIViewController {
    var presenter: FillingEmailViewOutpuProtocol!
        
    @IBOutlet private weak var fillingEmailTextField: UITextField!
    @IBOutlet private weak var fieldStackView: UIStackView!
    @IBOutlet private weak var mobileNumber: UITextField!
    @IBOutlet private weak var lastName: UITextField!
    @IBOutlet private weak var firstName: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var confirmPassword: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var logo: UIImageView!
    @IBOutlet private weak var hintLbael: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.tintColor = .white
        continueButton.accessibilityLabel = "continue_button"
        
        logo.layer.cornerRadius = logo.frame.height / 2
        logo.clipsToBounds = true
        logo.superview?.layer.cornerRadius = logo.frame.height / 2
        logo.superview?.addShadow(radius: 8)
        logo.layer.cornerRadius = logo.frame.height / 2
        logo.clipsToBounds = true
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        fieldStackView.arrangedSubviews.forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
            $0.tintColor = .appDarkTeal
            
            let leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
            ($0 as? UITextField)?.leftView = leftView
            ($0 as? UITextField)?.leftViewMode = .always
        }
        
        dimissOnTap()
        
        fillingEmailTextField.accessibilityLabel = "email_text_field"
        firstName.accessibilityLabel = "first_name_text_field"
        lastName.accessibilityLabel = "last_name_text_field"
        mobileNumber.accessibilityLabel = "mobile_number_text_field"
        password.accessibilityLabel = "password_text_field"
        confirmPassword.accessibilityLabel = "confirm_password_text_field"
        
        presenter.viewDidLoad()
    }
        
    @IBAction func onContinueTapped(_ sender: Any) {
        presenter.userDidTapContinue(
            email: fillingEmailTextField.text ?? "",
            password: password.text ?? "",
            firstName: firstName.text ?? "",
            lastName: lastName.text ?? "",
            mobileNumber: mobileNumber.text ?? "",
            confirmPassword: confirmPassword.text ?? ""
        )
    }
}

extension FillingEmailViewController: FillingEmailViewInputProtocol {
    func setUpEmailFlow() {
        fillingEmailTextField.isHidden = false
        password.isHidden = true
        confirmPassword.isHidden = true
        firstName.isHidden = true
        lastName.isHidden = true
        mobileNumber.isHidden = true
    }
    
    func setUpLoginFlow() {
        fillingEmailTextField.isHidden = true
        password.isHidden = false
        confirmPassword.isHidden = true
        firstName.isHidden = true
        lastName.isHidden = true
        mobileNumber.isHidden = true
    }
    
    func setUpRegistrationFlow() {
        fillingEmailTextField.isHidden = true
        password.isHidden = false
        confirmPassword.isHidden = false
        firstName.isHidden = false
        lastName.isHidden = false
        mobileNumber.isHidden = false
    }
    
    func setUpHint(message: String) {
        hintLbael.text = message
    }
    
    func showValidationError(error: FieldValidationService.Errors) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showAuthError(error: AuthenticationService.Errors) {
        let alert = UIAlertController(
            title: error.title,
            message: error.message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
