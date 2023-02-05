//
//  NewsViewController.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import UIKit

class NewsViewController: UIViewController {

    private let tableView = UITableView()
    
    private let apiClient: APIClient
    private var articlesEntity: ArticlesEntity?
    private var articles: Article {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(apiClient: APIClient, articles: Article){
        self.apiClient = apiClient
        self.articles = articles
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setConstraints()
    }
    
    private func setConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 800

        tableView.backgroundColor = .clear
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        cell.config(with: articles)
        
        return cell
    }
}

