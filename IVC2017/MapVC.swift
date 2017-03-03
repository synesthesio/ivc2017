//
//  MapVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import GoogleMaps


class MapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
	
	
	
	@IBOutlet var viewMap: GMSMapView!
	
//	@IBOutlet weak var directionInfoView: UIView!
	
	
//	@IBOutlet weak var viewMap: GMSMapView!
	
	
	//var selectedOrder = -1
	var locationData:[EventLocation]!
	//initial location that the map points at (New York) if no location is indicated
	let INITIAL_LATITUDE: CLLocationDegrees = 42.384075
	let INITIAL_LONGITUDE: CLLocationDegrees = -71.116088
	let cameraDefaultZoom: Float = 13.0
	
	var locationManager:CLLocationManager!
	
	var didFindMyLocation = false
	
	var mapTasks = MapTasks()
	
	var locationMarker: GMSMarker!
	
	var originMarker: GMSMarker!
	
	var destinationMarker: GMSMarker!
	
	var routePolyline: GMSPolyline!
	
	var markersArray: Array<GMSMarker> = []
	
	var waypointsArray: Array<String> = []
	
	var travelMode = TravelModes.driving
	
	
	//display address and time to get there
	@IBOutlet weak var directionInfoView: UIView!
	@IBOutlet weak var addressLabelInfo: UILabel!
//	@IBOutlet weak var travelTypeButton: UIButton!
	@IBOutlet weak var timeLabelInfo: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		
		let geoMus = EventLocation(addr: "120 Oxford St, Cambridge, MA 02140", lat: 42.384075, long: -71.116088, titl: "Geo. Museum", res:false)
		let wassHall = EventLocation(addr: "1585 Massachusetts Ave, Cambridge, MA 02138", lat: 42.379334, long: -71.119168, titl: "Wasserstein Hall", res:false)
		let foMu = EventLocation(addr: "481 Cambridge St, Allston, MA 02134", lat: 42.371597, long: -71.084333, titl: "[FoMu] Premium Alternative Ice Cream + Café", res: true)
		let wHP = EventLocation(addr: "487 Cambridge St, Allston, MA 02134", lat: 42.35388, long: -71.137177, titl: "Whole Heart Provisions", res: true)
		let vo2 = EventLocation(addr: "1001 Massachusetts Ave, Cambridge, MA 02138", lat: 42.369692, long: -71.111133, titl: "VO2 Vegan Cafe", res: true)
		let lAUO = EventLocation(addr: "765 Massachusetts Ave, Cambridge, MA 02139", lat: 42.366644, long: -71.10537, titl: "Life Alive Cafe", res: true)
		let wR = EventLocation(addr: "71 Elm St, Watertown, MA 02472", lat: 42.365288, long: -71.155924, titl: "Wild Rice Vegan Cafe", res: true)
		let rL = EventLocation(addr: "600 Mt Auburn St, Watertown, MA 02472", lat: 42.370991, long: -71.158643, titl: "Red Lentil Restaurant", res: true)
		let vG = EventLocation(addr: "450 Massachusetts Ave, Cambridge, MA 02139", lat: 42.363424, long: -71.101296, titl: "Veggie Galaxy", res: true)
		locationData = [geoMus,wassHall, foMu, wHP, vo2, lAUO, wR, rL, vG]
		
		locationManager = CLLocationManager()
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		//		locationManager.requestAlwaysAuthorization()
		let camera = GMSCameraPosition.camera(withLatitude: INITIAL_LATITUDE, longitude: INITIAL_LONGITUDE, zoom: 11)
		viewMap = GMSMapView.map(withFrame: self.viewMap.bounds, camera: camera)
		locationManager.startUpdatingLocation()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		if let myLoc = viewMap.myLocation {
			print("Printmyloc: \(myLoc)")

		}
		viewMap.mapType = .normal
		viewMap.camera = camera
		viewMap.delegate = self
		viewMap.isMyLocationEnabled = true
		view = viewMap
		
//		for address in mapAddresses{
		
		  for address in locationData {
				let marker = GMSMarker(position: CLLocationCoordinate2DMake(address.latitude, address.longitude))
			marker.snippet = address.title
//			let markerIcon: UIImage = self.imageFromView(view: Utility.createViewForMarkerIcon(address: address))
				let res = UIImage(named: "res1")
				let ev = UIImage(named: "ev1")
				if address.isRestaurant == true {
					marker.icon = self.scaleUIImageToSize(image: res!, size: CGSize(width: 37.5, height: 50))
				} else {
					marker.icon = self.scaleUIImageToSize(image: ev!, size: CGSize(width: 37.5, height: 50))
			}
			marker.title = address.title
			marker.snippet = address.address
			marker.map = viewMap
		}

	}
	
	
	
	//Takes a Screenshot of View (For map marker icon)
	func imageFromView(view: UIView) -> UIImage
	{
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
		view.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!;
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
	
	 let location = locations.last
		
		let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
		viewMap.animate(to: camera)
		
		//Finally stop updating location otherwise it will come again and again in this delegate
		self.locationManager.stopUpdatingLocation()

//
print("perfunctory placeholder")
	}

//	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//	{
//		print(locations)
//		viewMap.delegate = self
//		currentLocation =     CLLocationCoordinate2D(latitude:CLLocationDegrees(locations[0].coordinate.latitude), longitude:CLLocationDegrees(locations[0].coordinate.longitude))
//		viewMap.camera = GMSCameraPosition.camera(withTarget:locations[0].coordinate, zoom: 10.0)
//		mapview.isMyLocationEnabled = true
//	}

	
	@objc
	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if !didFindMyLocation {
			let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
			viewMap.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
			viewMap.settings.myLocationButton = true
			
			didFindMyLocation = true
			
		}
	}
	
	
	// MARK: IBAction method implementation
//	func dismiss() {
		
//		dismiss(animated: true, completion: {
//			Void in
//			self.navIcon.image = UIImage(named: "ic_nav")?.withRenderingMode(.alwaysOriginal)
//		})
//	}
	
	
	
	
	@IBAction func findAddress(sender: AnyObject) {
		let addressAlert = UIAlertController(title: "Address Finder", message: "Type the address you want to find:", preferredStyle: UIAlertControllerStyle.alert)
		
		addressAlert.addTextField { (textField) -> Void in
			textField.placeholder = "Address?"
		}
		
		let findAction = UIAlertAction(title: "Find Address", style: UIAlertActionStyle.default) { (alertAction) -> Void in
			let address = (addressAlert.textFields![0] as UITextField).text! as String
			
			self.mapTasks.geocodeAddress(address: address, withCompletionHandler: { (status, success) -> Void in
				if !success {
					print(status)
					
					if status == "ZERO_RESULTS" {
						self.showAlertWithMessage(message: "The location could not be found.")
					}
				}
				else {
					let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
					self.viewMap.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
					self.setupLocationMarker(coordinate: coordinate)
				}
			})
		}
		
		let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
			
		}
		
		addressAlert.addAction(findAction)
		addressAlert.addAction(closeAction)
		present(addressAlert, animated: true, completion: nil)
	}
	
	
	/*@IBAction func createRoute(sender: AnyObject) {
	let addressAlert = UIAlertController(title: "Create Route", message: "Connect locations with a route:", preferredStyle: UIAlertControllerStyle.alert)
	
	addressAlert.addTextField { (textField) -> Void in
	textField.placeholder = "Origin?"
	}
	
	addressAlert.addTextField { (textField) -> Void in
	textField.placeholder = "Destination?"
	}
	
	let createRouteAction = UIAlertAction(title: "Create Route", style: UIAlertActionStyle.default) { (alertAction) -> Void in
	if let _ = self.routePolyline {
	self.clearRoute()
	self.waypointsArray.removeAll(keepingCapacity: false)
	}
	
	let origin = (addressAlert.textFields![0] as UITextField).text! as String
	print(origin)
	
	let destination = (addressAlert.textFields![1] as UITextField).text! as String
	print(destination)
	
	self.mapTasks.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
	if success {
	self.configureMapAndMarkersForRoute()
	self.drawRoute()
	self.displayRouteInfo()
	}
	else {
	ShooegoDeliveryTools.displayAlert(title: "Sorry, we can’t find directions right now. Try again when you have better reception", message: "", from: self)
	}
	})
	}
	
	let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
	
	}
	addressAlert.addAction(createRouteAction)
	addressAlert.addAction(closeAction)
	present(addressAlert, animated: true, completion: nil)
	}*/
	
	
	@IBAction func changeTravelMode(sender: AnyObject) {
		let actionSheet = UIAlertController(title: "Travel Mode", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
		
		let drivingModeAction = UIAlertAction(title: "Driving", style: UIAlertActionStyle.default) { (alertAction) -> Void in
			self.travelMode = TravelModes.driving
			
			if let _ = self.routePolyline{
				self.clearRoute()
				self.recreateRoute(originLocation: LocationService.sharedInstance.currentLocation!, destinationLocation: CLLocation(latitude: self.previousMarker!.position.latitude, longitude: self.previousMarker!.position.longitude))
			}
			
//			self.travelTypeButton.setImage(UIImage(named: "mapview_bt_driving"), for: .normal)
		}
		
		let walkingModeAction = UIAlertAction(title: "Walking", style: UIAlertActionStyle.default) { (alertAction) -> Void in
			self.travelMode = TravelModes.walking
			
			if let _ = self.routePolyline{
				self.clearRoute()
				self.recreateRoute(originLocation: LocationService.sharedInstance.currentLocation!, destinationLocation: CLLocation(latitude: self.previousMarker!.position.latitude, longitude: self.previousMarker!.position.longitude))
			}
			
//			self.travelTypeButton.setImage(UIImage(named: "mapview_bt_walking"), for: .normal)
		}
		
		let bicyclingModeAction = UIAlertAction(title: "Bicycling", style: UIAlertActionStyle.default) { (alertAction) -> Void in
			self.travelMode = TravelModes.bicycling
			
			if let _ = self.routePolyline{
				self.clearRoute()
				self.recreateRoute(originLocation: LocationService.sharedInstance.currentLocation!, destinationLocation: CLLocation(latitude: self.previousMarker!.position.latitude, longitude: self.previousMarker!.position.longitude))
			}
//			self.travelTypeButton.setImage(UIImage(named: "mapview_bt_biking"), for: .normal)
		}
		
		let transitModeAction = UIAlertAction(title: "Transit", style: UIAlertActionStyle.default) { (alertAction) -> Void in
			self.travelMode = TravelModes.transit
			
			if let _ = self.routePolyline{
				
				self.recreateRoute(originLocation: LocationService.sharedInstance.currentLocation!, destinationLocation: CLLocation(latitude: self.previousMarker!.position.latitude, longitude: self.previousMarker!.position.longitude))
			}
			
//			self.travelTypeButton.setImage(UIImage(named: "mapview_bt_transit"), for: .normal)
		}
		
		
		let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
			
		}
		
		actionSheet.addAction(drivingModeAction)
		actionSheet.addAction(walkingModeAction)
		actionSheet.addAction(bicyclingModeAction)
		actionSheet.addAction(transitModeAction)
		actionSheet.addAction(closeAction)
		present(actionSheet, animated: true, completion: nil)
	}
	
	
	// MARK: CLLocationManagerDelegate method implementation
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
			
			viewMap.isMyLocationEnabled = true
		}
	}
	
	
	// MARK: Custom method implementation
	
	func showAlertWithMessage(message: String) {
		let alertController = UIAlertController(title: "GoogleMaps", message: message, preferredStyle: UIAlertControllerStyle.alert)
		
		let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
		}
		alertController.addAction(closeAction)
		present(alertController, animated: true, completion: nil)
	}
	
	
	func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
		if locationMarker != nil {
			locationMarker.map = nil
		}
		
		locationMarker = GMSMarker(position: coordinate)
		locationMarker.map = viewMap
		
		//locationMarker.title = mapTasks.fetchedFormattedAddress
		locationMarker.appearAnimation = .pop
		locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
		
		locationMarker.opacity = 0.75
		
		locationMarker.isFlat = true
		//locationMarker.snippet = "The best place on earth."
	}
	
	
	func configureMapAndMarkersForRoute() {
		viewMap.camera = GMSCameraPosition.camera(withTarget: viewMap.camera.target, zoom: viewMap.camera.zoom)
		
		originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
		originMarker.map = nil//self.viewMap
		
		destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
		destinationMarker.map = nil//self.viewMap
		
		if waypointsArray.count > 0 {
			for waypoint in waypointsArray {
				let lat: Double = (waypoint.components(separatedBy: ",")[0] as NSString).doubleValue
				let lng: Double = (waypoint.components(separatedBy: ",")[1] as NSString).doubleValue
				let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
				marker.map = viewMap
				marker.icon = GMSMarker.markerImage(with: UIColor.purple)
				markersArray.append(marker)
			}
		}
	}
	
	
	func drawRoute() {
		let route = mapTasks.overviewPolyline["points"] as! String
		
		let path: GMSPath = GMSMutablePath(fromEncodedPath: route)!
		//path.
		routePolyline = GMSPolyline(path: path)
		routePolyline.strokeWidth = 4.0
		
		let styles = [GMSStrokeStyle.solidColor(UIColor(red: 0x00/255.0, green: 0x96/255.0, blue: 0xFF/255.0, alpha: 1.0)),
		              GMSStrokeStyle.solidColor(UIColor.clear)];
		
		let lengths = [50, 50];
//		routePolyline.spans = GMSStyleSpans(path, styles, lengths as [NSNumber], kGMSLengthRhumb)
		routePolyline.spans = GMSStyleSpans(path, styles, lengths as [NSNumber], .rhumb)
		
		routePolyline.geodesic = true
		routePolyline.map = viewMap
	}
	
	func displayRouteInfo() {
		
		timeLabelInfo.text = mapTasks.totalDuration
	}
	
	
	func clearRoute() {
		
		
		if let _ = originMarker{
			originMarker.map = nil
			destinationMarker.map = nil
			routePolyline.map = nil
			
			originMarker = nil
			destinationMarker = nil
			routePolyline = nil
		}
		
		if markersArray.count > 0 {
			for marker in markersArray {
				marker.map = nil
			}
			markersArray.removeAll(keepingCapacity: false)
		}
	}
	
	
	func recreateRoute(originLocation: CLLocation, destinationLocation: CLLocation) {
		if let _ = routePolyline {
			clearRoute()
			
		}
		getDirectionsBetweenAddresses(location1: originLocation, location2: destinationLocation, getLocCompletionHandler: {( success, error) -> Void in
			if(error != nil){
			}else{
				print("worked")
			}
		})
	}
	
	
	
	// MARK: GMSMapViewDelegate method implementation
	func hideDirectionInfo()
	{
		directionInfoView.isHidden = true
//		travelTypeButton.isHidden = true
	}
	func displayDirectionInfo(){
		directionInfoView.isHidden = false
//		travelTypeButton.isHidden = false
		
		
	}
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		markerTaps = 1
		hideDirectionInfo()
		if(previousMarker != nil)
		{
			previousMarker!.icon = scaleUIImageToSize(image: previousMarker!.icon!, size: CGSize(width: 30, height: 40))
			clearRoute()
		}
		
	}
	
	func scaleUIImageToSize(image: UIImage, size: CGSize) -> UIImage {
		
		let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
		
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		image.draw(in: CGRect(origin: CGPoint.zero, size: size))
		
		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return scaledImage!
	}
	
	var previousMarker: GMSMarker?
	var markerTaps = 0
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		
		print(markerTaps)
		if locationManager.location != nil
		{
			if(previousMarker == marker && markerTaps % 2 == 0)
			{
				hideDirectionInfo()
				marker.icon = scaleUIImageToSize(image: marker.icon!, size: CGSize(width: 30, height: 40))
				previousMarker = nil
				clearRoute()
			}
			else
			{
				markerTaps = 1
				addressLabelInfo.text = marker.title
				displayDirectionInfo()
				marker.icon = scaleUIImageToSize(image: marker.icon!, size: CGSize(width: 37.5, height: 50))
				if(previousMarker != nil && previousMarker != marker)
				{
					previousMarker!.icon = scaleUIImageToSize(image: previousMarker!.icon!, size: CGSize(width: 30, height: 40))
				}
				
				previousMarker = marker
				if let _ = routePolyline {
					clearRoute()
					
					recreateRoute(originLocation: locationManager.location!, destinationLocation: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude))
				}else{
					if(LocationService.sharedInstance.currentLocation != nil){
						getDirectionsBetweenAddresses(location1: LocationService.sharedInstance.currentLocation!, location2: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude), getLocCompletionHandler: {(success, error) -> Void in
							if(error != nil){
							}else{
								print("worked")
							}
						})
					}
				}
			}
		}
		else
		{
			Utility.displayAlertWithHandler("This application needs permission to determine your location and give you directions. Please allow us to use location services from Settings.", message: "", from: self, cusHandler: nil)
		}
		markerTaps += 1
		return true
	}
	
	//Retreive address of location using Google Places API
	func getLocalAddressString(){
		
		Utility.GooglePlacesRequestBuilder.sendRequest(
			url: "https://maps.googleapis.com/maps/api/geocode/json",
			
			params: [
				
				"latlng": "\(locationManager.location?.coordinate.latitude),\(locationManager.location?.coordinate.longitude)",
				"location_type": "ROOFTOP",  //maximum precision
				"key": gMapsApiKey
			]
		) { json in
			let address = json as! [String: AnyObject]
			//print(address)
			print(((address["results"] as! [AnyObject])[0] as! [String: AnyObject])["formatted_address"] as! String)
			
		}
	}
	
	
	
	//Get directions using Google API
	func getDirectionsBetweenAddresses(location1: CLLocation, location2: CLLocation, getLocCompletionHandler : (_ success : Bool, _ error : NSError?) -> Void) {
		
		var address1 = ""
		var address2 = ""
		
		Utility.GooglePlacesRequestBuilder.sendRequest(
			url: "https://maps.googleapis.com/maps/api/geocode/json",
			
			params: [
				
				"latlng": "\(location1.coordinate.latitude),\(location1.coordinate.longitude)",
				"location_type": "ROOFTOP",  //maximum precision
				"key": gMapsApiKey
			]
		) { json in
			let address = json as! [String: AnyObject]
			
			print(((address["results"] as! [AnyObject])[0] as! [String: AnyObject])["formatted_address"] ?? "")
			
			address1 = ((address["results"] as! [AnyObject])[0] as! [String: AnyObject])["formatted_address"] as! String
			
			Utility.GooglePlacesRequestBuilder.sendRequest(
				url: "https://maps.googleapis.com/maps/api/geocode/json",
				params: [
					"latlng": "\(location2.coordinate.latitude),\(location2.coordinate.longitude)",
					"location_type": "ROOFTOP",  //maximum precision
					"key": gMapsApiKey
				]
			) { json in
				let address = json as! [String: AnyObject]
				//print(address)
				//print(address["results"][0]["formatted_address"])
				address2 = ((address["results"] as! [AnyObject])[0] as! [String: AnyObject])["formatted_address"] as! String
				self.mapTasks.getDirections(origin: address1, destination: address2, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
					if success {
						self.configureMapAndMarkersForRoute()
						self.drawRoute()
						self.displayRouteInfo()
					}else{
					Utility.displayAlertWithHandler("Sorry, we can’t find directions right now. Try again when you have better reception", message: "", from: self, cusHandler: nil)

					}
				})
			}
		}
}
}










//class MapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
//
//	var locations:[GMSMarker] = []
//	var locationManager:CLLocationManager!
//	override func viewDidLoad() {
//		super.viewDidLoad()
//
//
//		if CLLocationManager.locationServicesEnabled() {
//			locationManager = CLLocationManager()
//			locationManager.delegate = self
//			locationManager.desiredAccuracy = kCLLocationAccuracyBest
//			locationManager.requestAlwaysAuthorization()
//			//		locationManager.requestWhenInUseAuthorization()
//			locationManager.startUpdatingLocation()
//		} else {
//			Utility.displayAlertWithHandler("Location Unavailable", message: "Please enable location services.", from: self, cusHandler: nil)
//		}
//
//
//
//		let camera = GMSCameraPosition.camera(withLatitude: 42.380098, longitude: -71.116629, zoom: 6.0)
//		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//		view = mapView
//		mapView.delegate = self
//		mapView.isMyLocationEnabled = true
//		let a = GMSMarker(position: CLLocationCoordinate2D(latitude: 42.3770, longitude: -71.1167))
//		a.title = "Campus"
//		a.snippet = "Lehrer Hall"
//		a.map = mapView
//		// Do any additional setup after loading the view, typically from a nib.
//	}
//
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//		// Dispose of any resources that can be recreated.
//	}
//}
