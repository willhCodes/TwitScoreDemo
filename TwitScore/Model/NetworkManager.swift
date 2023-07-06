//
//  NetworkManager.swift
//  TwitScore
//
//  Created by willhcodes on 6/26/23.
//

import Foundation
import SwiftyJSON
import Swifter

protocol NetworkManagerDelegate {
    func didUpdateWithSentimentScore(score: Double)
}

struct NetworkManager {
    
    let swifter = Swifter(consumerKey: APIKeyManager().apiKey,
                          consumerSecret: APIKeyManager().apiKeySecret)
    
    let sentimentClssifier = SentimentClassifier()
    
    var delegate: NetworkManagerDelegate?
    
    var tweetCount: Int = 0
    
    var sentimentScore: Double = 0

    
    func fetchTweet(_ query: String) {
        swifter.searchTweet(using: query,lang: "en", count: 100, tweetMode: .extended, success: { (response, data) in
            var tweetArray: [TextClassifierInput] = []
            if let responseCount = response.array?.count {
                for row in 0...responseCount-1 {
                    let tweetForClassification = TextClassifierInput(text: response[row]["full_text"].string!)
                    tweetArray.append(tweetForClassification)
                }
            }
            
            self.delegate?.didUpdateWithSentimentScore(score: sentimentClssifier.sentimentClassify(input: tweetArray))
        }) { (error) in
            print("there was an error with the twitter API request, \(error)")
            self.fetchTweet(query)
        }
        
    }
    
    
    
}
