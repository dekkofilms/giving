//
//  AddBankVC.swift
//  giving
//
//  Created by Taylor King on 1/5/17.
//  Copyright © 2017 Taylor King. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftKeychainWrapper

class AddBankVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var containerView: UIView? = nil
    
    var webView: WKWebView!
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // load the link url
        let linkUrl = generateLinkInitializationURL()
        let url = NSURL(string: linkUrl)
        let request = NSURLRequest(url:url! as URL)
        self.webView.load(request as URLRequest)
        self.webView.allowsBackForwardNavigationGestures = false
    }
    
    // getUrlParams :: parse query parameters into a Dictionary
    func getUrlParams(url: URL) -> Dictionary<String, String> {
        var paramsDictionary = [String: String]()
        let queryItems = NSURLComponents(string: (url.absoluteString))?.queryItems
        queryItems?.forEach { paramsDictionary[$0.name] = $0.value }
        return paramsDictionary
    }
    
    // generateLinkInitializationURL :: create the link.html url with query parameters
    func generateLinkInitializationURL() -> String {
        let config = [
            "key": "a9c79284129436ffeecf91b23101f7",
            "product": "auth",
            "longtail": "true",
            "selectAccount": "true",
            "env": "tartan",
            "clientName": "Giving",
//            "webhook": "https://requestb.in",
            "isMobile": "true",
            "isWebview": "true"
        ]
        
        // Build a dictionary with the Link configuration options
        // See the Link docs (https://plaid.com/docs/link) for full documentation.
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "cdn.plaid.com"
        components.path = "/link/v2/stable/link.html"
        components.queryItems = config.map { (NSURLQueryItem(name: $0, value: $1) as URLQueryItem) }
        return components.string!
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        
        let linkScheme = "plaidlink";
        let actionScheme = navigationAction.request.url?.scheme;
        let actionType = navigationAction.request.url?.host;
        let queryParams = getUrlParams(url: navigationAction.request.url!)
        
        if (actionScheme == linkScheme) {
            switch actionType {
                
            case "connected"?:
                // Close the webview
                //self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes the public_token as well as account and institution metadata
                print("Public Token: \(queryParams["public_token"])");
                print("Account ID: \(queryParams["account_id"])");
                print("Institution type: \(queryParams["institution_type"])");
                print("Institution name: \(queryParams["institution_name"])");
                print("TAYLOR - OnExit Return: \(queryParams)")
                
                //Sending this to the server
                if let token = queryParams["public_token"], let account_id = queryParams["account_id"], let institution_type = queryParams["institution_type"] {
                    let parameters = ["public_token" : token, "account_id" : account_id, "institution_type" : institution_type]
                    
                    Alamofire.request("https://shielded-taiga-67588.herokuapp.com/plaid/authenticate", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                        
                        if response.result.isFailure == true {
                            print("TAYLOR: FAILURE = \(response.result.isFailure)")
                            return
                        }
                        
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            
                            if let token = JSON["access_token"], let bank_account_token = JSON["bank_account_token"] {
                                print("TAYLOR___SETTING KEYCHAIN: \(token) & \(bank_account_token)")
                                KeychainWrapper.standard.set(token as! String, forKey: "access_token")
                                KeychainWrapper.standard.set(bank_account_token as! String, forKey: "bank_account_token")
                                
                                //dismiss or present next view ... this resulted in not being dismissed at all, and being on blank screen
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        
                    })
                    
                }
                
                
                break
                
            case "exit"?:
                // Close the webview
                self.dismiss(animated: true, completion: nil)
                
                // Parse data passed from Link into a dictionary
                // This includes information about where the user was in the Link flow
                // any errors that occurred, and request IDs
                print("TAYLOR-URL: \(navigationAction.request.url?.absoluteString)")
                // Output data from Link
                print("User status in flow: \(queryParams["status"])");
                // The requet ID keys may or may not exist depending on when the user exited
                // the Link flow.
                print("Link request ID: \(queryParams["link_request_id"])");
                print("Plaid API request ID: \(queryParams["link_request_id"])");
                break
                
            default:
                print("Link action detected: \(actionType)")
                break
            }
            
            decisionHandler(.cancel)
        } else if (navigationAction.navigationType == WKNavigationType.linkActivated &&
            (actionScheme == "http" || actionScheme == "https")) {
            // Handle http:// and https:// links inside of Plaid Link,
            // and open them in a new Safari page. This is necessary for links
            // such as "forgot-password" and "locked-account"
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            print("Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: \(navigationAction.request.url!.absoluteString)");
            decisionHandler(.allow)
        }
    }

}
