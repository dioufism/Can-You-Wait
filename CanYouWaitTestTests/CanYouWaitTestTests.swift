//
//  CanYouWaitTestTests.swift
//  CanYouWaitTestTests
//
//  Created by ousmane diouf on 9/18/23.
//

import XCTest
import Combine
@testable import CanYouWait

final class PrimeNumberCheckViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor
    func test_checkNumber_success() async  {
            let viewModel = PrimeNumberCheckViewModel(service: MockPrimeNumberService())
            XCTAssertEqual(viewModel.isPrime, false)
            XCTAssertEqual(viewModel.validationInProgress, false)
        
            _ = await viewModel.checkNumber(3)
                
            XCTAssertEqual(viewModel.isPrime, true)
            XCTAssertEqual(viewModel.validationInProgress, false)
        }
        

    
    func test_checkNumber_failed() async  {

    }
        
    func test_toInteger_success() {
        //Given
        let stringToConvert = "7"
        
        //When
       let  viewModel = PrimeNumberCheckViewModel(service: MockPrimeNumberService())

        // Then
        let result =  viewModel.toInteger(stringToConvert)
        XCTAssertEqual(result, 7)
        
    }
    
    func test_toInteger_with_empty_string() {
        //Given
        let stringToConvert = ""
        
        //When
       let  viewModel = PrimeNumberCheckViewModel(service: MockPrimeNumberService())

        // Then
        let result =  viewModel.toInteger(stringToConvert)
        XCTAssertEqual(result, -1)
    }
    
    func test_toInteger_failed() {
        //Given
        let stringToConvert = "c"
        
        //When
        let viewModel = PrimeNumberCheckViewModel(service: MockPrimeNumberService())

        // Then
        let result =  viewModel.toInteger(stringToConvert)
        XCTAssertEqual(result, -1)
    }
    
    func test_cancelValidation() {
        //Given
        let viewModel = PrimeNumberCheckViewModel(service: MockPrimeNumberService())
        
        //When
        viewModel.cancelValidation()
        
        //Then
        XCTAssertEqual(viewModel.validationInProgress, false)
        XCTAssertEqual(viewModel.status, "checking ready to get started")
    }
}
