//
//  FieldValidationTests.swift
//  CapstoneTests
//
//  Created by Milena Mirumyan on 24.03.25.
//

import Testing
@testable import Capstone

struct FieldValidationTests {
    var validator: FieldValidationService!
    
    init() {
        validator = FieldValidationService()
    }
    
    @Test func emailValidationEmpty() async throws {
        // Given
        let email = ""
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == .invalidEmail)
    }
    
    @Test func emailValidationMalformed1() async throws {
        // Given
        let email = "a"
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == .invalidEmail)
    }
    
    @Test func emailValidationMalformed2() async throws {
        // Given
        let email = "a@a"
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == .invalidEmail)
    }
    
    @Test func emailValidationMalformed3() async throws {
        // Given
        let email = "a@a.a"
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == .invalidEmail)
    }
    
    @Test func emailValidationMalformed4() async throws {
        // Given
        let email = ".a@a.a"
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == .invalidEmail)
    }
    
    @Test func emailValidationSuccess1() async throws {
        // Given
        let email = "a@aa.aa"
        
        // When
        let result = validator.validate(email: email)
        
        // Then
        #expect(result == nil)
    }
}
