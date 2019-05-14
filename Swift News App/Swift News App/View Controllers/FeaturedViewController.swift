//
//  FeaturedViewController.swift
//  Swift News App
//
//  Created by Paul on 4/23/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var articles: [Article] = []
    var query = ""
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView()
    let filterView = FilterPopup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        blurEffectView.effect = blurEffect
        
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
    
    @IBAction func showFilters(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        
        view.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: blurEffectView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 10
        view.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: filterView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        filterView.cancelBtn.addTarget(self, action: #selector(cancelFilter), for: .touchUpInside)
        filterView.searchBtn.addTarget(self, action: #selector(filterArticles), for: .touchUpInside)
    }
    
    @objc func cancelFilter() {
        self.tabBarController?.tabBar.isHidden = false
        blurEffectView.removeFromSuperview()
        filterView.removeFromSuperview()
        if let picker = view.viewWithTag(1337) {
            picker.removeFromSuperview()
        }
    }
    
    @objc func filterArticles() {
        self.tabBarController?.tabBar.isHidden = false
        blurEffectView.removeFromSuperview()
        filterView.removeFromSuperview()
        if let picker = view.viewWithTag(1337) {
            picker.removeFromSuperview()
        }
        JSONParser.shared.getArticles(table: tableView, query: query, { result in
            self.articles = result
            
            for art in self.articles {
                art.setImage(table: self.tableView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        query = text
        JSONParser.shared.getArticles(table: tableView, query: text, { result in
            self.articles = result
            
            for art in self.articles {
                art.setImage(table: self.tableView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            query = ""
            JSONParser.shared.getArticles(table: tableView, { result in
                self.articles = result
                
                for art in self.articles {
                    art.setImage(table: self.tableView)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    searchBar.resignFirstResponder()
                }
            })
        }
    }
    
    //tableView delegate functions
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
        
        if articles[indexPath.item].isFave ?? false {
            cell.faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "article") as! ArticleViewController
        vc.article = articles[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
