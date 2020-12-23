//
//  PlaceDetailsTableViewCell.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 23/12/20.
//

import UIKit

class PlaceDetailsTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailValueLabel: UILabel!
    
    //MARK: Properties
    var placeDetails : PlaceDetails? {
        didSet{
            if let detail = placeDetails?.detail { setImage(detail: detail) }
            detailLabel.text = placeDetails?.detail.value
            detailValueLabel.text = placeDetails?.detailValue
        }
    }
    
    static let reuseId = "PlaceDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setImage(detail: PlaceType){
        if detail == .directions {
            detailImageView.image = Images.directions
        } else if detail == .call {
            detailImageView.image = Images.call
        } else {
            detailImageView.image = Images.visitWebSite
        }
    }
    
}
