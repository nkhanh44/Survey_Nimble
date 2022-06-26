//
//  SNImageView.swift
//  Survey-Nimble
//
//  Created by Khanh Nguyen on 20/06/2022.
//

import UIKit
import UIView_Shimmer

final class SNImageView: UIImageView {
    
    private let cache = APIService.shared.cache
    private let placeholderImage = UIImage(named: "ic_placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        contentMode = .scaleAspectFit
        image = placeholderImage
    }
    
    func downLoadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            contentMode = .scaleAspectFill
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if error != nil { return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }

            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.contentMode = .scaleAspectFill
                self.image = image
            }
        }
        
        task.resume()
    }
}

// MARK: Shimmer

extension UIImageView: ShimmeringViewProtocol {}
