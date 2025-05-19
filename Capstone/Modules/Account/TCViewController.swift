//
//  TCViewController.swift
//  Capstone
//
//  Created by Milena Mirumyan on 25.04.25.
//


import UIKit

class TCViewController: UIViewController{
    @IBOutlet weak var nameOfPage: UILabel!
    @IBOutlet weak var intro: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    
    var selectedPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let page = selectedPage {
            configurePage(for: page)
        }
        
        let contentView = (view.subviews.first?.subviews.first?.subviews.first)!
        contentView.addShadow(radius: 6)
        contentView.layer.cornerRadius = 4
    }
    
    private func configurePage(for page: String) {
        switch page {
        case "Terms And Conditions":
            nameOfPage.text = "Terms and Conditions"
            intro.text = "Welcome to our Terms and Conditions."
            fullDescription.text = "Welcome to Verjin Ktor. By accessing or using our mobile application, you agree to the following terms and conditions, which govern your use of the platform. Verjin Ktor provides a service that allows users to purchase surplus food items from local bakeries, cafes, and restaurants at reduced prices. When you place an order, you understand that the contents of the item—called a “mystery pot”—are not disclosed in advance and may differ in type, quantity, and appearance from what you might expect. Because our goal is to help reduce food waste, all items are offered on an as-is basis and are final sale. No refunds or exchanges will be made unless the product is proven to be unsafe or spoiled at the time of pickup. Users are responsible for arriving within the designated time window set by the store, as late pickups may result in cancellation without refund. \nVerjin Ktor does not produce, handle, or prepare the food items itself. We act only as a digital bridge between users and participating businesses. All food safety responsibilities lie with the vendors, though we carefully select our partners to ensure quality and reliability. By using the app, you agree to treat store staff respectfully and comply with their rules. Misuse of the platform, including repeated no-shows, misuse of features, or inappropriate behavior, may result in temporary or permanent account suspension. Verjin Ktor reserves the right to update these terms at any time. Continued use of the app after changes implies acceptance, so we recommend reviewing this section regularly."
        case "Privacy Policy":
            nameOfPage.text = "Privacy Policy"
            intro.text = "Your privacy matters to us."
            fullDescription.text = "At Verjin Ktor, your privacy is not just a priority, it’s a promise. We only collect data necessary to provide the services you’ve come to expect from us. This includes your name, phone number, email address, delivery or pickup region (based on location services), and your order history. We use this data to display relevant food offers, manage your orders, and provide notifications or promotions related to your activity. Your data also helps us improve our services by understanding user behavior patterns and preferences.We do not sell or rent your information to third parties. We only share limited, essential data with trusted service providers, such as payment processors or analytics platforms—and only for operational purposes. All personal information is stored securely, with encryption and strict access control to prevent misuse or loss. You have full control over your data. At any time, you can contact us to request access, correction, or permanent deletion of your personal details. Using Verjin Ktor means you consent to the collection and use of your information as described in this policy. If our privacy practices change, we will inform you within the app and provide an updated version of this policy."
        case "Cookies Policy":
            nameOfPage.text = "Cookies Policy"
            intro.text = "Learn about our use of cookies."
            fullDescription.text = "At this moment, Verjin Ktor does not use cookies or any form of tracking technologies. We believe in providing a simple, transparent, and privacy-friendly experience. No data from your device is stored for analytics, advertising, or personalization purposes. If this changes in the future—for example, to improve app performance or offer more tailored content—we will notify you clearly and request your consent before any such features are activated. Until then, you can enjoy using Verjin Ktor without any background data collection or tracking."
        case "About Us":
            nameOfPage.text = "About Us"
            intro.text = "What isMystery Pot?"
            fullDescription.text = "Verjin Ktor, which translates to “Last Bite,” is more than just a food app, it’s a movement. Our mission is to tackle food waste while making fresh, high-quality meals accessible and affordable for everyone. Every day, restaurants, bakeries, and cafes prepare food that doesn’t get sold. Instead of letting these perfectly good items go to waste, Verjin Ktor steps in to connect them with users like you, who are excited to rescue them at a great price. Our app gives you access to “mystery pots”, which are surprise bags filled with surplus meals or baked goods prepared by local businesses. You won’t know exactly what’s inside, but you can be sure it’s fresh, delicious, and made with care. In return, you pay a fraction of the original price and help build a sustainable food system in your community. Verjin Ktor proudly partners with food spots that share our vision of reducing waste, supporting the local economy, and protecting the environment. Each order you place has an impact. You help a small business recover some of its losses, prevent perfectly edible food from ending up in the trash, and get to enjoy something tasty and unexpected. Verjin Ktor brings this global idea home, with a focus on local culture, hospitality, and trust. Together, we’re creating a future where nothing good is wasted."
        case "Contact Us":
            nameOfPage.text = "Contact Us"
            intro.text = "If you have any concerns or suggestions please send an email to our email address:"
            fullDescription.text = "mysterypot@milena.com"
        default:
            nameOfPage.text = "Information"
            intro.text = "More details coming soon."
            fullDescription.text = "No information available yet for this page."
        }
    }
}

