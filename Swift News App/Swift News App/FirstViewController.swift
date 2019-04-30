//
//  FirstViewController.swift
//  Swift News App
//
//  Created by Paul on 4/23/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        JSONParser.shared.getArticles({result in
            self.articles = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleCell
        cell.title.text = articles[indexPath.item].title
        
        guard let imgURL = URL(string: articles[indexPath.item].imgURL ?? "") else { return cell }
        URLSession.shared.dataTask(with: imgURL, completionHandler: { data,_,_ in
            let img = UIImage(data: data!)
            DispatchQueue.main.async {
                cell.img.image = img
            }
        }).resume()
        
        return cell
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
    var date: Date?
    var content: String?
    
    public init(pub: String, auth: String, title: String, descr: String, img: String, date: String, content: String) {
        self.publisher = pub
        self.author = auth
        self.title = title
        self.descr = descr
        self.imgURL = img
        self.date = Date()
        self.content = content
    }
}
