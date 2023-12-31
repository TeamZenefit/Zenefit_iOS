//
//  SkeletonTableViewDataSource.swift
//  ZeneFit
//
//  Created by iOS신상우 on 12/31/23.
//

import SkeletonView
import UIKit

extension SkeletonTableViewDataSource {
    // TODO: 필요시 재확장
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
}
