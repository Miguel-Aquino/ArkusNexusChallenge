//
//  PlaceDetailsViewController.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 23/12/20.
//

import UIKit
import MapKit
import CoreLocation

class PlaceDetailsViewController: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var petFriendlyImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var viewModel: PlaceViewModel?
    var locationManager: CLLocationManager?
    var annotation: CustomAnnotation?
    var pinAnnotationView: MKPinAnnotationView?
    var didFinishCalculate = false
    var placeDetails = [PlaceDetails]()
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapViewOnLocation()
        loadData()
    }
}

//MARK:- VC Extension

extension PlaceDetailsViewController {
    func configureVC() {
        mapView.delegate = self
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func centerMapViewOnLocation(){
        guard let viewModel = viewModel else { return }
        
        let pointAnnotation = CustomAnnotation(Identifiers.pinSelected)
        let center = CLLocationCoordinate2D(latitude: viewModel.Latitude, longitude: viewModel.Longitude)
        pointAnnotation.coordinate = center
        pointAnnotation.title = viewModel.PlaceName
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pointAnnotation)
    }
    
    func loadData() {
        guard let viewModel = viewModel else { return }
        
        placeNameLabel.text = viewModel.PlaceName
        placeAddressLabel.text = viewModel.Address
        calculateRating(rating: viewModel.Rating)
        let distance = viewModel.distance
        let distanceFormatted = String(format: "%.1f", distance)
        distanceLabel.text = "\(distanceFormatted) m"
        placeDetails = getPlaceDetails(vm: viewModel)
        tableView.reloadData()
    }
    
    func getPlaceDetails(vm: PlaceViewModel) -> [PlaceDetails]{
        let details = [PlaceDetails(detail: .directions, detailValue: vm.Address),
                       PlaceDetails(detail: .call, detailValue: vm.PhoneNumber),
                       PlaceDetails(detail: .visitWebsite, detailValue: vm.Site)]
        
        return details
    }
    
    private func openAppleMaps(location: CLLocationCoordinate2D , address: String) {
        let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = address

        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
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
}

//MARK: - CoreLocation Delegate & MapKit Delegate
extension PlaceDetailsViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = Identifiers.pinSelected
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = CustomAnnotation(reuseIdentifier)
        annotationView?.image = UIImage(named: customPointAnnotation.annotationName)
        
        return annotationView
    }
}

extension PlaceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeDetails.isEmpty ? 0 : placeDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(PlaceDetailsTableViewCell.reuseId, owner: self, options: nil)?.first as! PlaceDetailsTableViewCell
        
        cell.placeDetails = placeDetails[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if placeDetails[indexPath.row].detail == .directions{
            guard let lat = viewModel?.Latitude,
                  let lon = viewModel?.Longitude,
                  let addr = viewModel?.Address else { return }
            let location = CLLocationCoordinate2D(latitude: lat,
                                                  longitude: lon)
            openAppleMaps(location: location, address: addr)
        }
        
        if placeDetails[indexPath.row].detail == .call {
            let numberString = placeDetails[indexPath.row].detailValue
        
            let number = numberString.replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: " ", with: "")
            
            guard let phoneNumber = URL(string: "telprompt://\(number)" ) else { return }
            UIApplication.shared.open(phoneNumber)
        }
    }
}
