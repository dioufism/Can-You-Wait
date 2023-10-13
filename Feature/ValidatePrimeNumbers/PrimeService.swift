//
//  PrimeService.swift
//  CanYouWait
//
//  Created by ousmane diouf on 9/18/23.
//

import Foundation

protocol PrimeServiceProtocol {
    func checkNumber(_ number: Int) async throws -> Bool
}

class PrimeService: PrimeServiceProtocol {
    func checkNumber(_ number: Int) async throws -> Bool {
        try await _checkNumber(number)
    }
}

// Do not modify.
private extension PrimeService {
    /// This function could certainly run synchronously; however, by making it
    /// `async throws`, we intend to simulate a network request.
    func _checkNumber(_ number: Int) async throws -> Bool {
        let result = Self.testPrime(number)

        // wait a little bit before returning
        let nanos = Double.random(in: 0.75...3.5) * Double(1_000_000_000)
        try await Task.sleep(nanoseconds: UInt64(nanos))
        try Self.maybeThrowError()

        return result
    }

    static func maybeThrowError() throws {
        // throw an error 15% of the time
        if Int.random(in: 1...100) <= 15 {
            switch Int.random(in: 1...3) {
            case 1:
                throw URLError(.badServerResponse)
            case 2:
                throw URLError(.dnsLookupFailed)
            default:
                throw URLError(.cannotFindHost)
            }
        }
    }

    static func testPrime(_ number: Int) -> Bool {
        // core logic
        guard number != 2 else { return true }
        guard number >= 2, number % 2 != 0 else { return false }
        let isPrime = !stride(from: 3, through: Int(sqrt(Double(number))), by: 2)
            .contains { number % $0 == 0 }

        return isPrime
    }
}
