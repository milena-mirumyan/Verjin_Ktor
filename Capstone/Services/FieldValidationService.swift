//
//  FieldValidationService.swift
//  Capstone
//
//  Created by Milena Mirumyan on 01.05.25.
//

import Foundation

protocol FieldValidationServiceProtocol {
    func validate(email: String) -> FieldValidationService.Errors?
    func validate(password: String) -> FieldValidationService.Errors?
    func validate(password: String, confirmPassword: String) -> FieldValidationService.Errors?
    func validate(mobileNumber: String) -> FieldValidationService.Errors?
    func validate(firstName: String) -> FieldValidationService.Errors?
    func validate(lastName: String) -> FieldValidationService.Errors?
}

final class FieldValidationService: FieldValidationServiceProtocol {
    func validate(email: String) -> Errors? {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            return .invalidEmail
        }
        
        return nil
    }
    
    func validate(password: String) -> Errors? {
        if password.count < 8 {
            return .tooShort
        }
        if password.count > 64 {
            return .tooLong
        }
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            return .missingUppercase
        }
        if password.rangeOfCharacter(from: .lowercaseLetters) == nil {
            return .missingLowercase
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            return .missingDigit
        }
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=[]{}|\\:;\"'<>,.?/~`")
        if password.rangeOfCharacter(from: specialCharacterSet) == nil {
            return .missingSpecialCharacter
        }
        return nil
        
    }
    
    func validate(password: String, confirmPassword: String) -> Errors? {
        if password != confirmPassword {
            return .passwordMismatch
        }
        
        return nil
    }
    
    func validate(mobileNumber: String) -> Errors? {
        let mobileRegex = "^\\+374[0-9]{8}$"
        let mobilePredicate = NSPredicate(format: "SELF MATCHES[c] %@", mobileRegex)
        if !mobilePredicate.evaluate(with: mobileNumber) {
            return .invalidMobileNumber
        }
        
        return nil
    }
    
    func validate(firstName: String) -> Errors? {
        if isNotValid(name: firstName) {
            return .invalidName
        }
        
        return nil
    }
    
    func validate(lastName: String) -> Errors? {
        if isNotValid(name: lastName) {
            return .invalidLastName
        }
        
        return nil
    }
    
    private func isNotValid(name: String) -> Bool {
        return name.rangeOfCharacter(from: .letters) == nil ||
            !name.allSatisfy({ $0 == " " || $0.isLetter })
    }
}

extension FieldValidationService {
    enum Errors: Swift.Error {
        // validation erros
        case invalidEmail
        case invalidPassword
        case invalidMobileNumber
        case invalidName
        case invalidLastName
        case passwordMismatch
        case tooShort
        case tooLong
        case missingUppercase
        case missingLowercase
        case missingDigit
        case missingSpecialCharacter
        
        var title: String {
            switch self {
            case .invalidEmail:
                return "Invalid email"
            case .invalidPassword:
                return "Invalid password"
            case .passwordMismatch:
                return "Passwords do not match"
            case .tooShort:
                return "Invalid password."
            case .tooLong:
                return "Invalid password"
            case .missingUppercase:
                return "Invalid password"
            case .missingLowercase:
                return "Invalid password"
            case .missingDigit:
                return "Invalid password"
            case .missingSpecialCharacter:
                return "Invalid password"
            case .invalidMobileNumber:
                return "Invalid mobile number"
            case .invalidName:
                return "Invalid Name"
            case .invalidLastName:
                return "Invalid Last Name"
            }
        }
        
        var message: String {
            switch self {
            case .invalidEmail:
                return "Please enter a valid email address."
            case .invalidPassword:
                return "Your password must be at least 8 characters long."
            case .passwordMismatch:
                return "The passwords you entered do not match. Please try again."
            case .tooShort:
                return "Password must be at least 8 characters."
            case .tooLong:
                return "Password must not exceed 64 characters."
            case .missingUppercase:
                return "Password must contain at least one uppercase letter."
            case .missingLowercase:
                return "Password must contain at least one lowercase letter."
            case .missingDigit:
                return "Password must contain at least one digit."
            case .missingSpecialCharacter:
                return "Password must contain at least one special character (e.g., !@#$%)."
            case .invalidMobileNumber:
                return "Please enter a valid mobile number \n (i.e. +37499123456)."
            case .invalidName:
                return "First name must contain at least one letter."
            case .invalidLastName:
                return "Last name must contain at least one letter."
            }
        }
    }
}
