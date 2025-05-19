//
//  LoginViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 30.04.25.
//

import UIKit

final class LoginViewController: UIViewController {
    private var isTermsAccepted = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.image = .wallpaper
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.text = "Let's explore the Mystery Pot and Save Food!"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 14
        stack.axis = .vertical
        return stack
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton(type: .custom)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .black
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(systemName: "apple.logo")?.withTintColor(.white)
        configuration.cornerStyle = .capsule
        configuration.title = "Continue with Apple"
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        button.configuration = configuration
        return button
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .custom)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .init(red: 238.0 / 255.0, green: 50.0 / 255.0, blue: 36.0 / 255.0, alpha: 1)
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(named: "google.png")?.imageWith(newSize: .init(width: 20, height: 20))
        configuration.cornerStyle = .capsule
        configuration.title = "Continue with Google"
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        button.configuration = configuration
        return button
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .custom)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .init(white: 0.9, alpha: 1)
        configuration.baseForegroundColor = .black
        configuration.image = UIImage(named: "email.png")?.imageWith(newSize: .init(width: 20, height: 20))
        configuration.cornerStyle = .capsule
        configuration.title = "Continue with Email"
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        button.configuration = configuration
        button.accessibilityLabel = "login_button"
        return button
    }()
    
    private let checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.init(systemName: "square"), for: .normal)
        button.tintColor = MapViewController.tintColor
        button.accessibilityLabel = "checkbox_button"
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("I accept Terms & Conditions", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()
    
    private let termsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .horizontal
        return stack
    }()
    
    private let gradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        view.gradientLayer.startPoint = .init(x: 0.5, y: 0)
        view.gradientLayer.endPoint = .init(x: 0.5, y: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        view.addSubview(termsStack)
        
        buttonsStackView.addArrangedSubview(appleButton)
        buttonsStackView.addArrangedSubview(googleButton)
        buttonsStackView.addArrangedSubview(emailButton)
        
        termsStack.addArrangedSubview(checkBoxButton)
        termsStack.addArrangedSubview(termsButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            
            buttonsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 28),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emailButton.heightAnchor.constraint(equalToConstant: 48),
            
            termsStack.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
            termsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            termsStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        checkBoxButton.addTarget(self, action: #selector(onCheckBoxTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(onTermsButtonTapped), for: .touchUpInside)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc
    private func emailButtonTapped(){
        if checkBoxButton.isSelected {
            let emailVC = FillingEmailRouter.build(flow: .email)
            navigationController?.pushViewController(emailVC, animated: true)
        } else {
            termsStack.shake()
        }
    }
    
    @objc
    private func onCheckBoxTapped() {
        isTermsAccepted.toggle()
        checkBoxButton.isSelected.toggle()
        
        if isTermsAccepted {
            checkBoxButton.setImage(.init(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            checkBoxButton.setImage(.init(systemName: "square"), for: .normal)
        }
    }
    
    @objc
    private func onTermsButtonTapped(){
        if let termsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TCViewController") as? TCViewController {
            navigationController?.pushViewController(termsVC, animated: true)
        }
    }
}
