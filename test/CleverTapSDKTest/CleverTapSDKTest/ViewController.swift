import UIKit
import CoreLocation
import CleverTapSDK
import WebKit

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {
    
    @IBOutlet var testButton: UIButton!
    @IBOutlet var inboxButton: UIButton!
    var webView: WKWebView!
    var imageArray = [UIImage]()
    @IBOutlet var scrollView: UIScrollView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupImages()
       
        CleverTap.sharedInstance()?.registerExperimentsUpdatedBlock {
            print("Experiments updated.")
        }
    
//        inboxRegister()
        // addWebview()
        profilePush()
        guard let foo = CleverTap.sharedInstance()?.getStringVariable(withName: "foo", defaultValue: "defaultFooValue") else {return}
        guard let inttt = CleverTap.sharedInstance()?.getIntegerVariable(withName: "intFoo", defaultValue: 12) else {return}
        print(foo)
        print(inttt)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Handle Webview

    func addWebview() {
        /*
        let config = WKWebViewConfiguration()
        //let ctInterface: CleverTapJSInterface = CleverTapJSInterface(config: nil)
        let userContentController = WKUserContentController()
        userContentController.add(ctInterface, name: "clevertap1")
        userContentController.add(self, name: "appDefault")
        config.userContentController = userContentController
        let customFrame =  CGRect(x: 20, y: 220, width: self.view.frame.width - 40, height: 400)
        self.webView = WKWebView (frame: customFrame , configuration: config)
        self.webView.layer.cornerRadius = 3.0
        self.webView.layer.masksToBounds = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        self.webView.loadHTMLString(self.htmlStringFromFile(with: "sampleHTMLCode"), baseURL: nil)
         
 */
    }
    
    private func htmlStringFromFile(with name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "html")
        if let result = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8) {
            return result
        }
        return ""
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else { return }
        print("I'm inside the main application: %@", body)
    }
    
    // MARK: - Register Inbox
    
    func inboxRegister() {
        
        CleverTap.sharedInstance()?.registerInboxUpdatedBlock(({
            let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
            let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
            
            DispatchQueue.main.async {
                self.inboxButton.isHidden = false;
                self.inboxButton.setTitle("Show Inbox:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread", for: .normal)
            }
        }))
        
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
            let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
            let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
            self.inboxButton.isHidden = false;
            self.inboxButton.setTitle("Show Inbox:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread", for: .normal)
        }))
    }
    
    func profilePush() {
        
        // each of the below mentioned fields are optional
        // if set, these populate demographic information in the Dashboard
  
        let profile: Dictionary<String, AnyObject> = [
            "Name": "Jack Montana" as AnyObject,                 // String
            "Identity": 61026032 as AnyObject,                   // String or number
            "Email": "jack@gmail.com" as AnyObject,              // Email address of the user
            "Phone": "+14155551234" as AnyObject,                // Phone (with the country code, starting with +)
            "Gender": "M" as AnyObject,                          // Can be either M or F
            "Employed": "Y" as AnyObject,                        // Can be either Y or N
            "Education": "Graduate" as AnyObject,                // Can be either School, College or Graduate
            "Married": "Y" as AnyObject,                         // Can be either Y or N
            "DOB": "10/09" as AnyObject,                              // Date of Birth. An NSDate object
            "Age": 28 as AnyObject,                              // Not required if DOB is set
            "Tz":"Asia/Kolkata" as AnyObject,                    //an abbreviation such as "PST", a full name such as "America/Los_Angeles",
            //or a custom ID such as "GMT-8:00"
            "Photo": "www.foobar.com/image.jpeg" as AnyObject,   // URL to the Image
            
            // optional fields. controls whether the user will be sent email, push etc.
            "MSG-email": false as AnyObject,                     // Disable email notifications
            "MSG-push": true as AnyObject,                       // Enable push notifications
            "MSG-sms": false as AnyObject                      // Disable SMS notifications
        ]
        
        CleverTap.sharedInstance()?.profilePush(profile)
        
        // To set a multi-value property
        CleverTap.sharedInstance()?.profileSetMultiValues(["bag", "shoes"], forKey: "myStuff")
        
        // To add an additional value(s) to a multi-value property
        CleverTap.sharedInstance()?.profileAddMultiValue("coat", forKey: "myStuff")
        // or
        CleverTap.sharedInstance()?.profileAddMultiValues(["socks", "scarf"], forKey: "myStuff")
        
    }
    
    // MARK: - Action Button
    
    @IBAction func inboxButtonTapped(_ sender: Any) {
        let style = CleverTapInboxStyleConfig.init()
        style.title = "AppInbox"
        style.backgroundColor = UIColor.yellow
        style.messageTags = ["Promotions", "Offers"];
        
        if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
            let navigationController = UINavigationController.init(rootViewController: inboxController)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        NSLog("test button tapped")
        CleverTap.sharedInstance()?.recordScreenView("recordScreen")
        CleverTap.sharedInstance()?.recordEvent("test ios")
        CleverTap.sharedInstance()?.recordEvent("Half Interstitial")
        CleverTap.sharedInstance()?.recordEvent("Cover")
        CleverTap.sharedInstance()?.recordEvent("Interstitial")
        CleverTap.sharedInstance()?.recordEvent("Header")
        CleverTap.sharedInstance()?.recordEvent("Interstitial Video")
        CleverTap.sharedInstance()?.recordEvent("Footer")
        CleverTap.sharedInstance()?.recordEvent("Cover Image")
        CleverTap.sharedInstance()?.recordEvent("Half Interstitial")
        CleverTap.sharedInstance()?.recordEvent("Footer")
        CleverTap.sharedInstance()?.recordEvent("Header")
        CleverTap.sharedInstance()?.recordEvent("Cover Image")
        CleverTap.sharedInstance()?.recordEvent("Tablet only Header")
        CleverTap.sharedInstance()?.recordEvent("Interstitial Gif")
        CleverTap.sharedInstance()?.recordEvent("Interstitial ios")
        CleverTap.sharedInstance()?.recordEvent("Charged")
        CleverTap.sharedInstance()?.recordEvent("Interstitial video")
        CleverTap.sharedInstance()?.recordEvent("Interstitial Image")
        CleverTap.sharedInstance()?.recordEvent("Half Interstitial Image")
//        CleverTap.sharedInstance()?.onUserLogin(["foo2":"bar2", "Email":"aditiagrawal@clevertap.com", "identity":"35353533535"])
//        CleverTap.sharedInstance()?.onUserLogin(["foo2":"bar2", "Email":"agrawaladiti@clevertap.com", "identity":"111111111"], withCleverTapID: "22222222222")

    }
    
    func messageDidSelect(_ message: CleverTapInboxMessage, at index: Int32, withButtonIndex buttonIndex: Int32) {
        
    }
    
    func setupImages(){
        
        imageArray = [UIImage(named:"meal1"), UIImage(named: "meal2")] as! [UIImage]
        
        for i in 0..<imageArray.count {
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 2)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
            
        }
    }
}
