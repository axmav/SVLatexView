//
//  SVLatexView.swift
//  maxima
//
//  Created by Alex Mavrichev on 11/07/2019.
//  Copyright © 2019 Aleksandr Mavrichev. All rights reserved.
//

import UIKit
import WebKit

public class SVLatexView: WKWebView, WKNavigationDelegate {
    
    public enum Engine {
        case MathJax
        case KaTeX
        
        var dirName: String {
            switch self {
            case .MathJax:
                return "MathJax-master"
            case .KaTeX:
                return "katex"
            }
        }
    }
    
    var engine: Engine = .KaTeX
    
    public var customCSS = ""
    
    let LatexViewSizeObservingContext = UnsafeMutableRawPointer(bitPattern: 1)
    
    var viewSize = CGSize.zero
    var preferredWidth: CGFloat?
    
    public override var intrinsicContentSize: CGSize {
        if let preferredWidth = preferredWidth {
            return CGSize(width: preferredWidth, height: viewSize.height)
        }
        
        return viewSize
    }
    
    public init(frame: CGRect, using engine: Engine = Engine.KaTeX, contentWidth: CGFloat? = nil) {
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        preferredWidth = contentWidth
        self.engine = engine
        setupView()
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        isOpaque = false
        backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        navigationDelegate = self
    }
    
    public func loadLatexString(latexString: String) {
        //load(URLRequest(url: URL(string:"about:blank")!))
        
        // Reset IntrinsicContentSize
        viewSize = CGSize(width: frame.size.width, height: 0)
        self.invalidateIntrinsicContentSize()
        
        let bundle = Bundle(for: SVLatexView.self)
        let base = bundle.resourceURL?.appendingPathComponent(engine.dirName)
        
        let filePath = bundle.path(forResource:"index", ofType:"html", inDirectory: engine.dirName)!
        // load html string - baseURL needs to be set for local files to load correctly
        let html = try! String(contentsOfFile: filePath, encoding: .utf8)
        let htmlChanged = html
            .replacingOccurrences(of: "{*customCSS*}", with: customCSS)
            .replacingOccurrences(of: "{*latexString*}", with: latexString)
        loadHTMLString(htmlChanged, baseURL: base)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavaScript("document.readyState", completionHandler: { [weak self] (complete, error) in
            if complete != nil {
                self?.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] (height, error) in
                    self?.updateViewSize(height: height as! CGFloat)
                })
            }

        })
    }
    
    private func updateViewSize(height: CGFloat) {
        viewSize = CGSize(width: frame.size.width, height: height)
        self.invalidateIntrinsicContentSize()
    }
    
    deinit {
        scrollView.delegate = nil
        navigationDelegate = nil
    }
}

extension SVLatexView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

