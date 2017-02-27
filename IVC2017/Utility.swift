//
//  Utility.swift
//  IVC2017
//
//  Created by synesthesia on 2/23/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

struct Utility {
	static func displayAlertWithHandler(_ title: String, message: String, from: UIViewController, cusHandler: ((UIAlertAction) -> Void)?){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: cusHandler)
		alert.addAction(defaultAction)
		from.present(alert, animated: true, completion: nil)
	}
	
	
	
	
}



//func placeMarker(name: String, addr: String, lat: NSString, long: NSString, map: GMSMapView)
//{
//	let latitude = lat.doubleValue
//	let longitude = long.doubleValue
//	let  position = CLLocationCoordinate2DMake(latitude, longitude)
//	let marker = GMSMarker(position: position)
////	marker.icon = UIImage(named: "mapview_pin_red")
//	marker.title = addr.replacingOccurrences(of:"", with: "")
//	marker.map = map
//}

struct Session {
	var day:String
	var time:String
	var addr:String?
	var location:String?
	var speaker:String?
	var title:String
	var mTime:Int
	var desc:String?
	init(d:String, tm:String, add:String?, loc:String?, spkr:String?, titl:String, mT:Int, dsc:String?) {
		day = d
		time = tm
		addr = add
		location = loc
		speaker = spkr
		title = titl
		mTime = mT
		desc = dsc
	}
}
struct Speaker {
	var degrees:String
	var bio:String
	var link:URL?
	var sessions:[Session]?
	var name:String
	init(dgrs:String, bi:String, lnk:URL?,sesh:[Session]?,nm:String) {
		degrees = dgrs
		bio = bi
		link = lnk
		sessions = sesh
		name = nm
	}
}

struct Attendee {
	var name:String
	var bio:String?
	var link:URL?
}
