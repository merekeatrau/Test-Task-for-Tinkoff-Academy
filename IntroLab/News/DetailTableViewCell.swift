//
//  DetailTableViewCell.swift
//  IntroLab
//
//  Created by Mereke on 04.02.2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "DetailTableViewCell"
    private let articlesRepository = ArticleRepository.shared
    private var previewImageView = UIImageView()
    private var headerTitleLabel = UILabel()
    private var dateLabel = UILabel()
    private var stackView = UIStackView()
    private var descriptionLabel = UILabel()
    private var sourceLabel = UILabel()
    var didTapCell: (() -> Void)?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(previewImageView)
        contentView.addSubview(stackView)
        selectionStyle = .none
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.cornerRadius = 8
        previewImageView.contentMode = .scaleAspectFill
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        headerTitleLabel.numberOfLines = 0
        headerTitleLabel.textColor = .black
        headerTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        dateLabel.numberOfLines = 0
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.layer.opacity = 0.5
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        sourceLabel.numberOfLines = 0
        sourceLabel.textColor = .black
        sourceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        sourceLabel.layer.opacity = 0.5

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAttributedText))
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(tapGesture)
        stackView.addArrangedSubview(headerTitleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(sourceLabel)

    }
    
    @objc func didTapAttributedText(gestureRecognizer: UITapGestureRecognizer) {
        didTapCell?()
    }
    
    private func setConstraints() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with article: Article) {
        articlesRepository.loadImage(path: article.urlToImage ?? "",
                                   completion: { [weak self] imageData in
            self?.previewImageView.image = UIImage(data: imageData)
        })
        headerTitleLabel.text = article.title
        sourceLabel.text = article.source.name
        
        var description = article.description ?? ""
        description += " Read more"
        let readMoreRange = (description as NSString).range(of: "Read more")
        let attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: readMoreRange)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
        descriptionLabel.attributedText = attributedText

        if let dateString = article.publishedAt,
           let formattedDate = formatDate(dateString) {
            dateLabel.text = formattedDate
        } else {
            dateLabel.text = nil
        }
        
    }

    private func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "en_US")
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}
