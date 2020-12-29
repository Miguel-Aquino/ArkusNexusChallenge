//
//  PlacesViewController.swift
//  ArkusNexusChallenge
//
//  Created by Miguel Aquino on 22/12/20.
//

import UIKit
import CoreLocation

class PlacesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    
    var viewModel = [PlaceViewModel]()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureLocationServices()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
    }
}

//MARK:- VC Extension

extension PlacesViewController {
    func configureVC() {
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadData(){
        PlacesService.shared.getPlaces {[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let places):
                let places = places.map( { PlaceViewModel($0)} )
                for place in places {
                    place.calculateDistance(currentLocation: self.currentLocation!)
                    self.viewModel.append(place)
                }
                self.viewModel.sort(by: { $0.distance < $1.distance })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.locationManager?.stopUpdatingLocation()
                }
            case .failure: break
            }
        }
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isEmpty ? 0 : viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(PlacesTableViewCell.resuseId, owner: self, options: nil)?.first as! PlacesTableViewCell
        
        cell.placeViewModel = viewModel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        VCs.placeDetailsVC.viewModel = viewModel[indexPath.row]
        self.navigationController?.pushViewController(VCs.placeDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK: - CoreLocation Delegate

extension PlacesViewController: CLLocationManagerDelegate {
    func configureLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            loadData()
            break
        case .notDetermined , .denied , .restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation = location
    }
}

