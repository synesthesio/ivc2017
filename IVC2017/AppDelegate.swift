//
//  AppDelegate.swift
//  IVC2017
//
//  Created by synesthesia on 2/23/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		UserDefaults.standard.set(false, forKey: "loggedin")
		
		var mainController:UIViewController!
		if UserDefaults.standard.bool(forKey: "loggedin") != false {
			window = UIWindow.init(frame: UIScreen.main.bounds)
			mainController = EventTableVC() as! UIViewController
			let navigationController = UINavigationController(rootViewController: mainController)
			navigationController.navigationBar.isTranslucent = false
			window?.rootViewController = navigationController
			window!.makeKeyAndVisible()
			
		} else {
//			 mainController = EventTableVC() as! UIViewController
		}
		FIRApp.configure()
		
		var configErr:NSError?
//		GGLContext.sharedInstance().configureWithError(configErr)
		
		
		GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self
		GMSServices.provideAPIKey("AIzaSyAcaDWJlg1nUohWxoXy3XInH37IeZEc42k")
		
		return true
	}
	
	
	
	
	@available(iOS 9.0, *)
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
	}
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
  // ...
		if let error = error {
			print("PrinterrordidSignInFor: \(error.localizedDescription)")
			return
		}
		
		guard let authentication = user.authentication else { return }
		let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                    accessToken: authentication.accessToken)
  // ...
		FIRAuth.auth()?.signIn(with: credential, completion: { (user, err) in
			if let er = err {
				print("Print er signIn with credential: \(er.localizedDescription)")	
			}
			if let u = user {
				print("perfunctory placeholder")
				if UserDefaults.standard.bool(forKey: "loggedin") != true {
					
				} else {
					print("perfunctory placeholder")
				}
			}
		})
	}
	
	func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
	            withError error: NSError!) {
		print("perfunctory placeholder")
		// Perform any operations when the user disconnects from app here.
		// ...
	}
	
	
	
	
	

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "IVC2017")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

