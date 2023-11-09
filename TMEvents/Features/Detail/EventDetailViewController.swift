//
//  EventDetailViewController.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private let viewModel: EventDetailViewModel
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "EventDetailView"
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "EventImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.accessibilityIdentifier = "EventTitleLabelIdentifier"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.accessibilityIdentifier = "EventDateLabelIdentifier"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventVenueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.accessibilityIdentifier = "EventVenueLabelIdentifier"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.accessibilityIdentifier = "EventLocationLabelIdentifier"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: EventDetailViewModel = EventDetailViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event info"
        
        setupViews()
        setupConstraints()
        setupCloseButton()
    }
    
    func configure(for event: Event) {
        viewModel.setEvent(event)
        
        eventNameLabel.text = event.name
        eventDateLabel.text = event.formattedDate
        eventVenueLabel.text = event.venueName
        eventCityLabel.text = event.location
        
        let sizeClass = self.traitCollection.horizontalSizeClass
        
        if let bestImage = event.getBestImage(for: sizeClass, preferredRatio: nil),
           let url = URL(string: bestImage.url) {
            self.loadImageAsync(from: url)
        } else {
            self.imageView.image = UIImage(systemName: "ticket.fill")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: self.getFavImage(),
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteButtonTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "FavoriteButton"
    }
    
    private func loadImageAsync(from imageURL: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventDateLabel)
        contentView.addSubview(eventVenueLabel)
        contentView.addSubview(eventCityLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9.0/16.0),
            
            eventNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventDateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
            eventDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventVenueLabel.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 8),
            eventVenueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventVenueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventCityLabel.topAnchor.constraint(equalTo: eventVenueLabel.bottomAnchor, constant: 8),
            eventCityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventCityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventCityLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        closeButton.accessibilityIdentifier = "Close"
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleFavoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
    
    private func getFavImage() -> UIImage {
        let favoriteImage = UIImage(systemName: "star")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        let unfavoriteImage = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        
        return viewModel.isEventFavorited() ? unfavoriteImage! : favoriteImage!
    }
}
