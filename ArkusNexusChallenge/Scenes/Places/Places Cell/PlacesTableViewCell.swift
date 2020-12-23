//
//  PlacesTableViewCell.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import UIKit
import CoreLocation

class PlacesTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var petFriendlyImageView: UIImageView!
    @IBOutlet weak var petFriendlyLabel: UILabel!
    
    //MARK:- Properties
    static let resuseId = "PlacesTableViewCell"
    var didFinishCalculate = false
    
    var placeViewModel: PlaceViewModel? {
        didSet{
            placeNameLabel.text = placeViewModel?.PlaceName
            placeAddressLabel.text = placeViewModel?.Address
            if let rating =  placeViewModel?.Rating { calculateRating(rating: rating) }
            if let url = placeViewModel?.Thumbnail { downloadImage(fromURL: url) }
            let distance = placeViewModel?.distance
            let distanceFormatted = String(format: "%.1f", distance!)
            distanceLabel.text = "\(distanceFormatted) m"
            if let isPetFriendly = placeViewModel?.IsPetFriendly {
                petFriendlyImageView.isHidden = !isPetFriendly
                petFriendlyLabel.isHidden = !isPetFriendly
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func calculateRating(rating: Double) {
        let roundedScore = Int(rating.rounded())
        
        if didFinishCalculate == false {
            for index in 1...5 {
                if index <= roundedScore {
                    let yellowStar = UIImageView(image: UIImage(named: "starYellow"))
                    setConstraints(imageView: yellowStar)
                    ratingStack.addArrangedSubview(yellowStar)
                } else {
                    let grayStar = UIImageView(image: UIImage(named: "starGray"))
                    setConstraints(imageView: grayStar)
                    ratingStack.addArrangedSubview(grayStar)
                }
            }
            didFinishCalculate = true
        }
    }
    
    func setConstraints(imageView: UIView){
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: (20)),
            imageView.widthAnchor.constraint(equalToConstant: (20))
        ])
    }
    
    
    func downloadImage(fromURL url: String) {
        PlacesService.shared.getImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.placeImageView.image = image }
        }
    }
}
