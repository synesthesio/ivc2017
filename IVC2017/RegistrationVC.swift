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
class RegistrationVC: UIViewController,UITextFieldDelegate, UIGestureRecognizerDelegate, GIDSignInUIDelegate  {
	
	var plyr:AVPlayer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		plyr = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!))
		self.navigationController?.navigationBar.isHidden = true
		uetf.delegate = self
		uptf.delegate = self

		setUpPlayer()
		
		let veV = UIVisualEffectView(frame: view.bounds)
		veV.translatesAutoresizingMaskIntoConstraints = false
		veV.effect = UIBlurEffect(style: .light)
		
		plyr?.play()
		plyr?.isMuted = true
		NotificationCenter.default.addObserver(self, selector: #selector(playDidEnd(notif:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: plyr?.currentItem)
		view.setNeedsUpdateConstraints()
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		view.backgroundColor = Utility.purpleClr
		view.addSubview(uetf)
		view.addSubview(uptf)
		stack.addArrangedSubview(loginButton)
		stack.addArrangedSubview(skipButton)
		stack.addArrangedSubview(registerButton)
		stack1.addArrangedSubview(stack)
		stack1.addArrangedSubview(gidSI)
		view.addSubview(stack1)
		
		
		GIDSignIn.sharedInstance().uiDelegate = self
		if GIDSignIn.sharedInstance().hasAuthInKeychain() {
		
			let ac = UIAlertController(title: "Gmail Sign In?", message: "Sign in with Gmail?", preferredStyle: .actionSheet)
			let y = UIAlertAction(title: "Yes", style: .default, handler: { (yes) in
				GIDSignIn.sharedInstance().signInSilently()
				self.transitionToMain()
			})
			let n = UIAlertAction(title: "No", style: .default, handler: nil)
			ac.addAction(y)
			ac.addAction(n)
			self.present(ac, animated: false, completion: nil)
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
		plyr?.seek(to: kCMTimeZero)
		//to reset and replay video
		plyr?.play()
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
		stack1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stack1.topAnchor.constraint(equalTo: uptf.bottomAnchor).isActive = true
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
							self.transitionToMain()
						}
						
					})
				} else {
					Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
				}
			}
		}
		
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
											self.transitionToMain()
										}
										
									})
								}
								Utility.displayAlertWithHandler("Provide Valid Email", message: "Please provide a valid email ", from: self, cusHandler: nil)
							}
							if let u = user {
								self.transitionToMain()
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
				self.transitionToMain()
			}
		})
	}
	
	func screenTapped(){
		self.view.endEditing(true)
		uptf.resignFirstResponder()
		uetf.resignFirstResponder()
	}
	
	func keyboardWillShow(_ sender: Notification) {
		
		if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	func keyboardWillHide(_ sender: Notification) {
		if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}
	
	func setUpPlayer(){
				plyr = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!))
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
		v.textColor = UIColor.white
		v.layer.cornerRadius = 5
		v.layer.borderWidth = 0.5
		v.layer.borderColor = Utility.yellowClr.cgColor
		v.backgroundColor = Utility.redClr
		v.textAlignment = .center
		v.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Helvetica Neue", size:20)])
//		v.layer.opacity = 0.25
		return v
	}()
	
	lazy var uptf:UITextField! = {
		let v = UITextField()
		v.isEnabled = true
		v.isSecureTextEntry = true
		v.translatesAutoresizingMaskIntoConstraints = false
		v.borderStyle = .roundedRect
		v.textColor = UIColor.white
		v.layer.cornerRadius = 5
		v.layer.borderWidth = 0.5
		v.layer.borderColor = Utility.yellowClr.cgColor
		v.backgroundColor = Utility.redClr
		v.textAlignment = .center
		v.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Helvetica Neue", size:20)])
//		v.layer.opacity = 0.25
		return v
	}()
	
	lazy var loginButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.layer.borderColor = Utility.yellowClr.cgColor
		b.backgroundColor = Utility.redClr
		b.layer.cornerRadius = 15.0
		b.layer.borderWidth = 0.5
		b.addTarget(self, action: #selector(loginTapped), for:UIControlEvents.touchDown)
//		b.layer.opacity = 0.75
		b.setTitleColor(UIColor.white, for: .normal)
		b.setTitle("Login", for: .normal)
		return b
	}()
	
	lazy var registerButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.layer.borderColor = Utility.yellowClr.cgColor
		b.backgroundColor = Utility.redClr
		b.layer.cornerRadius = 15.0
		
		b.layer.borderWidth = 0.5
		b.addTarget(self, action: #selector(registerTapped), for:UIControlEvents.touchDown)
//		b.layer.opacity = 0.75
		let style = NSMutableParagraphStyle()
		style.alignment = .center
		let str = NSAttributedString(string: " Register ", attributes: [NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:UIColor.white])
		b.setAttributedTitle(str, for: .normal)
//		b.setTitleColor(Utility.yellowClr, for: .normal)
//		b.setTitle("Register  ", for: .normal)
		return b
	}()
	
	lazy var skipButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.layer.borderColor = Utility.yellowClr.cgColor
		b.backgroundColor = Utility.redClr
		b.layer.cornerRadius = 15.0
		b.layer.borderWidth = 0.5
		b.addTarget(self, action: #selector(skipTapped), for:UIControlEvents.touchDown)
		b.setTitle("Skip", for: .normal)
		b.setTitleColor(UIColor.white, for: .normal)
//		b.tintColor = Utility.yellowClr
//		b.layer.opacity = 0.75
		b.setTitle("Skipping", for: UIControlState.selected)
		return b
	}()
	
	lazy var stack:UIStackView! = {
		let s = UIStackView()
		s.translatesAutoresizingMaskIntoConstraints = false
		s.alignment = UIStackViewAlignment.center
		s.distribution = UIStackViewDistribution.fillEqually
		s.axis = UILayoutConstraintAxis.horizontal
		s.layer.borderWidth = 0.5
		s.layer.borderColor = Utility.yellowClr.cgColor
		s.spacing = 3
		//		s.alignment =
		return s
	}()
	
	lazy var gidSI:GIDSignInButton! = {
		let s = GIDSignInButton()
		s.colorScheme = GIDSignInButtonColorScheme.dark
		s.style = GIDSignInButtonStyle.standard
//		s.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
		s.addTarget(self, action: #selector(signInWithGoogle), for: .touchDown)
		//		s.style = GIDSignInButtonStyle.standard
		return s
	}()
	
	lazy var stack1:UIStackView! = {
		let s = UIStackView()
		s.translatesAutoresizingMaskIntoConstraints = false
		s.alignment = UIStackViewAlignment.center
		s.distribution = UIStackViewDistribution.fillEqually
		s.axis = UILayoutConstraintAxis.vertical
		return s
	}()
	func signInWithGoogle(){
		GIDSignIn.sharedInstance().signIn()
	}
	func transitionToMain(){
		if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "maintabvc") {
			self.navigationController?.pushViewController(secondVC, animated: true)
		}
	}
}
