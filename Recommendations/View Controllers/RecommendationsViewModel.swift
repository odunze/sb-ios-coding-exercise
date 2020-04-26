//
//  RecommendationsViewModel.swift
//  Recommendations
//
//  Created by Lotanna Igwe-Odunze on 4/25/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import UIKit

class RecommendationsViewModel {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    var showTopTen: Bool = true

    lazy var recommendations: [Recommendation] = []
    lazy var skipped: [String] = []
    lazy var owned: [String] = []
    lazy var topTen: [Recommendation] = []
    
    var titles: Titles? {
        
        didSet {
            if let titles = titles {
                
                recommendations = titles.titles
                skipped = titles.skipped
                owned = titles.titlesOwned
                                
                let ratedReleases = recommendations.filter {
                    
                    guard let rating = $0.rating else { return false }
                    
                    return ($0.rating == rating) && ($0.isReleased == true)
                }
                                    
                topTen = buildTopTenList(ratedTitles: ratedReleases)
            }
        }
    }
    
    
    func shouldShowTopTen() -> Bool {
        return showTopTen
    }
    
    func getRecommendation(at index: Int) -> Recommendation {
        if shouldShowTopTen() {
            let recommendation = topTen[index]
            return recommendation
        } else {
            let recommendation = recommendations[index]
            return recommendation
        }
    }
    
    func getImage(for recommendation: Recommendation) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: recommendation.imageURL as NSString) {
            return cachedImage
            
        } else {
            return loadImage(for: recommendation)
        }
       }
    
    private func loadImage(for recommendation: Recommendation) -> UIImage? {
        
        guard let url = URL(string: recommendation.imageURL),
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) else {
                return nil
        }
        
        let imageKey = recommendation.imageURL as NSString
        imageCache.setObject(image, forKey: imageKey)
        
        return image
    }
    
    private func buildTopTenList(ratedTitles: [Recommendation]) -> [Recommendation] {
        
        var list: [Recommendation] = []
        
        var sortedList = ratedTitles.sorted(by: { !($0.rating!.isLess(than: $1.rating!)) } )
        sortedList.removeAll( where: { (skipped.contains($0.title)) || (owned.contains($0.title)) } )
        
        for index in 0 ..< 10 {
            list.append(sortedList[index])
        }
        
        return list
    }
}
