//
//  FeaturedViewController.swift
//  Swift News App
//
//  Created by Paul on 4/23/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        JSONParser.shared.getArticles(table: tableView, { result in
            self.articles = result
            
            for art in self.articles {
                art.setImage(table: self.tableView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.18
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        cell.title.text = articles[indexPath.item].title
        
        guard let image = articles[indexPath.item].img else { return cell }
        cell.img.image = image
        cell.img.clipsToBounds = true
        cell.img.layer.cornerRadius = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "article") as! ArticleViewController
        vc.article = articles[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

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
