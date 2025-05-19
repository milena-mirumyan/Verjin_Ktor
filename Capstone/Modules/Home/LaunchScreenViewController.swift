//
//  LaunchScreenViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

import UIKit
import Lottie

final class LaunchScreenViewController: UIViewController {
    let animationView = LottieAnimationView(name: "Artboard 1")
    let coverView = UIView()
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.backgroundColor = .white

        animationView.accessibilityLabel = "launch_screen_animation_view"
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        view.addSubview(coverView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 550),
            animationView.heightAnchor.constraint(equalToConstant: 550),
            
            coverView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -50),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.completion?()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play()
    }
    
}
