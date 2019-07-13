//
//  ViewController.swift
//  SVLatexView
//
//  Created by Mazorati on 07/11/2019.
//  Copyright (c) 2019 Mazorati. All rights reserved.
//

import UIKit
import SVLatexView
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @objc lazy var latexView: SVLatexView = {
        let v = SVLatexView(frame: CGRect.zero)
        //v.backgroundColor = .
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.isHidden = true
        return v
    }()
    
//    lazy var latexViewHeight: NSLayoutConstraint = {
//        return latexView.heightAnchor.constraint(equalToConstant: 70)
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(latexView)
        
        NSLayoutConstraint.activate([
            latexView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            latexView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            latexView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            //latexViewHeight
            ])
        
        let path = Bundle.main.path(forResource: "formula", ofType: "txt")!
        let f = try! String(contentsOfFile: path)
        
        latexView.loadLatexString(latexString: f)
        
//        latexView.scrollView.rx
//            .observe(CGSize.self, "contentSize")
//            .map {
//                $0?.height
//            }
//            .subscribe { [weak self] e in
//                if let eh = e.element, let h = eh {
//                    if h > 10.0 {
//                        self?.latexViewHeight.constant = h
//                    }
//                }
//
//            }
//            .disposed(by: disposeBag)
    }

}

