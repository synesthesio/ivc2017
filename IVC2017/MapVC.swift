//
//  MapVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
class MapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	var locations:[GMSMarker] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let camera = GMSCameraPosition.camera(withLatitude: 42.376362, longitude: 71.117088, zoom: 6.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		view = mapView
		mapView.delegate = self
		let a = GMSMarker(position: CLLocationCoordinate2D(latitude: 42.3770, longitude: 71.1167))
		a.title = "Campus"
		a.snippet = "Lehrer Hall"
		a.map = mapView
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func getCurLoc() -> CLLocationCoordinate2D?{
		let c = CLLocationManager()
		c.delegate = self
		c.desiredAccuracy = kCLLocationAccuracyBest
		//		c.activityType =
		c.startUpdatingLocation()
		c.startUpdatingHeading()
		return c.location?.coordinate
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
