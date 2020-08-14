//
//  Generator.swift
//  Mod7 Generator
//
//  Created by Jon Alaniz on 8/13/20.
//

import SwiftUI

open class Generator: ObservableObject {
    @Published var office97Key = ""
    @Published var windows95OEMKey = ""
    @Published var windows95RetailKey = ""
    
    func refresh() {
        windows95OEMKey = windows95OEMKeyGen()
        windows95RetailKey = windows95RetailKeyGen()
        office97Key = office97KeyGen()
    }
    
    // Office 97 Key - 11 Digits
    // XXXX-XXXXXX
    // XXXX - First Group
    // 0001 to 9991, there are no banned numbers, but last digit must match 3rd digit + 1 or 2. 9 overflows to 0 or 1.
    private func office97KeyGen() -> String {
        // Create the first 3 digits in the key
        let preceding3Digits = Int(arc4random_uniform(1000))
        var preceding3DigitsString = String(preceding3Digits)
        
        while preceding3DigitsString.count < 3 {
            preceding3DigitsString = "0" + preceding3DigitsString
        }
        
        // Get the last digit of the above number, add 1 or 2 to it, then pull the last digit
        let initialLastDigit = preceding3Digits % 10
        let interimLastDigit = initialLastDigit + Int(arc4random_uniform(2)) + 1
        let lastDigit = interimLastDigit % 10
        let lastDigitString = String(lastDigit)
        
        // Create key string with first 4 digits, add dash
        var key = preceding3DigitsString + "-" + lastDigitString
        
        // Add Second Key Group
        key += secondKeyGroup(isOEM: false)
        
        // Return product key
        return key
    }
    
    // Windows 95 Key - OEM
    // XXXXX-OEM-XXXXXXX-XXXXX
    // XXXXX - Represents the date the key was printed, First 3 digits 001 to 366, last two 95 to 03
    // -OEM-
    // XXXXXXX - Mod7, but first digit must be 0
    // XXXXX - Random numbers
    private func windows95OEMKeyGen() -> String {
        // Setup constants
        let yearArray = ["95", "96", "97", "98", "99", "00", "01", "02", "03"]
        let oemString = "-OEM-"
        let day = arc4random_uniform(367)
        var dayString = String(day)
        var key = ""
        
        // Check if dayString has 3 digits, if not append 0's to the beginning until correct length
        if dayString.count < 3 {
            while dayString.count < 3 {
                dayString = "0" + dayString
            }
        }
        
        // Create the key by appending a random year to the date array
        key = dayString + yearArray.randomElement()!
        key += oemString
        key += "0"
        
        // Append the secondKeyGroup to the key, adding the OEM argument
        key += secondKeyGroup(isOEM: true)
        
        // Create the final key group
        let finalGroup = arc4random_uniform(100000)
        var finalGroupString = String(finalGroup)
        
        // Check if finalGroupString is the appropriate length, if not append 0's to the beginning until correct length
        if finalGroupString.count < 5 {
            while finalGroupString.count < 5 {
                finalGroupString = "0" + finalGroupString
            }
        }
        
        // Append the final portion of the key
        key += "-"
        key += finalGroupString
        
        return key
    }
    
    // Windows 95 Key - Retail - 10 Digits
    // XXX-XXXXXXX
    // XXX - First Group
    // 000 to 998, the following numbers are not allowed 333, 444, 555, 666, 777, 888, 999
    private func windows95RetailKeyGen() -> String {
        // Generate random number between 000 and 998
        var key = Int(arc4random_uniform(999))
        
        // If key is one of the banned numbers, subtract 1
        switch key {
        case 333, 444, 555, 666, 777, 888, 999:
            key -= 1
        default:
            break
        }
        
        // Make sure first group has correct number of digits, if not pad with 0's
        var keyString = String(key)
        
        while keyString.count < 3 {
            keyString = "0" + keyString
        }
        
        // Add dash and second key group
        keyString += "-"
        keyString += secondKeyGroup(isOEM: false)
        
        // Return product key
        return keyString
    }
    
    // XXXXXXX - Second Group - Can be used for Office 97 and Windows 95 Retail Keys
    // Digit sum must be divisible by 7, last digit cannot be 0, 8, or 9
    // If is used for OEM key, check that first digit is 0
    private func secondKeyGroup(isOEM: Bool) -> String {
        var secondKeyGroup: Int
        
        if isOEM {
            // OEM Specific generation
            repeat {
                // Generate a number between 0 and 999999, then convert to string for testing
                secondKeyGroup = Int(arc4random_uniform(999999))
            } while !digitIsValidKey(secondKeyGroup)
        } else {
            // Typical mod7 generating
            repeat {
                secondKeyGroup = Int(arc4random_uniform(9999999))
            } while !digitIsValidKey(secondKeyGroup)
        }
        
        
        
        return "\(secondKeyGroup)"
    }
    
    // Helper function for Second Key Group
    private func digitIsValidKey(_ num: Int) -> Bool {
        
        // Check if digit sum is divisible by 7
        var number = num
        var sum = 0
        
        while number > 0 {
            sum += number % 10
            number /= 10
        }
        
        // If not divisible, return false
        if !(sum % 7 == 0) {
            return false
        }
        
        // If previous was true, proceed to check if the last digit is valid
        let lastDigit = num % 10
        
        if lastDigit == 0 || lastDigit == 8 || lastDigit == 9 {
            return false
        } else {
            return true
        }
    }
}
