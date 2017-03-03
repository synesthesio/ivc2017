
//
//  MapTasks.swift
//  GMapsDemo
//
//  Created by Gabriel Theodoropoulos on 29/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTasks: NSObject {
	
	let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
	
	var lookupAddressResults: [String: AnyObject]!
	
	var fetchedFormattedAddress: String!
	
	var fetchedAddressLongitude: Double!
	
	var fetchedAddressLatitude: Double!
	
	let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
	
	var selectedRoute: [String: AnyObject]!
	
	var overviewPolyline: [String: AnyObject]!
	
	var originCoordinate: CLLocationCoordinate2D!
	
	var destinationCoordinate: CLLocationCoordinate2D!
	
	var originAddress: String!
	
	var destinationAddress: String!
	
	var totalDistanceInMeters: UInt = 0
	
	var totalDistance: String!
	
	var totalDurationInSeconds: UInt = 0
	
	var totalDuration: String!
	
	
	override init() {
		super.init()
	}
	
	
	func geocodeAddress(address: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
		if let lookupAddress = address {
			var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
			
			geocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
			//stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
			
			let geocodeURL = NSURL(string: geocodeURLString)
			
			DispatchQueue.main.async {
				
				let geocodingResultsData = NSData(contentsOf: geocodeURL! as URL)
				
				do{
					let dictionary: [String: AnyObject] = (try! JSONSerialization.jsonObject(with: geocodingResultsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String: AnyObject]
					
					let status = dictionary["status"] as! String
					if status == "OK" {
						let allResults = dictionary["results"] as! Array<[String: AnyObject]>
						self.lookupAddressResults = allResults[0]
						
						// Keep the most important values.
						self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
						let geometry = self.lookupAddressResults["geometry"] as! [String: AnyObject]
						self.fetchedAddressLongitude = ((geometry["location"] as! [String: AnyObject])["lng"] as! NSNumber).doubleValue
						self.fetchedAddressLatitude = ((geometry["location"] as! [String: AnyObject])["lat"] as! NSNumber).doubleValue
						completionHandler(status, true)
					}
					else {
						completionHandler(status, false)
					}
				}
			}
		}
		else {
			completionHandler("No valid address.", false)
		}
	}
	
	
	func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: TravelModes!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
		
		if let originLocation = origin {
			if let destinationLocation = destination {
				var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
				
				if let routeWaypoints = waypoints {
					directionsURLString += "&waypoints=optimize:true"
					
					for waypoint in routeWaypoints {
						directionsURLString += "|" + waypoint
					}
				}
				
				if let _ = travelMode {
					var travelModeString = ""
					
					switch travelMode.rawValue {
					case TravelModes.walking.rawValue:
						travelModeString = "walking"
						
					case TravelModes.bicycling.rawValue:
						travelModeString = "bicycling"
						
					case TravelModes.transit.rawValue:
						travelModeString = "transit"
						
					default:
						travelModeString = "driving"
					}
					directionsURLString += "&mode=" + travelModeString
				}
				
				
				directionsURLString = (directionsURLString as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
				
				let directionsURL = NSURL(string: directionsURLString)
				
				DispatchQueue.main.async {
					
					let directionsData = NSData(contentsOf: directionsURL! as URL)
					
					do{
						if(directionsData != nil){
							if let dictionary: [String: AnyObject] = ((try! JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: AnyObject]){
								
								let status = dictionary["status"] as! String
								
								if status == "OK" {
									self.selectedRoute = (dictionary["routes"] as! Array<[String: AnyObject]>)[0]
									
									self.overviewPolyline = self.selectedRoute["overview_polyline"] as! [String: AnyObject]
									
									let legs = self.selectedRoute["legs"] as! Array<[String: AnyObject]>
									
									let startLocationDictionary = legs[0]["start_location"] as! [String: AnyObject]
									self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
									
									let endLocationDictionary = legs[legs.count - 1]["end_location"] as! [String: AnyObject]
									self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
									
									self.originAddress = legs[0]["start_address"] as! String
									self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
									
									self.calculateTotalDistanceAndDuration()
									
									completionHandler(status, true)
								}
								else {
									completionHandler(status, false)
									
								}
							}else{
								completionHandler("No Directions data", false)
							}
						}else{
							completionHandler("No response from Directions", false)
						}
					}
				}
			}
			else {
				completionHandler("Destination is nil.", false)
			}
		}
		else {
			completionHandler("Origin is nil", false)
		}
	}
	
	
	func calculateTotalDistanceAndDuration() {
		let legs = self.selectedRoute["legs"] as! Array<[String: AnyObject]>
		
		totalDistanceInMeters = 0
		totalDurationInSeconds = 0
		
		for leg in legs {
			totalDistanceInMeters += (leg["distance"] as! [String: AnyObject])["value"] as! UInt
			totalDurationInSeconds += (leg["duration"] as! [String: AnyObject])["value"] as! UInt
		}
		
		
		let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
		totalDistance = "Total Distance: \(distanceInKilometers) Km"
		
		
		let mins = totalDurationInSeconds / 60
		let hours = totalDurationInSeconds / 3600
		let remainingMins = mins % 60
		
		var durationString = "\(mins) min"
		if(hours > 0)
		{
			durationString = "\(hours) h, \(remainingMins) min"
		}
		totalDuration = durationString //"Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
	}
}
enum TravelModes: Int {
	case driving
	case walking
	case bicycling
	case transit
}
