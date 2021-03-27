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
        updateData(with: currentKeyword, isFirstPage: true)
        newsTableView.refreshControl?.endRefreshing()
    }
    
    private func updateData(with keyword: String, isFirstPage: Bool) {
        spinner.show(in: view)
        newsVM.fetchNews(with: keyword, isFirstPage: isFirstPage) { [weak self] success in
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
        let newsNumber = newsVM.getNewsCount()
        return newsNumber == 0 ? 0 : newsNumber + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == newsVM.getNewsCount() {
            let cell = newsTableView.dequeueReusableCell(withIdentifier: "loadMore", for: indexPath)
            return cell
        } else {
            let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
            let newsItem = newsVM.getNewsItem(for: indexPath)
            cell.fill(with: newsItem)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == newsVM.getNewsCount() {
            let currentKeyword = NetworkManager.shared.getKeyword()
            updateData(with: currentKeyword, isFirstPage: false)
        } else {
            performSegue(withIdentifier: "toWebPage", sender: self)
        }
        
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
        
        updateData(with: keyword, isFirstPage: true)
    }

}
