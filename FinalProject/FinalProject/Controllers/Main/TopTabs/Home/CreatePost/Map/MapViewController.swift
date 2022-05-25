//
//  MapViewController.swift
//  FinalProject
//
//  Created by Dmitry on 19.04.22.
//

import GoogleMaps
import UIKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var markImageView: UIImageView!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet weak var selectPlaceButton: UIButton!
    
    let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    var getAddress: ((Address) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        setLightTheme()
        
        if CLLocationManager.locationServicesEnabled() {

            locationManager.startUpdatingLocation()

            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func setLightTheme() {
        addressTextField.setLightTheme()
        selectPlaceButton.setLightTheme(style: .basic)
    }
    
    @IBAction func selectPlaceButtonAction(_ sender: Any) {
        guard let addressString = addressTextField.text,
              let currentCoordinate = currentCoordinate else { return }

        let address = Address(latitude: currentCoordinate.latitude,
                              longitude: currentCoordinate.longitude,
                              addressString: addressString)
        getAddress(address)

        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Actions

extension MapViewController {
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
      
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
        
            guard let address = response?.firstResult(),
                  let lines = address.lines else { return }
        
            self?.currentCoordinate = address.coordinate
            self?.addressTextField.text = lines.joined(separator: "\n")
            
        }
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocode(coordinate: position.target)
        locationManager.stopUpdatingLocation()
    }
  
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            markImageView.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
  
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        markImageView.fadeOut(0.25)
        return false
    }
  
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        markImageView.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
}
