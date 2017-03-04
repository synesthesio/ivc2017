//
//  AttendeeTableVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AttendeeTableVC: UITableViewController {

	
	@IBOutlet var tblView: UITableView!
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	var attendees:[Attendee]?

    override func viewDidLoad() {
        super.viewDidLoad()
				self.fetchAttendees(completion: { (att) in
					self.attendees = att
					self.tblView.reloadData()
				})

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func fetchAttendees(completion:@escaping([Attendee]) -> ()) {
		var att = [Attendee]()
		ref = FIRDatabase.database().reference()
		handle = ref?.child("users").observe(.value, with: { (snapshot) in
			for i in snapshot.children {
				let v = (i as! FIRDataSnapshot).value as! [String:AnyObject]
				let nm = v["name"] as! String
				let bio = v["bio"] as? String
				let link = v["link"] as? URL
				
				let a = Attendee(nm: nm, bi: bio, lnk: link)
				att.append(a)
			}
			completion(att)
		})
		
		
		
	}
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
				var ct = 1
			if let att = attendees {
				ct = att.count
			}
			return ct
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
			
				if let att = attendees {
					let at = att[indexPath.row] as! Attendee
					cell.textLabel?.text = at.name
					cell.detailTextLabel?.text = at.bio
				}
			
			

        // Configure the cell...

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let att = attendees {
			let attendee = att[indexPath.row] as! Attendee
			let vc = self.storyboard?.instantiateViewController(withIdentifier: "attendeevc") as! AttendeeVC
			vc.interests = attendee.bio
			vc.nameForTitle = attendee.name
			vc.link = attendee.link
			self.navigationController?.pushViewController(vc, animated: false)
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
