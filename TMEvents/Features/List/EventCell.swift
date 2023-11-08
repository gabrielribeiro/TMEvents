//
//  EventCell.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import UIKit

class EventCell: UITableViewCell {
    
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = isSelected ? .systemBackground : .secondarySystemBackground
//        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var eventTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private lazy var eventDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private lazy var eventVenue: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private lazy var eventVenueLocation: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(for event: Event) {
        eventTitle.text = event.name
        eventDate.text = event.formattedDate
        eventVenue.text = event.venueName
        eventVenueLocation.text = event.location
        
        let sizeClass = UIScreen.main.traitCollection.horizontalSizeClass
        
        if let bestImage = event.getBestImage(for: sizeClass, preferredRatio: .the3_2),
           let url = URL(string: bestImage.url) {
            self.loadImageAsync(from: url)
        } else {
            self.eventImageView.image = UIImage(systemName: "ticket.fill")
        }
    }
    
    private func loadImageAsync(from imageURL: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.eventImageView.image = image
                }
            }
        }
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        for label in [eventTitle, eventDate, eventVenue, eventVenueLocation] {
            labelsStackView.addArrangedSubview(label)
        }
        
        baseView.addSubview(eventImageView)
        baseView.addSubview(labelsStackView)
        
        contentView.addSubview(baseView)
        
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            eventImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 8),
            eventImageView.topAnchor.constraint(greaterThanOrEqualTo: baseView.topAnchor, constant: 8),
            eventImageView.bottomAnchor.constraint(lessThanOrEqualTo: baseView.bottomAnchor, constant: -8),
            eventImageView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
            
            labelsStackView.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -8),
            labelsStackView.topAnchor.constraint(greaterThanOrEqualTo: baseView.topAnchor, constant: 8),
            labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: baseView.bottomAnchor, constant: -8),
            labelsStackView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor),
        ])
    }
}

extension Event {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self.dates.start.dateTime).uppercased()
    }
    
    var venueName: String? {
        guard let venue = eventData?.venues.first else {
            return nil
        }
        
        return venue.name
    }
    
    var location: String? {
        guard let venue = eventData?.venues.first else {
            return nil
        }
        
        var formattedLocation = venue.city.name
        
        if let stateCode = venue.state?.stateCode {
            formattedLocation.append(", \(stateCode)")
        }
        
        return formattedLocation
    }
    
    func getBestImage(for sizeClass: UIUserInterfaceSizeClass, preferredRatio: Ratio) -> EventImage? {
        let filteredImages = images.filter { image in
            if sizeClass == .regular {
                return image.url.contains("LANDSCAPE") || image.url.contains("RETINA_LANDSCAPE")
            } else {
                return image.url.contains("PORTRAIT") || image.url.contains("RETINA_PORTRAIT")
            }
        }
        
        // Sort the filtered images by the preferred ratio
        let sortedImages = filteredImages.sorted { (image1, image2) in
            let ratio1 = image1.ratio
            let ratio2 = image2.ratio
            
            if ratio1 == preferredRatio && ratio2 != preferredRatio {
                return true
            } else if ratio1 != preferredRatio && ratio2 == preferredRatio {
                return false
            } else {
                return image1.width > image2.width
            }
        }
        
        // Return the URL of the best image (if available)
        if let bestImage = sortedImages.first {
            return bestImage
        } else {
            // If no images match the preferred criteria, fall back to the first image
            return images.first
        }
    }
}
