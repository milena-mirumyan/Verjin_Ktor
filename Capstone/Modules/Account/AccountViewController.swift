//
//  AccountViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 23.04.25.
//

import UIKit

final class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var accountTableView: UITableView!

    private let authService = AuthenticationService.shared
    private let settingsItems = [
        "My Profile",
        "Rate App",
        "Share App",
        "Help & FAQs",
        "Terms And Conditions",
        "Privacy Policy",
        "Cookies Policy",
        "About Us",
        "Contact Us",
        "Delete Account",
        "Log Out"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Account"
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        var isDestructive = false
        
        switch settingsItems[indexPath.row] {
        case "My Profile":
            cell.imageView?.image = UIImage(systemName: "person.circle.fill")
        case "Rate App":
            cell.imageView?.image = UIImage(systemName: "star.leadinghalf.filled")
        case "Share App":
            cell.imageView?.image = UIImage(systemName: "square.and.arrow.up")
        case "Help & FAQs":
            cell.imageView?.image = UIImage(systemName: "questionmark.circle.fill")
        case "Terms And Conditions":
            cell.imageView?.image = UIImage(systemName: "doc.text.fill")
        case "Privacy Policy":
            cell.imageView?.image = UIImage(systemName: "shield.fill")
        case "Cookies Policy":
            cell.imageView?.image = UIImage(systemName: "lock.shield.fill")
        case "About Us":
            cell.imageView?.image = UIImage(systemName: "info.circle.fill")
        case "Contact Us":
            cell.imageView?.image = UIImage(systemName: "person.2.fill")
        case "Delete Account":
            cell.imageView?.image = UIImage(systemName: "person.fill.xmark")
            isDestructive = true
        default:
            cell.imageView?.image = UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")
            isDestructive = true
        }
        
        cell.textLabel?.text = settingsItems[indexPath.row]
        
        if isDestructive {
            cell.textLabel?.textColor = .appRed
            cell.imageView?.tintColor = .appRed
        } else {
            cell.textLabel?.textColor = .black
            cell.imageView?.tintColor = .appDarkTeal
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = settingsItems[indexPath.row]
        let settings = settingsItems[indexPath.row]
        
        switch settings {
        case "My Profile":
            let rateAppVC = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            rateAppVC.title = settings
            navigationController?.pushViewController(rateAppVC, animated: true)
        case "Terms And Conditions", "Privacy Policy", "Cookies Policy", "About Us", "Contact Us":
            let tcVc = storyboard?.instantiateViewController(withIdentifier: "TCViewController") as! TCViewController
            tcVc.selectedPage = selectedItem
            tcVc.title = settings
            navigationController?.pushViewController(tcVc, animated: true)
        case "Help & FAQs":
            let fqVc = storyboard?.instantiateViewController(withIdentifier: "FrequentQsViewController") as! FrequentQsViewController
            fqVc.title = settings
            navigationController?.pushViewController(fqVc, animated: true)
        case "Rate App":
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1629135515") {
                UIApplication.shared.open(url)
            }
        case "Share App":
            let items: [Any] = ["This app is my favorite", URL(string: "https://www.apple.com")!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        case "Delete Account":
            let alert = UIAlertController(
                title: "Delete Account",
                message: "Are you sure you want to delete your account?",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "Yes", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                try? authService.deleteAccount()
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                sceneDelegate.changeRoot(viewController: loginVC)
            }))
            alert.addAction(.init(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        case "Log Out":
            let alert = UIAlertController(
                title: "Log Out",
                message: "Are you sure you want to log out?",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "Yes", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                authService.logOut()
                sceneDelegate.changeRoot(viewController: loginVC)
            }))
            alert.addAction(.init(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        default:
            break
        }
    }
}
