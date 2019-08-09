//
//  YoutubeVideoPlayerController.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/06/22.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit
import WebKit

class YoutubeVideoPlayerController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private lazy var activitiyIndicatorView = UIActivityIndicatorView()
    
    private lazy var webView: WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        let source = """
        var videos = document.getElementsByTagName('video');
        for (var i = 0 ; i < videos.length; i++) {
        var video = videos[i];
        video.onplay = function(){ window.webkit.messageHandlers.videoListener.postMessage('play'); };
        video.onpause = function(){ window.webkit.messageHandlers.videoListener.postMessage('pause'); };
        video.onended = function(){ window.webkit.messageHandlers.videoListener.postMessage('ended'); };
        video.setAttribute("title", "\(UIApplication.shared.applicationName ?? "")");
        }
        """
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController.addUserScript(script)
        configuration.userContentController.add(self, name: "videoListener")
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    private let videoId: String
    
    // MARK: - Initialization
    init(videoId: String) {
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.videoId = ""
        super.init(coder: aDecoder)
        assertionFailure("Must initialize with a Youtube video ID.")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.videoId = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        assertionFailure("Must initialize with a Youtube video ID.")
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadVideo()
    }
    
    // MARK: - Action
    private func loadVideo() {
        let html = """
        <!doctype html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width">
        <style>
        html, body { margin: 0%; padding; 0% }
        iframe { display: block; width: 0%; height: 0% }
        </style>
        </head>
        <body>
        <div id="player"></div>
        <script>
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
        var player;
        function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
        height: '\(0)',
        width: '\(0)',
        videoId: '\(videoId)',
        events: {
        'onReady': onPlayerReady,
        'onStateChange': onStateChange,
        'onError': onError
        }
        });
        }
        
        function onPlayerReady(event) {
        event.target.playVideo();
        window.webkit.messageHandlers.videoListener.postMessage('ready');
        }
        
        function onStateChange(event) {
        switch (event.data) {
        case 0: window.webkit.messageHandlers.videoListener.postMessage('stopped');
        // case 1: window.webkit.messageHandlers.videoListener.postMessage('playing');
        case 2: window.webkit.messageHandlers.videoListener.postMessage('paused');
        }
        }
        
        function onError(event) {
        window.webkit.messageHandlers.videoListener.postMessage('error');
        }
        </script>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: - Setup
    private func setup() {
        view.backgroundColor = .black
        view.accessibilityIgnoresInvertColors = true
        
        activitiyIndicatorView.startAnimating()
        activitiyIndicatorView.style = .whiteLarge
        view.addSubview(activitiyIndicatorView)
        activitiyIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = NSLayoutConstraint(item: activitiyIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: activitiyIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraints([centerXConstraint, centerYConstraint])

        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    
    }
}

// MARK: - Webview
extension YoutubeVideoPlayerController: WKNavigationDelegate, WKScriptMessageHandler {
    // Message
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? String else { return }
        switch body {
        case "ready": break
        case "playing": break
        case "paused", "stopped", "error":
            dismiss(animated: true, completion: nil)
        default: break
        }
    }
}
