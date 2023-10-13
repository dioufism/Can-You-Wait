//
//  PrimeNumberCheckViewModel.swift
//  CanYouWait
//
//  Created by ousmane diouf on 9/18/23.
//

/* Improvements
 * capture cancelation of a task and display alertbox
 * can use task group or dispatch group to wait for all task to complete
 *
 */

import SwiftUI

protocol PrimeNumberCheckProtocol : ObservableObject {
    func checkNumber(_ number: Int) async 
}

final class PrimeNumberCheckViewModel: PrimeNumberCheckProtocol {
    @Published private(set) var validationInProgress =  false
    @Published var status = "checking ready to get started"
    @Published private(set)var isPrime: Bool = false
    
    private let service: PrimeServiceProtocol
    private var validationTask: Task<Void, Never>?
    private var validationTaskGroup: TaskGroup<Void>?
    
    init(service: PrimeServiceProtocol) {
        self.service = service
    }
    
    func checkWithThrowingTask(_ number: Int) async {

    }

    
    @MainActor
    func checkWithTaskGroup(_ number: Int) async {
        self.validationInProgress = true
        self.status = "Checking \(number) in progress"
        
        validationTaskGroup?.addTask {
            var res = false

            do {
                res = try await self.service.checkNumber(number)
                
                self.updateStatus(res, number)
                
                self.isPrime = res
            } catch {
                //TODO: handle error scenario case
                print(error)
            }
        }
        
    }
    
    @MainActor
    func checkNumber(_ number: Int) async {
        self.validationInProgress = true
        self.status = "Checking \(number) in progress"
        
        
        validationTask = Task {
            var res = false

            do {
                res = try await service.checkNumber(number)
                
                updateStatus(res, number)
                
                self.isPrime = res
            } catch {
                //TODO: handle error scenario case
                print(error)
            }
            self.validationInProgress = false
        }
        
        await withTaskCancellationHandler(operation: {
            _ =  await validationTask?.value
        }, onCancel: {
            validationTask?.cancel()
        })
    }
    
    private func updateStatus(_ status: Bool, _ number: Int) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.status = "Enter a number"
                self.isPrime =  false
        }
        
        if status {
            self.status =  "\(number) is Prime"
        } else {
            self.status =  "\(number) is not Prime"
        }
    }
    
     func toInteger(_ input: String?) -> Int {
        if let intValue = Int(input ?? "") {
            return intValue
        } else {
            return -1
        }
    }
    
    func cancelValidation() {
        defer { self.status = "checking ready to get started" }
        validationTask?.cancel()
        
//        if let cancelllation =  validationTask?.isCancelled {
//            print("te cancelation flag is \(cancelllation)")
////            print(canc)
//        }
        validationInProgress = false
    }
}
