//
//  TableViewPlaceholder.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import UIKit

class TableViewPlaceholder: UIView {
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image?.withConfiguration(config)
        }
    }
    
    var button: String? {
        didSet {
            self.actionButton.setTitle(button, for: .normal)
        }
    }
    
    var action: (() -> Void) = {}
    
    private let config = UIImage.SymbolConfiguration(pointSize: 96)
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image?.withConfiguration(config)
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = subtitle
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(button, for: .normal)
        btn.backgroundColor = .secondarySystemFill
        btn.setTitleColor(.tintColor, for: .normal)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.layer.cornerRadius = 8.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addAction(UIAction(title: "", handler: { [weak self] action in
            self?.buttonAction()
        }), for: .touchUpInside)
        return btn
    }()
    
    init(frame: CGRect, title: String, subtitle: String, button: String?, image: UIImage?, action: @escaping (() -> Void) = { }) {
        super.init(frame: frame)
        self.title = title
        self.subtitle = subtitle
        self.button = button
        self.image = image
        self.action = action
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(viewContent)
        
        viewContent.addSubview(imageView)
        viewContent.addSubview(titleLabel)
        viewContent.addSubview(subtitleLabel)
        
        if let _ = self.button {
            viewContent.addSubview(actionButton)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewContent.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewContent.topAnchor.constraint(equalTo: topAnchor),
            viewContent.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: viewContent.widthAnchor, multiplier: 0.8),
            
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -4),
            titleLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: viewContent.widthAnchor, multiplier: 0.8),
            
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            imageView.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 100),
        ])
        
        if let _ = self.button {
            NSLayoutConstraint.activate([
                actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
                actionButton.heightAnchor.constraint(equalToConstant: 44),
                actionButton.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
                actionButton.widthAnchor.constraint(equalTo: viewContent.widthAnchor, multiplier: 0.8),
            ])
        }
    }
    
    @objc func buttonAction() {
        action()
    }
}

public extension UITableView {
    func showTableViewPlaceholder(title: String, subtitle: String, button: String? = nil, image: UIImage?, action: @escaping (() -> Void) = { }) {
        let emptyTableView = TableViewPlaceholder(frame: bounds, title: title, subtitle: subtitle, button: button, image: image, action: action)
        
        backgroundView = UIView()
        backgroundView?.addSubview(emptyTableView)
    }
    
    func hideTableViewPlaceholder() {
        subviews.forEach { subview in
            if let emptyTableView = subview as? TableViewPlaceholder {
                emptyTableView.removeFromSuperview()
            }
        }
        backgroundView = UIView()
    }
}
