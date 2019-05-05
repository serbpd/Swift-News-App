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
    }
}
