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

	var locationData:[EventLocation]!

	static func displayAlertWithHandler(_ title: String, message: String, from: UIViewController, cusHandler: ((UIAlertAction) -> Void)?){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: cusHandler)
		alert.addAction(defaultAction)
		from.present(alert, animated: true, completion: nil)
	}
	
	
	static func createViewForMarkerIcon(address: EventLocation)-> UIView{
		var imgForBg:UIImage?
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
		var label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		label.textAlignment = NSTextAlignment.center
		label.text = address.title
		switch address.isRestaurant {
		case true:
			imgForBg = UIImage(named: "res1")
		default:
			imgForBg = UIImage(named: "ev1")
		}
		
	view.addSubview(label)
	view.addSubview(UIImageView(image: imgForBg!))
	return view
	}
	
//	static let yellowClr = UIColor(red:1.00, green:0.83, blue:0.38, alpha:1.0)
	static let yellowClr = UIColor.white
	static let purpleClr = UIColor(red:0.15, green:0.05, blue:0.34, alpha:1.0)
	static let redClr = UIColor(red:0.54, green:0.05, blue:0.05, alpha:1.0)

	class GooglePlacesRequestBuilder {
		/**
		Build a query string from a dictionary
		
		:param: parameters Dictionary of query string parameters
		:returns: The properly escaped query string
		*/
		class func query(parameters: [String: AnyObject]) -> String {
			var components: [(String, String)] = []
			for key in Array(parameters.keys).sorted(by: <) {
				let value: AnyObject! = parameters[key]
				components += [(escape(string: key), ("\(escape(string: value as! String))"))]
			}
			let mappedComponents = components.map {
				
				( component) -> String in
				let output = "\(component.0)=\(component.1)"
				return output
			}
			return mappedComponents.joined(separator: "&")
		}
		
		
		class func escape(string: String) -> String {
			let legalURLCharactersToBeEscaped = CharacterSet(charactersIn: ":/?&=;+!@#$()',*")
			return string.addingPercentEncoding(withAllowedCharacters: legalURLCharactersToBeEscaped)!
			//CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, ) as String
		}
		
		class func sendRequest(url: String, params: [String: String], success: @escaping (NSDictionary) -> ()) {
			let request = NSMutableURLRequest(
				url: NSURL(string: "\(url)?\(query(parameters: params as [String : AnyObject]))")! as URL
			)
			print("REQUEST: \(request)")
			
			let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
				self.handleResponse(data: data as NSData!, response: response as? HTTPURLResponse, error: error as NSError!, success: success)
			}
			
			task.resume()
		}
		
		class func handleResponse(data: NSData!, response: HTTPURLResponse!, error: NSError!, success: @escaping (NSDictionary) -> ()) {
			let mainVC = UIApplication.shared.delegate?.window??.rootViewController
			let currentVC = (mainVC as! UINavigationController).visibleViewController!
			if let error = error {
				print("GooglePlaces Error: \(error.localizedDescription)")
				Utility.displayAlertWithHandler("Sorry, we can’t find directions right now. Try again when you have better reception", message: "", from: currentVC, cusHandler: nil)
				return
			}
			
			if response == nil {
				print("GooglePlaces Error: No response from API")
				Utility.displayAlertWithHandler("Sorry, we can’t find directions right now. Try again when you have better reception", message: "", from: currentVC, cusHandler: nil)
				
				return
			}
			
			if response.statusCode != 200 {
				print("GooglePlaces Error: Invalid status code \(response.statusCode) from API")
				Utility.displayAlertWithHandler("GooglePlaces Error: Invalid status code \(response.statusCode) from API", message: "", from: currentVC, cusHandler: nil)
				return
			}
			do
			{
				let json: NSDictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! NSDictionary
				
				if let status = json["status"] as? String {
					if status != "OK" {
						print("GooglePlaces API Error: \(status)")
						Utility.displayAlertWithHandler("We could not establish a route to that destination", message: "", from: currentVC, cusHandler: nil)
						return
					}
					DispatchQueue.main.async(execute: {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
						success(json)
					})
				}
			} catch let caught as NSError {
				print("An error occured: \(caught.localizedDescription)")
				return
			} catch {
				print("something else didn't work")
				
			}
		}
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
	var uID:String?
	init(nm:String, bi:String?, lnk:URL?, id:String?) {
		self.name = nm
		self.bio = bi
		self.link = lnk
		self.uID = id
	}
}

struct EventLocation {
	var address:String!
	var latitude:CLLocationDegrees!
	var longitude:CLLocationDegrees!
	var title:String!
	var isRestaurant:Bool!
	init(addr:String,lat:CLLocationDegrees,long:CLLocationDegrees,titl:String, res:Bool) {
		self.address = addr
		self.latitude = lat
		self.longitude = long
		self.title = titl
		self.isRestaurant = res
	}
}
extension Date {
	func dayOfWeek()->String? {
		let f = DateFormatter()
		f.dateFormat = "EEEE"
		return f.string(from: self).lowercased()
	}
}

extension UIImage {
	
	func colored(with color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContext(size)
		let context = UIGraphicsGetCurrentContext()
		context!.setFillColor(color.cgColor);
		let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
		context!.fill(rect);
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image!
	}
}

let gMapsApiKey = "AIzaSyAcaDWJlg1nUohWxoXy3XInH37IeZEc42k"





