
# TwitScore (Demo)

This repository demonstrates how I used Twitter feeds to trained custom .mlmodel that predicts the sentiment of the input text.


## Demo

![GIF](https://github.com/willhCodes/TwitScoreDemo/blob/main/sample.gif)
## Highlights

Before starting to make predictions, there were two main things that needed to be set up:



1. Custom model file
 - This was achieved using CreateML, utilizing a public dataset (consisting of 1000 samples) from Sanders Analysis
  - The accuracy of the predictions reached approximately 74-75%

```
import Cocoa
import CreateML

let csvURL = URL(fileURLWithPath: #"myfile.csv"#)

let data = try MLDataTable(contentsOf: csvURL)

let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 3)
```


2. List of tweets

 - The tweets were fetched using Twitter API V1
 - SwifteriOS (although deprecated, was sufficient for retrieving the required data) was used for fetching the tweets
 - Parsing of the data was done using SwiftyJSON


 ```
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
        }
        
    }
 ```


###
Before passing the data to the ViewController, there were 2 more things I needed to set up:

1. Generating actual predictions from the tweets.
2. Implementing a scoring system based on the predictions.



```
func sentimentClassify(input: [TextClassifierInput]) -> Double {
        var sentimentScore: Double = 0

        do {
            
            let predictions = try self.tweetSentimentClassifier.predictions(inputs: input)
            
            
            for prediction in predictions {
                
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1.5
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                } else if sentiment == "Neutral" {
                    sentimentScore += 0.10
                }
            }

        } catch {
            print ("there was an error with making a prediction: \(error)")
        }
        
        return sentimentScore
        
    }

```

Now, I simply needed to pass the array of classified data to the ViewController using the delegate pattern.

```
protocol NetworkManagerDelegate {
    func didUpdateWithSentimentScore(score: Double)
}
```





```
extension ViewController: NetworkManagerDelegate {
    func didUpdateWithSentimentScore(score: Double) {
        var grade: String = ""

        switch score {

        case _ where score > 20:
            grade = "A"
        case _ where score > 10:
            grade = "B"
        case _ where score >= 0:
            grade = "C"
        case _ where score > -10:
            grade = "D"
        case _ where score > -20:
            grade = "F"
        default:
            return
        }
        scoreLabel.text = "Score: \(Int(score))"
        gradeLabel.text = "Grade: \(grade)"
    }   
}
```

