//
//  FeaturedViewController.swift
//  Swift News App
//
//  Created by Paul on 4/23/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FaveBtnDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var headlinesBtn: UIButton!
    @IBOutlet weak var favoritesBtn: UIButton!
    @IBOutlet weak var tabMarker: UIImageView!
    @IBOutlet weak var tabMarkerHeadlineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabMarkerFavoriteConstraint: NSLayoutConstraint!
    
    var articles: [Article] = []
    var headlineArticles: [Article] = []
    var query = ""
    var showingFaves = false
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView()
    let filterView = FilterPopup()
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabMarker.clipsToBounds = true
        tabMarker.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        blurEffectView.effect = blurEffect
        
        showLoading()
        JSONParser.shared.getArticles(table: tableView, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
            self.getAllImages {
                DispatchQueue.main.async {
                    self.removeLoading()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //navigationController?.isNavigationBarHidden = true
        if !isFirstLoad && showingFaves {
            articles = getAllFaves()
            tableView.reloadData()
        } else {
            isFirstLoad = false
        }
    }
    
    func getAllImages(_ completion: @escaping() -> Void) {
        var index = 1
        for art in articles {
            guard let url = URL(string: art.imgURL!) else { continue }
            let data = try? Data(contentsOf: url)
            if let imgData = data {
                art.img = UIImage(data: imgData)!
            }
            
            if index == (articles.count - 1) {
                completion()
            }
            index += 1
        }
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
        self.showLoading()
        JSONParser.shared.getArticles(table: tableView, query: query, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
            self.getAllImages {
                DispatchQueue.main.async {
                    self.removeLoading()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func showHeadlines(_ sender: Any) {
        showingFaves = false
        self.searchBar.isUserInteractionEnabled = true
        self.filterBtn.isUserInteractionEnabled = true

        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.tabMarkerHeadlineConstraint.priority = .defaultHigh
            self.tabMarkerFavoriteConstraint.priority = .defaultLow
            self.headlinesBtn.setTitleColor(.white, for: .normal)
            self.favoritesBtn.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
            self.titleLbl.text = "Top Headlines"
            self.searchBar.alpha = 1
            self.filterBtn.alpha = 1
            self.view.layoutIfNeeded()
        })
        articles = headlineArticles
        tableView.reloadData()
    }
    
    @IBAction func showFavorites(_ sender: Any) {
        showingFaves = true
        tableView.setContentOffset(.zero, animated: false)
        self.searchBar.isUserInteractionEnabled = false
        self.filterBtn.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.tabMarkerHeadlineConstraint.priority = .defaultLow
            self.tabMarkerFavoriteConstraint.priority = .defaultHigh
            self.headlinesBtn.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
            self.favoritesBtn.setTitleColor(.white, for: .normal)
            self.titleLbl.text = "Favorites"
            self.searchBar.alpha = 0.2
            self.filterBtn.alpha = 0.2
            self.view.layoutIfNeeded()
        })
        articles = getAllFaves()
        tableView.reloadData()
    }
    
    //searchBar delegate functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        query = text
        self.showLoading()
        JSONParser.shared.getArticles(table: tableView, query: text, { result in
            self.articles = result
            self.headlineArticles = self.articles
            
            self.getAllImages {
                DispatchQueue.main.async {
                    self.removeLoading()
                    self.tableView.reloadData()
                    searchBar.resignFirstResponder()
                }
            }
            
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            query = ""
            self.showLoading()
            JSONParser.shared.getArticles(table: tableView, { result in
                self.articles = result
                self.headlineArticles = self.articles
                
                self.getAllImages {
                    DispatchQueue.main.async {
                        self.removeLoading()
                        self.tableView.reloadData()
                        searchBar.resignFirstResponder()
                    }
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
        cell.index = indexPath
        cell.delegate = self
        
        if indexPath.item % 2 == 0 || indexPath.item == 0 {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.28, alpha: 0.8)
        } else {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.77, blue: 0.28, alpha: 0.3)
        }
                
        if articles[indexPath.item].isFave {
            cell.faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
        } else {
            cell.faveBtn.setImage(UIImage(named: "star_off"), for: .normal)
        }
        if showingFaves {
            cell.faveBtn.isHidden = true
        } else {
            cell.faveBtn.isHidden = false
        }
        cell.article = articles[indexPath.item]
        
        guard let image = articles[indexPath.item].img else { cell.img.image = UIImage(named: "noImg"); return cell }
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1.0
        })
    }
    
    func toggleFave(_ index: IndexPath) {
        guard let cell = tableView.cellForRow(at: index) as? ArticleCell else { return }
        let ar = articles[index.item]
        if ar.isFave {
            removeFromFaves(article: ar)
            cell.faveBtn.setImage(UIImage(named: "star_off"), for: .normal)
            ar.isFave = false
            showToast(message: "Removed from favorites")
        } else {
            addToFaves(article: ar)
            cell.faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
            ar.isFave = true
            showToast(message: "Added to favorites")
        }
//        guard let vc = navigationController?.viewControllers[0] as? FeaturedViewController else {return}
//        vc.tableView.reloadData()
    }
}
