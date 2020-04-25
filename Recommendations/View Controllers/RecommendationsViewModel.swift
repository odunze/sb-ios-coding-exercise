//
//  RecommendationsViewModel.swift
//  Recommendations
//
//  Created by Lotanna Igwe-Odunze on 4/24/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import Foundation

class RecommendationsViewModel {
    
    var showTopTen: Bool = false

    var recommendations: [Recommendation] = []
    var topTen: [Recommendation] = []
    
    var titles: Titles? {
        
        didSet {
            if let titles = titles {
                
                recommendations = titles.titles
                
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
    
    func displayRecommendation(at: Int) -> Recommendation {
        if shouldShowTopTen() {
            let recommendation = topTen[at]
            return recommendation
        } else {
            let recommendation = recommendations[at]
            return recommendation
        }
    }
    
    private func buildTopTenList(ratedTitles: [Recommendation]) -> [Recommendation] {
        var list: [Recommendation] = []
        
        let sortedList = ratedTitles.sorted(by: { !($0.rating!.isLess(than: $1.rating!)) } )
        
        for index in 0 ..< 10 {
            list.append(sortedList[index])
        }
        
        return list
    }
}
