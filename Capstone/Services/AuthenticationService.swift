//
//  AuthenticationService.swift
//  Capstone
//
//  Created by Milena Mirumyan on 01.05.25.
//

import Foundation

struct User: Codable {
    let email: String
    let mobileNumber: String
    let firstName: String
    let lastName: String
    let password: String
}

protocol AuthenticationServiceProtocol {
    var currentUser: User? { get }
    var isLoggedIn: Bool { get }
    
    func isEmailRegistered(
        email: String
    ) -> Bool
    
    func login(
        email: String,
        password: String
    ) throws(AuthenticationService.Errors)
    
    func register(
        email: String,
        password: String,
        mobileNumber: String,
        firstName: String,
        lastName: String
    ) throws(AuthenticationService.Errors)
    
    func logOut()
}

final class AuthenticationService: AuthenticationServiceProtocol {
    static let shared = AuthenticationService()
    static let usersKey = "users"
    static let currentUserKey = "current_user"
    
    private init() { }
    private let keychainService: KeychainService = .default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private(set) var currentUser: User? {
        get {
            if let userData = keychainService.data(forKey: Self.currentUserKey),
               let currentUser = try? decoder.decode(User.self, from: userData) {
                return currentUser
            }
            
            return nil
        }
        
        set {
            if let newValue {
                let userData = try! encoder.encode(newValue)
                keychainService.set(userData, forKey: Self.currentUserKey)
            } else {
                keychainService.removeObject(forKey: Self.currentUserKey)
            }
        }
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func isEmailRegistered(email: String) -> Bool {
        if let usersData = keychainService.data(forKey: Self.usersKey),
           let users = try? decoder.decode([String: User].self, from: usersData) {
            if users[email] != nil{
                return true
            }
        }
        return false
    }
    
    func login(email: String, password: String) throws(Errors) {
        if let usersData = keychainService.data(forKey: Self.usersKey),
           let users = try? decoder.decode([String: User].self, from: usersData) {
            if let user = users[email] {
                if user.password == password {
                    currentUser = user
                    StorageService.shared.favoritesKeychain()
                } else{
                    throw Errors.wrongPassword
                }
            } else {
                throw Errors.userNotFound
            }
        } else{
            throw Errors.userNotFound
        }
    }
    
    func register(email: String, password: String, mobileNumber: String, firstName: String, lastName: String) throws(Errors) {
        let newUsers: [String: User]
        let user = User(
            email: email,
            mobileNumber: mobileNumber,
            firstName: firstName,
            lastName: lastName,
            password: password
        )
        
        if let usersData = keychainService.data(forKey: Self.usersKey),
           var users = try? decoder.decode([String: User].self, from: usersData) {
            if users[email] == nil{
                users[email] = user
                newUsers = users
            } else {
                throw Errors.userExists
            }
        } else {
            newUsers = [
                email: user
            ]
        }
        
        if let newUsersData = try? encoder.encode(newUsers) {
            keychainService.set(newUsersData, forKey: Self.usersKey)
        }
        
        currentUser = user
        StorageService.shared.favoritesKeychain()
    }
    
    func deleteAccount() throws(Errors) {
        guard let currentUser else { throw Errors.userNotFound }
        
        if let usersData = keychainService.data(forKey: Self.usersKey),
           var users = try? decoder.decode([String: User].self, from: usersData) {
            if users[currentUser.email] == nil {
                throw Errors.userNotFound
            } else {
                users[currentUser.email] = nil
                
                if let newUsersData = try? encoder.encode(users) {
                    keychainService.set(newUsersData, forKey: Self.usersKey)
                }
            }
        } else {
            throw Errors.userNotFound
        }
        
        logOut()
    }
    
    func logOut() {
        currentUser = nil
        StorageService.shared.favoritesKeychain()
    }
}

extension AuthenticationService {
    enum Errors: Swift.Error {
        // login erros
        case userNotFound
        case wrongPassword
        
        // registration errors
        case userExists
        
        var title: String {
            switch self {
            case .userNotFound:
                return "User not found"
            case .wrongPassword:
                return "Wrong password"
            case .userExists:
                return "User already exists"
            }
        }
        
        var message: String {
            switch self{
            case .userNotFound:
                return "Please, enter correct password"
            case .wrongPassword:
                return "Please, enter correct password"
            case .userExists:
                return "User already exists"
                
            }
        }
    }
}


extension AuthenticationService {
    func saveUserInfo(firstName: String, lastName: String, mobileNumber: String) {
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
    }
    
    func getUserInfo() -> (firstName: String?, lastName: String?, mobileNumber: String?) {
        let firstName = UserDefaults.standard.string(forKey: "firstName")
        let lastName = UserDefaults.standard.string(forKey: "lastName")
        let mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber")
        
        return (firstName, lastName, mobileNumber)
    }
}
