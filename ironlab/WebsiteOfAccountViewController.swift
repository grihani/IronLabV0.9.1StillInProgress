//
//  WebsiteOfAccountViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 05/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class WebsiteOfAccountViewController: UIViewController {

    @IBOutlet weak var websiteOfAccountWebView: UIWebView! {
        didSet {
            websiteOfAccountWebView.delegate = self
        }
    }
    var url: NSURL! {
        didSet {
            let requestObj = NSURLRequest(URL: url)
            self.websiteOfAccountWebView?.loadRequest(requestObj)
            loadingIndicator.hidden = true
            self.websiteOfAccountWebView?.addSubview(loadingIndicator)
            self.websiteOfAccountWebView?.reload()
        }
    }
    var loadingIndicator = LoadingIndicator(frame: CGRectMake(25, 130, 270, 100))
    var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let requestObj = NSURLRequest(URL: url)
            self.websiteOfAccountWebView.loadRequest(requestObj)
            loadingIndicator.hidden = true
            self.websiteOfAccountWebView.addSubview(loadingIndicator)
            self.websiteOfAccountWebView.reload()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func closePopover(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension WebsiteOfAccountViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.loadingIndicator.show("Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingIndicator.hide()
    }
}
