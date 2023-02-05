//
//  ViewController.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import UIKit

class HomeViewController: UIViewController {
    private let userDefaults = AppUserDefaultsClient.shared
    private let tableView = UITableView()
    private var networkManager = APIClient.shared
    private var articles: [Article] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadArticles()
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setConstraints()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        loadArticles()
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .zero
        tableView.rowHeight = 160
        tableView.backgroundColor = .clear
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.config(with: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let newsVC = NewsViewController(apiClient: networkManager, articles: article)
        newsVC.title = "Details"
        navigationController?.pushViewController(newsVC, animated: true)
        guard let url = article.url else{return}
        userDefaults.addView(url: url)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension HomeViewController {
    private func loadArticles() {
        networkManager.loadArticles() { [weak self] loadedArticles in
            self?.articles = loadedArticles
            guard let refreshControl = self?.tableView.refreshControl else { return }
            if  refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
}
