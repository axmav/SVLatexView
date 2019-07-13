//
//  SVLatexView.swift
//  maxima
//
//  Created by Alex Mavrichev on 11/07/2019.
//  Copyright © 2019 Aleksandr Mavrichev. All rights reserved.
//

import UIKit
import WebKit

public class SVLatexView: WKWebView, WKUIDelegate {
    
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
    
    let LatexViewSizeObservingContext = UnsafeMutableRawPointer(bitPattern: 1)
    
    var viewSize = CGSize.zero
    
    public override var intrinsicContentSize: CGSize {
        return viewSize
    }
    
    public init(frame: CGRect, using engine: Engine = Engine.KaTeX) {
        super.init(frame: frame, configuration: WKWebViewConfiguration())
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
        
        addObserver(self, forKeyPath: #keyPath(scrollView.contentSize), options: .new, context: LatexViewSizeObservingContext)
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let observingContext = context,
            observingContext == LatexViewSizeObservingContext else {
                super.observeValue(forKeyPath: keyPath,
                                   of: object,
                                   change: change,
                                   context: context)
                return
        }
        
        guard let change = change else {
            return
        }
        
        if let newValue = change[.newKey] as? CGSize  {
            self.viewSize = newValue
            self.invalidateIntrinsicContentSize()
        }
        
    }
    
    public func loadLatexString(latexString: String) {
        let bundle = Bundle(for: SVLatexView.self)
        let base = bundle.resourceURL?.appendingPathComponent(engine.dirName)
        
        let filePath = bundle.path(forResource:"index", ofType:"html", inDirectory: engine.dirName)!
        // load html string - baseURL needs to be set for local files to load correctly
        let html = try! String(contentsOfFile: filePath, encoding: .utf8)
        let htmlChanged = html.replacingOccurrences(of: "{*latexString*}", with: latexString)
        loadHTMLString(htmlChanged, baseURL: base)
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(scrollView.contentSize))
    }
}

