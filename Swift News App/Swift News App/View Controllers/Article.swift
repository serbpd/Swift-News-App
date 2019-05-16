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
    @IBOutlet weak var faveBtn: UIButton!
    var article: Article?
}

class Article: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(publisher, forKey: "publisher")
        aCoder.encode(author, forKey: "author")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(descr, forKey: "descr")
        aCoder.encode(imgURL, forKey: "imgURL")
        aCoder.encode(img, forKey: "img")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(isFave, forKey: "isFave")
    }
    
    required init?(coder aDecoder: NSCoder) {
        publisher = aDecoder.decodeObject(forKey: "publisher") as? String
        author = aDecoder.decodeObject(forKey: "author") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        descr = aDecoder.decodeObject(forKey: "descr") as? String
        imgURL = aDecoder.decodeObject(forKey: "imgURL") as? String
        img = aDecoder.decodeObject(forKey: "img") as? UIImage
        date = aDecoder.decodeObject(forKey: "date") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        isFave = aDecoder.decodeObject(forKey: "isFave") as? Bool ?? false
    }
    
    var publisher: String?
    var author: String?
    var title: String?
    var descr: String?
    var imgURL: String?
    var img: UIImage?
    var date: String?
    var content: String?
    var isFave: Bool = false
    
    public init(pub: String, auth: String, title: String, descr: String, img: String, date: String, content: String, isFave: Bool) {
        self.publisher = pub
        self.author = auth
        self.title = title
        self.descr = descr
        self.imgURL = img
        self.content = content
        self.isFave = isFave
        
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

func addToFaves(article: Article) {
    var faves = getAllFaves()
    faves.append(article)
    try? UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: faves, requiringSecureCoding: false), forKey: "faves")
}

func removeFromFaves(article: Article) {
    var faves = getAllFaves()
    var index = 0
    for a in faves {
        if a.title == article.title && a.author == article.author && a.descr == article.descr {
            faves.remove(at: index)
        }
        index += 1
    }
    try? UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: faves, requiringSecureCoding: false), forKey: "faves")
}

func getAllFaves() -> [Article] {
    guard let data = UserDefaults.standard.value(forKey: "faves") as? NSData else {
        UserDefaults.standard.set([], forKey: "faves")
        return []
    }
    guard let faves = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as! [Article] else {return []}
    for art in faves {
        art.isFave = true
    }
    return faves
}
