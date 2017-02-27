//
//  EventTableVCTableViewController.swift
//  IVC2017
//
//  Created by synesthesia on 2/25/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class EventTableVC: UITableViewController {
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	var friSessions:[Session]?
	var satSessions:[Session]?
	var sunSessions:[Session]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
			 self.fetchCalendarEvents(forDay: "friday", completion: { (friSesh) in
				self.friSessions = friSesh
				self.tableView.reloadData()
			})
			
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		ref?.removeAllObservers()
		super.viewDidDisappear(animated)
	}
	
	func fetchSpeaker(name:String, completion:@escaping(Speaker) ->()) {
	
		//speakers = []
//		let speakersList = speakerString.components(separatedBy: ",")
	
		var spk:Speaker?
		ref = FIRDatabase.database().reference()
//		handle = ref?.observe(.value, with: { (snapshot) in
		handle = ref?.child("speakers").observe(.value, with: { (snapsho) in
		
			for speaker in snapsho.children {
				print("Print speaker: \(speaker)")
				let s = (speaker as! FIRDataSnapshot).value as! [String:AnyObject]
				print("Print s: \(s)")

			}
		
			if let snap1 = snapsho as? [String:AnyObject] {
				if let snap = snap1[name] as? [String:AnyObject] {
					let degree = snap["degrees"] as! String
					let bio = snap["bio"] as! String
					let lnk = snap["link"] as! URL
					spk = Speaker(dgrs: degree, bi: bio, lnk: lnk, sesh: nil, nm: snapsho.key)
				} else {
					spk = Speaker(dgrs: "", bi: "", lnk: nil, sesh: nil, nm: name)
				}
				completion(spk!)
				}
		})
	}
	
	
		func fetchCalendarEvents(forDay:String, completion: @escaping([Session]) ->()) {
		
			var sesh:[Session] = []
			ref = FIRDatabase.database().reference()
			handle = ref?.child("schedule").child(forDay).observe(.value, with: { (snapshot) in
				for child in snapshot.children {
					print("Printchild: \(child)")
					let v = (child as! FIRDataSnapshot).value as! [String:AnyObject]
					let speakerString = v["speaker"] as! String
					let add = v["addr"] as! String
					let titl = v["title"] as! String
					let loc = v["location"] as! String
					let time = v["time"] as! String
					var description = ""
					if let dsc = v["desc"] as? String {
						description = dsc
					}
					let k = (child as! FIRDataSnapshot).key 
					print("Printv: \(v)")
					print("Printk: \(k)")
					let a = Session(d: forDay, tm: time, add: add, loc: loc, spkr: speakerString, titl: titl, mT: Int(k)!, dsc: description)
//					let a = Session(d: forDay, tm: time, add: add, loc: loc, spkr: speakerString, titl: titl, mT: Double(k)!, d)
					sesh.append(a)
					}
					completion(sesh)
			})
		}
	
	//				if let friSesh = snapshot.childSnapshot(forPath: "schedule").childSnapshot(forPath: "friday").value as? [String:AnyObject] {
	//					print("Print frisesh: \(friSesh)")
	//				}
	//			})
//	func updateDB(){
//		handle = ref?.child("schedule").observe(.childAdded, with: { (snapshot) in
//			if let snap = snapshot.value as? [String:AnyObject] {
//				print("Print snap: \(snap)")
//			}
//		})
//	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
			var ct = 1
			if let count = self.friSessions?.count {
				if count > 0 {
				ct = count
				}
			}
			return ct
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionTVCell
			if friSessions != nil {
			if (friSessions?.count)! > 0 {
				if let contents = friSessions?[indexPath.row] {
//					var speakerLabelText = ""
//					for i in (contents.speaker)! {
//						speakerLabelText.append(i.name + i.degrees)
//					}
					cell.speakerLabel.text = contents.speaker
					cell.timeLabel.text = contents.time
					cell.locationLabel.text = contents.location
					cell.titleLabel.text = contents.title
				}
			 }
			}
			
        // Configure the cell...
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let sesh = self.friSessions {
		if sesh.count > 0 {
			 let content = sesh[indexPath.row]
				if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SessionVC") as? SessionVC {
					vc.address = content.addr
					vc.time = content.time
					vc.day = content.day
					vc.location = content.location
					vc.titl = content.title
					
					var speakerArr:[Speaker]
					if content.speaker != "" && content.speaker != nil {
						speakerArr = []
						if let sep = content.speaker?.components(separatedBy: ",") {
							for i in sep {
							 self.fetchSpeaker(name: String(describing:i), completion: { (speaker) in
									speakerArr.append(speaker)
								if content.desc != "" && content.desc != nil  {
									vc.desc = content.desc
								} else {
									var stringForDesc = ""
									for s in speakerArr {
										stringForDesc.append(s.bio)
									}
								}
							})
							}
						}
					} else {
						
					}
//					vc.speakers 
					
					
					self.navigationController?.pushViewController(vc, animated: false)
				}
			}
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
