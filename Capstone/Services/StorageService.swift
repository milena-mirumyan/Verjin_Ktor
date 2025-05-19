//
//  StorageService.swift
//  Capstone
//
//  Created by Milena Mirumyan on 01.05.25.
//

import UIKit
import CoreLocation

final class StorageService {
    static let shared = StorageService()
    private init() { }
    private let authService = AuthenticationService.shared
    private let keychainService: KeychainService = .default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private(set) var updateBlocks = [ObjectIdentifier: (([FoodItemModel]) -> ())]()
    private(set) var items = StorageService.foodItems
    
    func subscribe(subscriber: AnyObject, perform: @escaping ([FoodItemModel]) -> ()) {
        updateBlocks[ObjectIdentifier(subscriber)] = perform
        perform(items)
    }
    
    func update(id: String, isFavorite: Bool) {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        items[index].favoriteButton = isFavorite
        
        if let email = authService.currentUser?.email {
            let favoriteIDs = items.filter { $0.favoriteButton }.map { $0.id }
            saveFavoritesToKeychain(for: email, favoriteIDs: favoriteIDs)
        }
        
        for updateBlock in updateBlocks.values {
            updateBlock(items)
        }
    }
    private func saveFavoritesToKeychain(for email: String, favoriteIDs: [String]) {
        guard let data = try? encoder.encode(favoriteIDs) else {
            return
        }
        keychainService.set(data, forKey: "favorites_\(email)")
    }
    
    private func loadFavoritesFromKeychain(for email: String) -> [String]? {
        guard let data = keychainService.data(forKey: "favorites_\(email)"),
              let ids = try? decoder.decode([String].self, from: data) else {
            return nil
        }
        return ids
    }
    
    func favoritesKeychain() {
        guard let email = authService.currentUser?.email, !email.isEmpty else { return }
        
        let savedIDs = loadFavoritesFromKeychain(for: email)
        
        for i in items.indices {
            // ✅ Mark true only if ID is in savedIDs, else false
            items[i].favoriteButton = savedIDs?.contains(items[i].id) ?? false
        }
        
        for updateBlock in updateBlocks.values {
            updateBlock(items)
        }
        
    }
}

extension StorageService {
    static let foodItems: [FoodItemModel] = {
        guard let url = Bundle.main.url(forResource: "expanded_food_items", withExtension: "json") else {
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return []
        }
        
        guard let items = try? JSONDecoder().decode([FoodItemModel].self, from: data) else {
            return []
        }
        
        return items
    }()
    
//    static let foodItems = [
//        FoodItemModel(
//            id: "1",
//            storeImage: UIImage(named: "bagel_4_3")!,
//            storeNameLabel: "Prepa",
//            pickUpTime: "19:41 - 22:41",
//            //  count: 3,
//            price: "20$",
//            originalPrice: "30$",
//            favoriteButton: false,
//            category: "Burger",
//            location: false,
//            addressSpecific: "Abovyan street 40",
//            shortDecsription: "Bakery",
//            description: "jdnvwoenm",
//            mysteryPot: [
//                MysteryPotModel(
//                    potImage: UIImage(named: "bagel_4_3")!,
//                    logo: UIImage(named: "bagel_4_3")!,
//                    count: 5,
//                    price: "15$",
//                    originalPrice: "25$",
//                    description: "This is a special mystery pot for today!",
//                    ingredients: "Bagels, Salmon, Lettuce",
//                    dietPreference: "For All",
//                    shortDescription: "Freshly made",
//                    descriptionDetails: "Prepa's mystery pot is a mix of healthy, tasty ingredients perfect for all diets."
//                )
//            ],
//            coordinate: CLLocationCoordinate2D(latitude: 40.1792, longitude: 44.4991) // <- Yerevan example
//        ),
//        
//        FoodItemModel(
//            id: "2",
//            storeImage: UIImage(named: "bagel_4_3")!,
//            storeNameLabel: "Nudibranch Athens",
//            pickUpTime: "19:41 - 22:41",
//            //    count: "5 items left",
//            price: "20$",
//            originalPrice: "25$",
//            favoriteButton: false,
//            category: "Pizza",
//            location: false,
//            addressSpecific: "Abovyan street 40",
//            shortDecsription: "Bakery",
//            description: "jdnvwoenm",
//            mysteryPot: [
//                MysteryPotModel(
//                    potImage: UIImage(named: "bagel_4_3")!,
//                    logo: UIImage(named: "bagel_4_3")!,
//                    count: 3,
//                    price: "18$",
//                    originalPrice: "28$",
//                    description: "A mystery pot with a surprising twist!",
//                    ingredients: "Cheese, Tomato, Basil",
//                    dietPreference: "Vegetarian",
//                    shortDescription: "Italian style",
//                    descriptionDetails: "This mystery pot is a creative take on a classic pizza, perfect for vegetarian diets."
//                )
//            ],
//            coordinate: CLLocationCoordinate2D(latitude: 40.187953, longitude: 44.516621)
//        ),
//        
//        FoodItemModel(
//            id: "3",
//            storeImage: UIImage(named: "bagel_4_3")!,
//            storeNameLabel: "Nudibranch Athens",
//            pickUpTime: "19:41 - 22:41",
//            //  count: "5 items left",
//            price: "20$",
//            originalPrice: "25$",
//            favoriteButton: false,
//            category: "Pizza",
//            location: false,
//            addressSpecific: "Abovyan street 40",
//            shortDecsription: "Bakery",
//            description: "jdnvwoenm",
//            mysteryPot: [
//                MysteryPotModel(
//                    potImage: UIImage(named: "bagel_4_3")!,
//                    logo: UIImage(named: "bagel_4_3")!,
//                    count: 7,
//                    price: "22$",
//                    originalPrice: "30$",
//                    description: "Spicy and flavorful mystery pot!",
//                    ingredients: "Peppers, Onions, Chicken",
//                    dietPreference: "Vegan",
//                    shortDescription: "Spicy mix",
//                    descriptionDetails: "Packed with flavor, this mystery pot features spicy ingredients and a rich mix."
//                )
//            ],
//            coordinate: CLLocationCoordinate2D(latitude: 40.187378, longitude: 44.516240)
//        ),
//        
//        FoodItemModel(
//            id: "4",
//            storeImage: UIImage(named: "bagel_4_3")!,
//            storeNameLabel: "Nudibranch Athens",
//            pickUpTime: "19:41 - 22:41",
//            //  count: "5 items left",
//            price: "20$",
//            originalPrice: "25$",
//            favoriteButton: false,
//            category: "Pizza",
//            location: false,
//            addressSpecific: "Abovyan street 40",
//            shortDecsription: "Bakery",
//            description: "jdnvwoenm",
//            mysteryPot: [
//                MysteryPotModel(
//                    potImage: UIImage(named: "bagel_4_3")!,
//                    logo: UIImage(named: "bagel_4_3")!,
//                    count: 3,
//                    price: "25$",
//                    originalPrice: "35$",
//                    description: "A gourmet mystery pot for food lovers!",
//                    ingredients: "Truffle Oil, Parmesan, Arugula",
//                    dietPreference: "For All",
//                    shortDescription: "Luxury mix",
//                    descriptionDetails: "A rich and indulgent mystery pot designed for true food connoisseurs."
//                )
//            ],
//            coordinate: CLLocationCoordinate2D(latitude: 40.190651, longitude: 44.514019)
//        )
//    ]
}
