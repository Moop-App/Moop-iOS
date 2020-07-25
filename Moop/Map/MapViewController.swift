//
//  MapViewController.swift
//  Moop
//
//  Created by kor45cw on 30/07/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import MapKit
import Networking

class MapViewController: UIViewController {
    
    @IBOutlet private weak var routeView: MapRouteView! {
        didSet {
            routeView.delegate = self
        }
    }
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var searchView: UIView! {
        didSet {
            searchView.elevate(elevation: 1)
        }
    }
    @IBOutlet private weak var textField: FormTextField! {
        didSet {
            textField.delegate = self
        }
    }
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

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
        API.shared.requestMapData { [weak self] (result: Result<MapInfo, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.mapView.addAnnotations(result.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !textField.text.isNilOrEmpty else { return false }
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            let item = mapView.annotations.first(where: { $0.title??.contains(text) ?? false }) else {
                return
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        mapView.setRegion(MKCoordinateRegion(center: item.coordinate, span: span), animated: true)
        mapView.selectAnnotation(item, animated: true)
        
        routeView.annotation = item
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.routeView.transform = CGAffineTransform(translationX: 0, y: -200)
        }, completion: nil)
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
        if routeView.annotation != nil {
            routeView.annotation = view.annotation
            return
        }
        
        routeView.annotation = view.annotation
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.routeView.transform = CGAffineTransform(translationX: 0, y: -200)
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.routeView.transform = CGAffineTransform(translationX: 0, y: 200)
        }, completion: { _ in
            self.routeView.annotation = nil
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    private func makeInAppDirection() {
        guard let theater = routeView.annotation as? TheaterMapInfo,
            let locValue = locationManager.location?.coordinate else { return }
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: locValue))
        directionRequest.destination = theater.mapItem
        directionRequest.transportType = .any
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension MapViewController: RouteDelegate {
    func route(type: RouteType) {
        switch type {
        case .kakao:
            openKakao()
        case .naver:
            openNaver()
        case .google:
            openGoogle()
        case .apple:
            makeInAppDirection()
        }
    }
    
    private func openKakao() {
        guard let locValue = locationManager.location?.coordinate,
            let theater = routeView.annotation as? TheaterMapInfo,
            let url = URL(string: "kakaomap://route?sp=\(locValue.latitude),\(locValue.longitude)&ep=\(theater.lat),\(theater.lng)&by=PUBLICTRANSIT") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func openNaver() {
        let sname = "현위치".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let locValue = locationManager.location?.coordinate,
            let theater = routeView.annotation as? TheaterMapInfo,
            let url = URL(string: "nmap://route/public?slat=\(locValue.latitude)&slng=\(locValue.longitude)&sname=\(sname)&dlat=\(theater.lat)&dlng=\(theater.lng)&dname=\(theater.destinationName)&appname=com.kor45cw.Moop") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
    
    private func openGoogle() {
        guard let locValue = locationManager.location?.coordinate,
            let theater = routeView.annotation as? TheaterMapInfo,
            let url = URL(string: "comgooglemaps://?saddr=\(locValue.latitude),\(locValue.longitude)&daddr=\(theater.lat),\(theater.lng)&directionsmode=transit") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

class FormTextField: UITextField {
    @IBInspectable var inset: CGFloat = 0
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
}
