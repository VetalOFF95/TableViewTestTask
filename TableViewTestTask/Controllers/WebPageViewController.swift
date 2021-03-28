//
//  WebPageViewController.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 26.03.2021.
//

import UIKit
import WebKit
import JGProgressHUD

class WebPageViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .light)
    public var url: URL?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.show(in: view)
        webView.load(URLRequest(url: url!))
        spinner.dismiss()
    }
}
