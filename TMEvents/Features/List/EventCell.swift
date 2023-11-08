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
        view.backgroundColor = self.isSelected ? .systemBackground : .secondarySystemBackground
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var eventTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = self.isSelected ? .darkText : .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textColor = self.isSelected ? .darkText : .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventVenue: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.textColor = self.isSelected ? .darkText : .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventVenueLocation: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 0
        label.textColor = self.isSelected ? .darkText : .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventImageView = UIImageView()
    
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
    }
    
    private func setupUI() {
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventImageView)
        eventImageView.contentMode = .scaleAspectFit
        
        for label in [eventTitle, eventDate, eventVenue, eventVenueLocation] {
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            label.numberOfLines = 0
        }
        
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),
            eventImageView.heightAnchor.constraint(equalToConstant: 100),
            
            eventTitle.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
            eventTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            eventDate.leadingAnchor.constraint(equalTo: eventTitle.leadingAnchor),
            eventDate.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 8),
            
            eventVenue.leadingAnchor.constraint(equalTo: eventTitle.leadingAnchor),
            eventVenue.topAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 8),
            
            eventVenueLocation.leadingAnchor.constraint(equalTo: eventTitle.leadingAnchor),
            eventVenueLocation.topAnchor.constraint(equalTo: eventVenue.bottomAnchor, constant: 8),
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
        guard let venue = eventData.venues.first else {
            return nil
        }
        
        return venue.name
    }
    
    var location: String? {
        guard let venue = eventData.venues.first else {
            return nil
        }
        
        return "\(venue.city.name), \(venue.state.stateCode)"
    }
}
