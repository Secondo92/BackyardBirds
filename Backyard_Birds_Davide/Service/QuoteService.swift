//
//  QuoteService.swift
//  Backyard_Birds_Davide
//
//  Created by dmu mac 34 on 10/12/2024.
//

import Foundation

class QuoteService {
    
    static func fetchRandomQuote() async -> Quote? {
        guard let url = URL(string: "https://dummyjson.com/quotes/random/") else { return nil }
        
        if let data = await getData(from: url) {
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                return quote
            } catch {
                print("Error decoding quote: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    
    static func getData(from url: URL) async -> Data? {
        let session = URLSession.shared
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { return nil }
            if(httpResponse.statusCode != 200) {
                fatalError("Uha da da, en fatal fejl")
            }
            return data
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
