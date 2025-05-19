//
//  FillingEmailInteractor.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

protocol FillingEmailInteractorInputProtocol: AnyObject {
    var flow: FillingEmailViewFlow { get }
    var email: String { get }

    func isEmailRegistered() -> Bool
    func register() -> AuthenticationService.Errors?
    func login() -> AuthenticationService.Errors?
    func validate(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        mobileNumber: String,
        confirmPassword: String
    ) -> FieldValidationService.Errors?
}

protocol FillingEmailInteractorOutputProtocol: AnyObject { }

final class FillingEmailInteractor {
    weak var presenter: FillingEmailInteractorOutputProtocol!
    
    private let authService: AuthenticationServiceProtocol
    private let validationService: FieldValidationServiceProtocol
    private(set) var flow: FillingEmailViewFlow = .email
    private(set) var email = ""
    private var password = ""
    private var firstName = ""
    private var lastName = ""
    private var mobileNumber = ""
    private var confirmPassword = ""
    
    init(
        flow: FillingEmailViewFlow,
        email: String = "",
        authService: AuthenticationServiceProtocol,
        validationService: FieldValidationServiceProtocol
    ) {
        self.flow = flow
        self.email = email
        self.authService = authService
        self.validationService = validationService
    }
}

extension FillingEmailInteractor: FillingEmailInteractorInputProtocol {
    func isEmailRegistered() -> Bool {
        authService.isEmailRegistered(email: email)
    }
    
    func validate(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        mobileNumber: String,
        confirmPassword: String
    ) -> FieldValidationService.Errors? {
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.confirmPassword = confirmPassword
        
        var errors = [FieldValidationService.Errors]()
        
        switch flow {
        case .email:
            self.email = email
            if let error = validationService.validate(email: email) {
                errors.append(error)
            }
        case .login:
            if let error = validationService.validate(password: password) {
                errors.append(error)
            }
        case .registration:
            if let error = validationService.validate(firstName: firstName) {
                errors.append(error)
            }
            if let error = validationService.validate(lastName: lastName) {
                errors.append(error)
            }
            if let error = validationService.validate(mobileNumber: mobileNumber) {
                errors.append(error)
            }
            if let error = validationService.validate(password: password) {
                errors.append(error)
            }
            if let error = validationService.validate(password: password, confirmPassword: confirmPassword) {
                errors.append(error)
            }
        }
        
        return errors.first
    }
    
    func register() -> AuthenticationService.Errors? {
        do {
            try authService.register(
                email: email,
                password: password,
                mobileNumber: mobileNumber,
                firstName: firstName,
                lastName: lastName
            )
        } catch {
            return error
        }
        
        return nil
    }
    
    func login() -> AuthenticationService.Errors? {
        do {
            try authService.login(
                email: email,
                password: password
            )
        } catch {
            return error
        }
        
        return nil
    }
}
