//
//  WebViewController.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    let postWebView: UIWebView = {
        let webview = UIWebView()
        var  postURL = NSURL(string: "http://apple.com")
        let urlstring = "http://apple.com"
        let request = NSURLRequest(URL: postURL!)
        webview.loadRequest(request)
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    override func viewDidLoad() {
        setUpWebView()
    }
    func setUpWebView() {
        view.addSubview(postWebView)
        postWebView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        postWebView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        postWebView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        postWebView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
    }
}
