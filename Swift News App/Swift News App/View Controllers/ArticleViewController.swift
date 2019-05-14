//
//  ArticleViewController.swift
//  Swift News App
//
//  Created by Paul on 5/1/19.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewController: UIViewController {
    var article: Article?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var contentTxtField: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var faveBtn: UIButton!
    
    override func viewDidLoad() {
        titleLbl.text = article?.title
        descrLbl.text = article?.descr
        dateLbl.text = article?.date
        img.image = article?.img
        contentTxtField.text = article?.content
        if article?.author == "" || article?.author == nil {
            authorLbl.text = "No author credited"
        } else {
            authorLbl.text = article?.author
        }
        img.clipsToBounds = true
        img.layer.cornerRadius = 15
        
        scrollView.contentSize = contentView.frame.size
        
        if article?.isFave ?? false {
            faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
        }
    }
    
    @IBAction func toggleFave(_ sender: Any) {
        guard let ar = article else { return }
        if ar.isFave {
            removeFromFaves(article: ar)
            faveBtn.setImage(UIImage(named: "star_off"), for: .normal)
            ar.isFave = false
            showToast(message: "Removed from favorites")
        } else {
            addToFaves(article: ar)
            faveBtn.setImage(UIImage(named: "star_on"), for: .normal)
            ar.isFave = true
            showToast(message: "Added to favorites")
        }
        
        guard let vc = navigationController?.viewControllers[0] as? FeaturedViewController else {return}
        vc.tableView.reloadData()
    }
}
