//
//  FillingEmailInteractorTests.swift
//  Capstone
//
//  Created by Milena Mirumyan on 24.03.25.
//

import Testing
@testable import Capstone

struct FillingEmailInteractorTests {
    var authenticationService: AuthenticationServiceMock!
    var validationService: FieldValidationService!
    var presenter: FillingEmailIPresenterMock!
    var interactor: FillingEmailInteractor!
    
    
    init() async throws {
        authenticationService = .init()
        validationService = .init()
        presenter = .init()
    }
    
    @Test func isEmailRegistererd() async throws {
        // Given
        let interactor = FillingEmailInteractor(
            flow: .email,
            authService: authenticationService,
            validationService: validationService
        )
        authenticationService.isRegisteredResult = true
        
        // When
        var result = interactor.isEmailRegistered()
        
        // Then
        #expect(result == true)
        
        // When
        authenticationService.isRegisteredResult = false
        result = interactor.isEmailRegistered()
        
        // Then
        #expect(result == false)
    }
    
    @Test func validateEmailFlow() async throws {
        // Given
        let interactor = FillingEmailInteractor(
            flow: .email,
            authService: authenticationService,
            validationService: validationService
        )
        
        // When
        var result = interactor.validate(
            email: "",
            password: "",
            firstName: "",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .invalidEmail)
        
        // When
        result = interactor.validate(
            email: "aaa@aaa.aaa",
            password: "",
            firstName: "",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == nil)
    }
    
    @Test func validateLoginFlow() async throws {
        // Given
        let interactor = FillingEmailInteractor(
            flow: .login,
            authService: authenticationService,
            validationService: validationService
        )
        
        // When
        var result = interactor.validate(
            email: "",
            password: "",
            firstName: "",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .tooShort)
        
        // When
        result = interactor.validate(
            email: "",
            password: "Milena_123",
            firstName: "",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == nil)
    }
    
    
    @Test func validateRegistrationFlow() async throws {
        // Given
        let interactor = FillingEmailInteractor(
            flow: .registration,
            authService: authenticationService,
            validationService: validationService
        )
        
        // When
        var result = interactor.validate(
            email: "",
            password: "",
            firstName: "",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .invalidName)
        
        // When
        result = interactor.validate(
            email: "",
            password: "",
            firstName: "John",
            lastName: "",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .invalidLastName)
        
        // When
        result = interactor.validate(
            email: "",
            password: "",
            firstName: "John",
            lastName: "Lenon",
            mobileNumber: "",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .invalidMobileNumber)
        
        // When
        result = interactor.validate(
            email: "",
            password: "",
            firstName: "John",
            lastName: "Lenon",
            mobileNumber: "+37499123456",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .tooShort)
        
        // When
        result = interactor.validate(
            email: "",
            password: "",
            firstName: "John",
            lastName: "Lenon",
            mobileNumber: "+37499123456",
            confirmPassword: "Milena_123"
        )
        
        // Then
        #expect(result == .tooShort)
        
        // When
        result = interactor.validate(
            email: "",
            password: "Milena_123",
            firstName: "John",
            lastName: "Lenon",
            mobileNumber: "+37499123456",
            confirmPassword: ""
        )
        
        // Then
        #expect(result == .passwordMismatch)
        
        // Then
        #expect(result == .passwordMismatch)
        
        // When
        result = interactor.validate(
            email: "",
            password: "Milena_123",
            firstName: "John",
            lastName: "Lenon",
            mobileNumber: "+37499123456",
            confirmPassword: "Milena_123"
        )
        
        // Then
        #expect(result == nil)
    }

    
}


final class AuthenticationServiceMock: AuthenticationServiceProtocol {
    var currentUser: Capstone.User?
    var isLoggedIn = false
    var isRegisteredResult = false
    var loginResult: Capstone.AuthenticationService.Errors?
    var registerResult: Capstone.AuthenticationService.Errors?

    func isEmailRegistered(email: String) -> Bool {
        isRegisteredResult
    }
    
    func login(email: String, password: String) throws(Capstone.AuthenticationService.Errors) {
        if let loginResult {
            throw loginResult
        }
    }
    
    func register(email: String, password: String, mobileNumber: String, firstName: String, lastName: String) throws(Capstone.AuthenticationService.Errors) {
        if let registerResult {
            throw registerResult
        }
    }
    
    func logOut() { }
}

final class FillingEmailIPresenterMock: FillingEmailInteractorOutputProtocol { }
