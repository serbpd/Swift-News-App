//
//  FeaturedViewController.swift
//  Swift News App
//
//  Created by Paul on 4/23/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headlinesBtn: UIButton!
    @IBOutlet weak var favoritesBtn: UIButton!
    @IBOutlet weak var tabMarker: UIImageView!
    @IBOutlet weak var tabMarkerHeadlineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabMarkerFavoriteConstraint: NSLayoutConstraint!
    
    var articles: [Article] = []
    var headlineArticles: [Article] = []
    var favoriteArticles: [Article] = []
    var query = ""
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView()
    let filterView = FilterPopup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteArticles = getAllFaves()
        
        tabMarker.clipsToBounds = true
        tabMarker.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        blurEffectView.effect = blurEffect
        
        JSONParser.shared.getArticles(table: tableView, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
            for art in self.articles {
                art.setImage(table: self.tableView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func showFilters(_ sender: Any) {
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: blurEffectView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: blurEffectView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 10
        filterView.alpha = 0
        view.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: filterView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: filterView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
        filterView.cancelBtn.addTarget(self, action: #selector(cancelFilter), for: .touchUpInside)
        filterView.searchBtn.addTarget(self, action: #selector(filterArticles), for: .touchUpInside)
        
        self.filterView.transform = CGAffineTransform(translationX: 0, y: -200)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.blurEffectView.alpha = 1
            self.filterView.alpha = 1
            self.filterView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @objc func cancelFilter() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.blurEffectView.alpha = 0
            self.filterView.alpha = 0
            self.filterView.transform = CGAffineTransform(translationX: 0, y: 200)
        }, completion: {_ in
            self.blurEffectView.removeFromSuperview()
            self.filterView.removeFromSuperview()
            self.filterView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        if let picker = view.viewWithTag(1337) {
            picker.removeFromSuperview()
        }
    }
    
    @objc func filterArticles() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.blurEffectView.alpha = 0
            self.filterView.alpha = 0
            self.filterView.transform = CGAffineTransform(translationX: 0, y: 200)
        }, completion: {_ in
            self.blurEffectView.removeFromSuperview()
            self.filterView.removeFromSuperview()
            self.filterView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        if let picker = view.viewWithTag(1337) {
            picker.removeFromSuperview()
        }
        JSONParser.shared.getArticles(table: tableView, query: query, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
            for art in self.articles {
                art.setImage(table: self.tableView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func showHeadlines(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.tabMarkerHeadlineConstraint.priority = .defaultHigh
            self.tabMarkerFavoriteConstraint.priority = .defaultLow
            self.view.layoutIfNeeded()
        })
        articles = headlineArticles
        tableView.reloadData()
    }
    
    @IBAction func showFavorites(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.tabMarkerHeadlineConstraint.priority = .defaultLow
            self.tabMarkerFavoriteConstraint.priority = .defaultHigh
            self.view.layoutIfNeeded()
        })
        articles = favoriteArticles
        tableView.reloadData()
    }
    
    //searchBar delegate functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        query = text
        JSONParser.shared.getArticles(table: tableView, query: text, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
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
                self.headlineArticles = self.articles
                
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
        
        cell.faveBtn.addTarget(self, action: #selector(toggleFave(_:)), for: .touchUpInside)
        
        if articles[indexPath.item].isFave {
            cell.faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
        } else {
            cell.faveBtn.setImage(UIImage(named: "star_off"), for: .normal)
        }
        cell.article = articles[indexPath.item]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "article") as! ArticleViewController
        vc.article = articles[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1.0
        })
    }
    
    @objc func toggleFave(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? ArticleCell, let ar = cell.article, let index = tableView.indexPath(for: cell) else { return }
        
        if ar.isFave {
            removeFromFaves(article: ar)
            favoriteArticles.remove(at: index.item)
            cell.faveBtn.setImage(UIImage(named: "star_off"), for: .normal)
            ar.isFave = false
            showToast(message: "Removed from favorites")
        } else {
            addToFaves(article: ar)
            favoriteArticles.append(ar)
            cell.faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
            ar.isFave = true
            showToast(message: "Added to favorites")
        }
        
        guard let vc = navigationController?.viewControllers[0] as? FeaturedViewController else {return}
        vc.tableView.reloadData()
    }
}
