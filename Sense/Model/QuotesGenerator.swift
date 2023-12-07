//
//  QuotesGenerator.swift
//  Sense
//
//  Created by Andrea Bottino on 06/12/2023.
//

import Foundation

protocol QuotesGeneratorDelegate {
    func didFailWithError(_ error: Error)
    func setQuoteModel(_ fetchedModel: QuoteModel)
}

struct QuoteGenerator {
    
    static var delegate: QuotesGeneratorDelegate?
    
    static func performRequest() {
        if let url = URL(string: "https://zenquotes.io/api/random") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url ) { (data, response, error) in
                if let error = error {
                    delegate?.didFailWithError(error)
                    return
                }
                if let safeData = data {
                    if let resultModel = parseJSON(safeData) {
                        delegate?.setQuoteModel(resultModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    static func parseJSON(_ quoteData: Data) -> QuoteModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([QuoteData].self, from: quoteData)
            let fetchedQuote = decodedData[0].q
            let fetchedAuthor = decodedData[0].a
            let model = QuoteModel(
                quote: fetchedQuote,
                author: fetchedAuthor
            )
            return model
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}



