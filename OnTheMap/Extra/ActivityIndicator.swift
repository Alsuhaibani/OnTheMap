
import UIKit
import Foundation

struct ActivityIndicator {
    
    private static var AI :UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func AiStart(view: UIView) {
        
        AI.center = view.center
        AI.hidesWhenStopped = true
        AI.style = .gray
        view.addSubview(AI)
        AI.startAnimating()
        
    }
    
    static func AiStop() {
        
        AI.stopAnimating()
        
    }
    
}

