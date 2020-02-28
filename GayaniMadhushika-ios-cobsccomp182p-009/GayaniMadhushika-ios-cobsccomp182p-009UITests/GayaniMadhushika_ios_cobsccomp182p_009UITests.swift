//
//  GayaniMadhushika_ios_cobsccomp182p_009UITests.swift
//  GayaniMadhushika-ios-cobsccomp182p-009UITests
//
//  Created by Imali Chathurika on 2/8/20.
//  Copyright © 2020 Gayani Madhushika. All rights reserved.
//

import XCTest

class GayaniMadhushika_ios_cobsccomp182p_009UITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testInvalidLogin(){
        
        
        let app = XCUIApplication()

        app.buttons["Log In"].tap()
        let emailAddressTextField = app.textFields["Email Address"]
        XCTAssertTrue(emailAddressTextField.exists)
        emailAddressTextField.tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        
        let signInButton = app.buttons["Sign In"]
        signInButton.tap()
        
        let alertDialog = app.alerts["Error"]
        XCTAssertTrue(alertDialog.exists)
         app.buttons["OK"].tap()
        
    }
    
    

    func testValidLoginSuccess(){
        
        let validUserName = "test@123.com"
        let validPassword = "welcome@123"
        
        let app = XCUIApplication()
        XCUIApplication().buttons["Log In"].tap()
        
        let userNameTextField = app.textFields["Email Address"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText(validUserName)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(validPassword)
        
        app.buttons["Sign In"].tap()
        
        let okButton = app.alerts["Successful"].buttons["OK"]
        app.buttons["OK"].tap()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
