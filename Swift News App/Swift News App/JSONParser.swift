//
//  JSONParser.swift
//  Swift News App
//
//  Created by Paul on 4/24/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

class JSONParser {
    public static let shared = JSONParser()
    private var resultArticles: [Article] = []
    private var newsAPIKey = "9027771a2bb24ecaad4faa45cf46cd96"
    
    var paramCountry = ""
    var paramCat = ""
    var paramSort = ""
    var paramSrc = ""
    
    public func getArticles(table: UITableView, query: String = "", _ completion: @escaping([Article]) -> Void) {
        resultArticles.removeAll()
        var request = "https://newsapi.org/v2/top-headlines?country=us"
        let session = URLSession.shared
        
        if query != "" {
            request.append("&q=\(query)")
        }
        if paramCountry != "" {
            request = request.replacingOccurrences(of: "country=us", with: "country=\(paramCountry)")
        }
        
        request.append("&apiKey=\(newsAPIKey)")
        
        guard let url = URL(string: request) else { return }
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any], let jsonResponse = jsonResult, let articles = jsonResponse["articles"] as? [[String: Any]] else {
                print("error in JSONSerialization")
                return
            }
            
            for article in articles {
                let author = article["author"] as? String
                let title = article["title"] as? String
                let descr = article["description"] as? String
                let imgURL = article["urlToImage"] as? String
                let date = article["publishedAt"] as? String
                let content = article["content"] as? String
                let s = article["source"] as! [String: Any]
                let source = s["name"] as? String
                var isFave = false
                
                let faves = getAllFaves()
                if faves.count > 0 {
                    for a in faves where (a.title == title && a.author == author && a.descr == descr) {
                        isFave = true
                    }
                }
                
                let a = Article(pub: source ?? "", auth: author ?? "", title: title ?? "", descr: descr ?? "", img: imgURL ?? "", date: date ?? "", content: content ?? "", isFave: isFave)
                self.resultArticles.append(a)
            }
            completion(self.resultArticles)
        })
        task.resume()
    }
    
    public func clearParams() {
        paramCountry = ""
        paramSrc = ""
        paramSort = ""
        paramCat = ""
    }
}
