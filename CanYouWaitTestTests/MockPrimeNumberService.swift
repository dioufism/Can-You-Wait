//
//  MockPrimeNumberService.swift
//  ChickFilA_takeHomeTestTests
//
//  Created by ousmane diouf on 9/25/23.
//

import Foundation
@testable import CanYouWaitTest

class MockPrimeNumberService: PrimeServiceProtocol  {
    
    func checkNumber(_ number: Int) async throws -> Bool{        
        // Check if the number is less than 2
        if number <= 1 {
            return false
        }
        
        // Check for divisibility from 2 to the square root of the number
        for i in 2..<Int(Double(number).squareRoot()) + 1 {
            if number % i == 0 {
                return false
            }
        }
        return true
        
    }
}

