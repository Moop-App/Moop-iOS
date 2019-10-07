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
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.showsUserLocation = true
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
        }
    }

    private let locationManager = CLLocationManager()

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
//        let requestURL = URL(string: "\(Config.baseURL)/code.json")!
//        AF.request(requestURL)
//            .validate(statusCode: [200])
//            .responseDecodable { [weak self] (response: AFDataResponse<MapInfo>) in
//                guard let self = self else { return }
//                switch response.result {
//                case .success(let result):
//                    self.mapView.addAnnotations(result.items)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//        }
        
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
        guard let theater = routeView.annotation as? Theater,
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
            let theater = routeView.annotation as? Theater,
            let url = URL(string: "kakaomap://route?sp=\(locValue.latitude),\(locValue.longitude)&ep=\(theater.lat),\(theater.lng)&by=PUBLICTRANSIT") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func openNaver() {
        let sname = "현위치".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let locValue = locationManager.location?.coordinate,
            let theater = routeView.annotation as? Theater,
            let url = URL(string: "nmap://route/public?slat=\(locValue.latitude)&slng=\(locValue.longitude)&sname=\(sname)&dlat=\(theater.lat)&dlng=\(theater.lng)&dname=\(theater.destinationName)&appname=com.kor45cw.Moop") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func openGoogle() {
        guard let locValue = locationManager.location?.coordinate,
            let theater = routeView.annotation as? Theater,
            let url = URL(string: "comgooglemaps://?saddr=\(locValue.latitude),\(locValue.longitude)&daddr=\(theater.lat),\(theater.lng)&directionsmode=transit") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
