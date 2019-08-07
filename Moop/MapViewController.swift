//
//  MapViewController.swift
//  Moop
//
//  Created by kor45cw on 30/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.showsUserLocation = true
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
        }
    }

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
        
        request()
    }
    
    private func request() {
        let requestURL = URL(string: "\(Config.baseURL)/code.json")!
        AF.request(requestURL)
            .validate(statusCode: [200])
            .responseDecodable { [weak self] (response: DataResponse<MapInfo>) in
                guard let self = self else { return }
                switch response.result {
                case .success(let result):
                    self.mapView.addAnnotations(result.items)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("DID SELECT", view.annotation)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.wrapperView.transform = CGAffineTransform(translationX: 0, y: -200)
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("DID DESELECT")
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.wrapperView.transform = CGAffineTransform(translationX: 0, y: 200)
        }, completion: nil)
    }
}