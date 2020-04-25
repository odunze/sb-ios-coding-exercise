//
//  RecommendationsVC+TableView.swift
//  Recommendations
//
//  Created by Lotanna Igwe-Odunze on 4/24/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import UIKit

extension RecommendationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.shouldShowTopTen() {
                return vm.topTen.count
            } else {
                return vm.recommendations.count
            }
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecommendationTableViewCell
        
        let recommendation = vm.displayRecommendation(at: indexPath.row)
        
        cell.titleLabel.text = recommendation.title
        cell.taglineLabel.text = recommendation.tagline
        cell.ratingLabel.text = "Rating: \(recommendation.rating)"
        
        if let url = URL(string: recommendation.imageURL) {
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                cell.recommendationImageView?.image = image
            }
        }
        
        return cell
    }
}
