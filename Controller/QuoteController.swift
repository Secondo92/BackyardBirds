//
//  QuoteController.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 09/12/2024.
//

import Foundation


class QuoteController {
    private static let lastQuoteIDKey = "lastQuoteID"
    
    static func saveLastQuoteID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: lastQuoteIDKey)
    }
    
    static func getLastQuoteID() -> Int? {
        return UserDefaults.standard.value(forKey: lastQuoteIDKey) as? Int
    }
    
    static func fetchRandomQuote() async -> Quote? {
        guard let url = URL(string: "https://dummyjson.com/quotes/random/") else {
            print("FEJL FEJL FEJL")
            return nil }
        
        guard let data = await QuoteService.getData(from: url) else {
            print("ingen data modtaget fra api")
            return nil
        }
        
        do {
            let quote = try JSONDecoder().decode(Quote.self, from: data)
            print("Fetched Quote: \(quote)")

            if(quote.id == getLastQuoteID()){
                print("Duplicate quote ID: \(quote.id), fetching a new one...")
                return await fetchRandomQuote()
            }
            saveLastQuoteID(quote.id)
            return quote
        } catch {
            print("Error decoding quote: \(error.localizedDescription)")
            return nil
        }
    }
}
