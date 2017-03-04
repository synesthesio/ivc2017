//
//  RegistrationVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/25/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//



import UIKit
import AVFoundation
import AVKit
import Firebase
import GoogleSignIn
class RegistrationVC: UIViewController,UITextFieldDelegate, UIGestureRecognizerDelegate, GIDSignInUIDelegate {
	
 
 weak var constraintKeyboardHeight:NSLayoutConstraint!
 
	//  var adjustingView:UIView!
	
	var plyr:AVPlayer?
	override func viewDidLoad() {
		super.viewDidLoad()
		plyr = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!))
		self.navigationController?.navigationBar.isHidden = true
		uetf.delegate = self
		uptf.delegate = self
		self.view.layer.backgroundColor = UIColor(red: 205.0, green: 231.0, blue: 190.0, alpha: 1.0).cgColor
		setUpPlayer()
		//			adjustingView = UIView(frame: view.bounds)
		//			adjustingView.translatesAutoresizingMaskIntoConstraints = false

		let veV = UIVisualEffectView(frame: view.bounds)
//		let veV = UIVisualEffectView(frame: veVFrame)
		veV.translatesAutoresizingMaskIntoConstraints = false
		veV.effect = UIBlurEffect(style: .light)
		
		
//		plyr?.play()
		plyr?.isMuted = true
		NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd(notif:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: plyr?.currentItem)
		view.setNeedsUpdateConstraints()
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		view.backgroundColor = UIColor.lightGray
		//add subviews
		
		view.addSubview(uetf)
		view.addSubview(uptf)
		stack.addArrangedSubview(loginButton)
		stack.addArrangedSubview(skipButton)
		stack.addArrangedSubview(registerButton)
		stack.addArrangedSubview(gidSI)
		view.addSubview(stack)
		//		view.addSubview(gidSI)
		constraintKeyboardHeight = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
		constraintKeyboardHeight.isActive = true
		view.addConstraint(constraintKeyboardHeight)
		
		GIDSignIn.sharedInstance().uiDelegate = self
		if GIDSignIn.sharedInstance().hasAuthInKeychain() {
			GIDSignIn.sharedInstance().signInSilently()
			print("perfunctory placeholder")
		} else {
			print("no auth")
			//			GIDSignIn.sharedInstance().signIn()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//				uetf.becomeFirstResponder()
	}
	
	func playDidEnd(notif:Notification) {
//		plyr.seek(to: kCMTimeZero)
		//to reset and replay video
//		plyr.play()
	}
	
	
	override func updateViewConstraints() {
		tfConstraints()
		
		//add all above
		super.updateViewConstraints()
	}
	
	func tfConstraints() {
		NSLayoutConstraint(item: uetf, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: uptf, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: uetf, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		NSLayoutConstraint(item: uptf, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		NSLayoutConstraint(item: uetf, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 0).isActive = true
		NSLayoutConstraint(item: uptf, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.56, constant: 0).isActive = true
		//		NSLayoutConstraint(item: gidSI, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
		//		NSLayoutConstraint(item: gidSI, attribute: .top, relatedBy: .equal, toItem: stack, attribute: .bottom, multiplier: 1.0, constant: -10).isActive = true
		stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stack.topAnchor.constraint(equalTo: uptf.bottomAnchor).isActive = true
		//		gidSI.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		//		gidSI.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8).isActive = true
		
		//		NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0, constant: 0).isActive = true
	}
	

	
	
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case uetf:
			uetf.clearsOnBeginEditing = true
		case uptf:
			uptf.clearsOnBeginEditing = true
		default:
			print("perfunctory placeholder")
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		switch textField {
		case uetf:
			uptf.becomeFirstResponder()
		case uptf:
			uptf.resignFirstResponder()
			skipTapped()
		default:
			print("perfunctory placeholder")
			break
		}
		uetf.resignFirstResponder()
		
		return false
	}
	
	func loginTapped(){
		plyr?.replaceCurrentItem(with: nil)
		if let uptf = uptf.text {
			
			if uptf.characters.count > 0  {
				
			} else {
				Utility.displayAlertWithHandler("Provide Valid Password", message: "Please provide a valid email password", from: self, cusHandler: nil)
			}
			
			if let uetf = uetf.text {
				if uetf.contains("@") && uetf.contains(".") {
					
					FIRAuth.auth()?.signIn(withEmail: uetf, password: uptf, completion: { (user, err) in
						if let err = err {
							print("err = \(err.localizedDescription)")
							Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
						}
						if let u = user{
							//push to home
							let secondVC = EventTableVC()
							self.navigationController?.pushViewController(secondVC, animated: false)
						}
						
					})
				} else {
					Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
				}
			}
		}
		
		
		
		
		//		FIRAuth.auth()?.signIn(withEmail: uetf.text, password: uptf.text) { (user, error) in
		
		
		//		UserDefaults.value(forKey: <#T##String#>)
	}
	
	func registerTapped(){
	plyr?.replaceCurrentItem(with: nil)
//		plyr = nil
		if let uptf = uptf.text {
			if uptf.characters.count > 0  {
				
				if let uetf = uetf.text {
					if uetf.contains("@") && uetf.contains(".") {
						
						FIRAuth.auth()?.createUser(withEmail: uetf, password: uptf, completion: { (user, err) in
							if let err = err {
								print("PrintErr: \(err.localizedDescription)")
								if err.localizedDescription == "The password must be 6 characters long or more." {
									Utility.displayAlertWithHandler("Provide Valid Password", message: "Password should be at least 6 characters", from: self, cusHandler: nil)
								}
								else if err.localizedDescription  == "The email address is already in use by another account." {
									FIRAuth.auth()?.signIn(withEmail: uetf, password: uptf, completion: { (user, err) in
										if let err = err {
											print("err = \(err.localizedDescription)")
											Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
										}
										if let u = user{
											//push to home
											let secondVC = EventTableVC()
											self.navigationController?.pushViewController(secondVC, animated: false)
										}
										
									})
								}
								Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
							}
							if let u = user {
								let secondVC = EventTableVC()
								self.navigationController?.pushViewController(secondVC, animated: false)
								
							}
						})
					} else {
						Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
					}
				} else {
					Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
				}
			} else {
				Utility.displayAlertWithHandler("Provide Valid Password", message: "Please provide a valid email password", from: self, cusHandler: nil)
			}
		}
		
	}
	
	func skipTapped(){
	plyr?.replaceCurrentItem(with: nil)
		FIRAuth.auth()?.signInAnonymously(completion: { (user, err) in
			if let er = err {
				print("Print er signInAnonymously: \(er.localizedDescription)")
			}
			if let u = user {
				if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "maintabvc") {
					self.navigationController?.pushViewController(secondVC, animated: true)	
				}
				
				
			}
		})
		
		//		self.present(vc, animated: true) {
		//			self.dismiss(animated: false, completion: {
		//cleanup view
		//			})
		//		}
	}
	
	func screenTapped(){
		self.view.endEditing(true)
		uptf.resignFirstResponder()
		uetf.resignFirstResponder()
	}
	
	func keyboardWillShow(_ sender: Notification) {
		if let f = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
			let newF = self.view.convert(f, from: (UIApplication.shared.delegate?.window)!)
			constraintKeyboardHeight.constant = newF.origin.y - self.view.frame.height
		}
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func keyboardWillHide(_ sender: Notification) {
		constraintKeyboardHeight.constant = 0
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	
	
	func setUpPlayer(){
		//		plyr = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!))
		let plyrLayer = AVPlayerLayer(player: plyr)
		let screenSize:CGRect = UIScreen.main.bounds
		plyrLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height/2)
//		plyrLayer.frame = self.view.bounds
		plyrLayer.videoGravity = "AVLayerVideoGravityResizeAspectFit"
		view.layer.insertSublayer(plyrLayer, at: 0)
	}
	
	
	lazy var uetf:UITextField! = {
		let v = UITextField()
		v.translatesAutoresizingMaskIntoConstraints = false
		v.borderStyle = .roundedRect
		v.textColor = UIColor.darkGray
		v.layer.cornerRadius = 5
		v.layer.borderWidth = 3
		v.layer.borderColor = UIColor.white.cgColor
		v.textAlignment = .center
		v.attributedPlaceholder = NSAttributedString(string: "email-address", attributes: [NSForegroundColorAttributeName: UIColor.black])
		v.layer.opacity = 0.25
		return v
	}()
	
	lazy var uptf:UITextField! = {
		let v = UITextField()
		v.isEnabled = true
		v.isSecureTextEntry = true
		v.translatesAutoresizingMaskIntoConstraints = false
		v.borderStyle = .roundedRect
		v.textColor = UIColor.darkGray
		v.layer.cornerRadius = 5
		v.layer.borderWidth = 3
		v.layer.borderColor = UIColor.white.cgColor
		v.textAlignment = .center
		v.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.black])
		v.layer.opacity = 0.25
		return v
	}()
	
	lazy var loginButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(loginTapped), for:UIControlEvents.touchDown)
		b.layer.opacity = 0.25
		b.setTitle("Login", for: .normal)
		return b
	}()
	
	lazy var registerButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(registerTapped), for:UIControlEvents.touchDown)
		b.layer.opacity = 0.25
		b.setTitle("Register", for: .normal)
		return b
	}()
	
	lazy var skipButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(skipTapped), for:UIControlEvents.touchDown)
		b.layer.opacity = 0.25
		b.setTitle("Skip", for: .normal)
		b.setTitle("Skipping", for: UIControlState.selected)
		return b
	}()
	
	lazy var stack:UIStackView! = {
		let s = UIStackView()
		s.translatesAutoresizingMaskIntoConstraints = false
		s.alignment = UIStackViewAlignment.center
		s.distribution = UIStackViewDistribution.fillEqually
		s.axis = UILayoutConstraintAxis.horizontal
		//		s.alignment =
		return s
	}()
	
	lazy var gidSI:GIDSignInButton! = {
		let s = GIDSignInButton()
		s.colorScheme = GIDSignInButtonColorScheme.dark
		s.style = GIDSignInButtonStyle.iconOnly
		s.addTarget(self, action: #selector(signInWithGoogle), for: .touchDown)
		//		s.style = GIDSignInButtonStyle.standard
		return s
	}()
	func signInWithGoogle(){
		GIDSignIn.sharedInstance().signIn()
	}
	
	
}
