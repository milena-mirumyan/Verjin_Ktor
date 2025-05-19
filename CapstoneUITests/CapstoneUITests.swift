//
//  CapstoneUITests.swift
//  CapstoneUITests
//
//  Created by Milena Mirumyan on 24.03.25.
//

import XCTest

final class CapstoneUITests: XCTestCase {

    @MainActor
    func testRegistrationSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        // wait for animation
        XCTAssertTrue(app.otherElements["launch_screen_animation_view"].waitForExistence(timeout: 1))
        
        let loginButton = app.buttons["login_button"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        
        loginButton.tap()
        let continueButton = app.buttons["continue_button"]
        XCTAssertFalse(continueButton.exists)
        
        let checkBoxButton = app.buttons["checkbox_button"]
        checkBoxButton.tap()
        loginButton.tap()
        XCTAssertTrue(continueButton.exists)
        
        let emailTextField = app.textFields["email_text_field"]
        emailTextField.tap()
        emailTextField.typeText(UUID().uuidString.replacingOccurrences(of: "-", with: "") + "@test.com")
        
        continueButton.tap()
        
        let firstNameTextField = app.textFields["first_name_text_field"]
        firstNameTextField.tap()
        firstNameTextField.typeText("Test")
        
        let lastNameTextField = app.textFields["last_name_text_field"]
        lastNameTextField.tap()
        lastNameTextField.typeText("User")
        
        let mobileNumberTextField = app.textFields["mobile_number_text_field"]
        mobileNumberTextField.tap()
        mobileNumberTextField.typeText("+37499123456")
                
        let passwordTextField = app.secureTextFields["password_text_field"]
        passwordTextField.tap()
        passwordTextField.typeText("Milena_123")
        
        let cpasswordTextField = app.secureTextFields["confirm_password_text_field"]
        cpasswordTextField.tap()
        cpasswordTextField.typeText("Milena_123")
        
        continueButton.tap()
        continueButton.tap()

        let home = app.otherElements["home"]
        XCTAssertTrue(home.waitForExistence(timeout: 2))
    }
}
