//
//  ViewController.swift
//  CreateBackgoundIphone
//
//  Created by Nguyễn Trung on 4/20/21.
//  Copyright © 2021 Nguyễn Trung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerView.clipsToBounds = true
        
    }
    
    @IBAction func didTapAddImg(_ sender: Any) {
        
        let newView: BaseUIView = BaseUIView.fromNib()
        newView.frame = CGRect(x: containerView.bounds.midX - 50, y: containerView.bounds.midY - 70, width: 150, height: 200)
        //        newView.delegate = self
        newView.containerView = self.containerView
        self.containerView.addSubview(newView)
        
        let image = UIImage.init(named: "ic_x")
        let imageView = UIImageView.init(image: image)
        
        imageView.layer.zPosition = -1
        
        newView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: newView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: newView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: newView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: newView.rightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        //        imageView.contentMode = .center
        
    }
    
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
