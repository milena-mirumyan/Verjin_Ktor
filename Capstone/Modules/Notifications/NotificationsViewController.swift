//
//  NotificationsViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

import UIKit

final class NotificationsViewController: UIViewController {
    private let emptyView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var placeholderView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "You don’t have any\nnotifications yet."
        return label
    }()
    private var placeholderImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .lightGray
        image.image = UIImage(systemName: "bell.badge.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 64, weight: .medium)
        )
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(emptyView)
        emptyView.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImage)
        placeholderView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.leadingAnchor, constant: 32),
            placeholderView.topAnchor.constraint(greaterThanOrEqualTo: emptyView.topAnchor, constant: 32),

            placeholderImage.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            placeholderImage.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderImage.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor),
        ])
        
        navigationItem.title = "Notifications"
    }
}
