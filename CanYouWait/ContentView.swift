//
//  ContentView.swift
//  CanYouWait
//
//  Created by ousmane diouf on 9/18/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PrimeNumberCheckViewModel(service: PrimeService())
    
    @State private var userInput = ""
    @State private var inputValue = 0
    
    var body: some View {
        VStack(spacing: 20) {
            userTextFieldView

            validatingStatusView
            
            validateButtonView
        }
        .padding()
    }
    
    private var userTextFieldView: some View {
        TextField("enter number here", text: $userInput)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onTapGesture {
            viewModel.cancelValidation()
        }
    }
    
    private var validatingStatusView: some View {
        HStack {
            Text("Status : \(viewModel.status)")
                        
            if  viewModel.isPrime {
                Image(systemName: "checkmark.diamond.fill")
                    .foregroundColor(Color.green)
            } else {
                Image(systemName: "xmark.diamond.fill")
                    .foregroundColor(Color.red)
            }
        }
    }

    private var validateButtonView: some View {
        Button {
            inputValue = viewModel.toInteger(userInput)
            
                if !viewModel.validationInProgress {
                    Task {
                        await viewModel.checkNumber(inputValue)
                    }
                }
            
        } label: {
            ZStack {
                Text("Validate")
                    .foregroundColor(Color.white)
                
                if viewModel.validationInProgress {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(10)
        .disabled(userInput.isEmpty) // Disable the button when text is empty
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
