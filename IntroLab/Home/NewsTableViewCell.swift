//
//  NewsTableViewCell.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ImageTableCell"
    private let articlesRepository = ArticleRepository.shared
    private var previewImageView = UIImageView()
    private var textStackView = UIStackView()
    private var viewCountStackView = UIStackView()
    private var newsStackView = UIStackView()
    private var titleLabel = UILabel()
    private var viewCountLabel = UILabel()
    private var viewIconImageView = UIImageView(image: UIImage(systemName: "eye.fill"))
    private var userDefaults = AppUserDefaultsClient.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsStackView)
        selectionStyle = .none
        setupViews()
        setConstraints()
        
    }
    
    private func setupViews() {
        newsStackView.axis = .horizontal
        newsStackView.spacing = 16
        newsStackView.alignment = .leading
        newsStackView.distribution = .fillProportionally
        
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.cornerRadius = 6
        previewImageView.contentMode = .scaleAspectFill
        
        textStackView.axis = .vertical
        textStackView.spacing = 2
        textStackView.alignment = .leading
        textStackView.distribution = .equalSpacing
        
        viewCountStackView.axis = .horizontal
        viewCountStackView.alignment = .center
        viewCountStackView.spacing = 1
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.text = ""
        
        viewCountLabel.numberOfLines = 0
        viewCountLabel.textColor = .black
        viewCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        viewCountLabel.layer.opacity = 0.5
        viewCountLabel.text = ""
        
        viewIconImageView.tintColor = .black
        viewIconImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        viewIconImageView.layer.opacity = 0.0
        
        viewCountStackView.addArrangedSubview(viewIconImageView)
        viewCountStackView.addArrangedSubview(viewCountLabel)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(viewCountStackView)
        
        newsStackView.addArrangedSubview(textStackView)
        newsStackView.addArrangedSubview(previewImageView)
        
    }
    
    private func setConstraints() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        newsStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.36).isActive = true
        
        textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textStackView.heightAnchor.constraint(equalTo: previewImageView.heightAnchor, multiplier: 1).isActive = true
        
        newsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        newsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        newsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        newsStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with article: Article) {
        articlesRepository.loadImage(path: article.urlToImage ?? "",
                                   completion: { [weak self] imageData in
            self?.previewImageView.image = UIImage(data: imageData)
        })
        titleLabel.text = article.title
        guard let url = article.url else{return}
        viewCountLabel.text = "\(userDefaults.getViews(url: url))"
        viewIconImageView.layer.opacity = 0.5
    }
}
