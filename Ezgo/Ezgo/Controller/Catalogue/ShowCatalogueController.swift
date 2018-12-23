//
//  ShowCatalogueController.swift
//  Ezgo
//
//  Created by Puagnol John on 13/11/2018.
//  Copyright © 2018 Puagnol John. All rights reserved.
//

import UIKit

class ShowCatalogueController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var zoneCatalogue: UIView!
    
    var mesPages : [String] = []
    var monCatalogue = ""
    var position = 0
    
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = mesPages.count
        
        var i = 0
        for myCata in mesPages {
            
            let urlIB = URL(string: myCata)
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            
            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height - 180)
            imageView.load(url: urlIB!)
            
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            
            i += 1
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let vc = segue.destination as! CategorieController
//        vc.monCatalogue = self.monCatalogue
//        vc.position = self.position
//    }
    
    // Scrollview Method
    // ============================
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
