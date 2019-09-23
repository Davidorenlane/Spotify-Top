import UIKit


//greenColor global
let greenColor = UIColor(displayP3Red: 30.0/255.0, green: 215.0/255.0, blue: 96.0/255.0, alpha: 1)


class ViewController: UIViewController {  
    
    // MARK: - Local variables
    
    static var authenticatedUser = "authenticatedUser"
    static var authenticationFailed = "authenticationFailed"

    // MARK: - Subviews
    
    @IBOutlet weak var connectButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction @objc func didTapConnect(_ sender: Any) {
        let session = SessionOpener()
        session.startSession()
        connectButton.isEnabled = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "authenticatedUser"), object: nil, queue: nil, using: segueToTop50)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentFailureNotice(_:)), name: NSNotification.Name(ViewController.authenticationFailed), object: nil)
    }
    
    //Upon successful Authentication
    @objc func segueToTop50(notification: Notification){
        guard let token = notification.userInfo!["token"] else { return }
        DispatchQueue.main.async {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "Top50ViewController") as? Top50ViewController else {
                print("Couldn't find the view controller")
                return
            }
            let getter = DataGetter(token: token as! String)
            
            destinationViewController.accessToken = token as! String
            destinationViewController.userID = getter.grabUserID()
            let tuple = getter.grabTop50s()
            destinationViewController.tracksAndArtists = tuple.0
            destinationViewController.trackURIs = tuple.1

            self.present(destinationViewController, animated: true, completion: nil)
        }
    }
    
    //Upon authorization error
    @objc func presentFailureNotice(_: Notification) {
        DispatchQueue.main.async {
            self.presentAlertController(title: "Sign-in Error", message: "David's server is probably down. Try rebooting the app, and if that doesn't work, please text David", buttonTitle: "OK")
            self.connectButton.setTitle("Please reboot.", for: .disabled)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConnectButton(button: connectButton)
    }
    
    
    
}


extension ViewController {
    
    // Configure Button
    
    internal func configureConnectButton(button: UIButton){
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = greenColor //UIColor.green
        button.layer.cornerRadius = 22.5
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Loading...", for: .disabled)
    }
}

extension ViewController {
    
    //Alert controller to display when user enounters an error
    
    func presentAlertController(title: String, message: String, buttonTitle: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true)
    }
}








