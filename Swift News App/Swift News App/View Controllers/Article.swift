//
//  Article.swift
//  Swift News App
//
//  Created by Paul on 5/8/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
}

class Article {
    var publisher: String?
    var author: String?
    var title: String?
    var descr: String?
    var imgURL: String?
    var img: UIImage?
    var date: String?
    var content: String?
    
    public init(pub: String, auth: String, title: String, descr: String, img: String, date: String, content: String) {
        self.publisher = pub
        self.author = auth
        self.title = title
        self.descr = descr
        self.imgURL = img
        self.content = content
        
        let dateStr = date[0...9]
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = "yyyy-MM-dd"
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM dd, yyyy"
        
        if let newDate = dateFormatterIn.date(from: dateStr) {
            self.date = dateFormatterOut.string(from: newDate)
        }
    }
    
    public func setImage(table: UITableView) {
        guard let url = URL(string: self.imgURL!) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data,_,_ in
            guard let imgData = data, let img = UIImage(data: imgData) else { return }
            DispatchQueue.main.async {
                self.img = img
                table.reloadData()
            }
        }).resume()
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
}
