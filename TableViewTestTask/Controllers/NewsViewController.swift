//
//  NewsViewController.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 25.03.2021.
//

import UIKit
import JGProgressHUD

class NewsViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .light)
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var newsVM = NewsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        searchBar.delegate = self
        
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self,
                                                action: #selector(didPullToRefresh),
                                                for: .valueChanged)
        searchBar.becomeFirstResponder()
    }
    
    @objc private func didPullToRefresh() {
        let currentKeyword = NetworkManager.shared.getKeyword()
        updateUI(with: currentKeyword)
        
        DispatchQueue.main.async {
            self.newsTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func updateUI(with keyword: String) {
        spinner.show(in: view)
        newsVM.fetchNews(with: keyword) { [weak self] success in
            if success {
                print("News were fetched successfully!")
                
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            } else {
                print("Error with fetching data")
            }
        }
        spinner.dismiss()
    }

}

//MARK: - TableView
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsVM.getNewsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        
        let newsItem = newsVM.getNewsItem(for: indexPath)
        cell.fill(with: newsItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toWebPage", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebPageViewController
        if let indexPath = newsTableView.indexPathForSelectedRow {
            if let newsUrl = newsVM.getNewsItemUrl(for: indexPath) {
                destinationVC.url = newsUrl
            }
        }
    }
}

//MARK: - SearchBar
extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        updateUI(with: keyword)
    }

}