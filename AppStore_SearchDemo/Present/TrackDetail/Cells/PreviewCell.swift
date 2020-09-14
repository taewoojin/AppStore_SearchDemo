//
//  PreviewCell.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/12.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

class PreviewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var currentIndex: CGFloat = 0
    
    let lineSpacing: CGFloat = 20
    
    let cellRatio: CGFloat = 0.85
    
    var isOneStepPaging = false
    
    var track: Track? {
        didSet {
            guard let track = self.track else { return }
            self.screenshotUrls = track.screenshotUrls
        }
    }
    
    var screenshotUrls = [String]()
    
    var presentViewModel: PresentViewModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionViewHeight.constant = frame.width * cellRatio * 7 / 4
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: "ScreenshotCell")
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        initCell()
    }
    
    private func initCell() {
        let cellWidth = floor(frame.width * cellRatio)
        let cellHeight = cellWidth * 7 / 4
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
}


extension PreviewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as! ScreenshotCell
        cell.imageUrl = screenshotUrls[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let screenshotView = ScreenshotViewController(imageUrls: track?.screenshotUrls ?? [])
        
        let navigationController = UINavigationController(rootViewController: screenshotView)
        navigationController.modalPresentationStyle = .fullScreen
        presentViewModel?.action.presentViewController.accept(navigationController)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
    
}

extension PreviewCell : UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        
        print("index: \(index)")
        print("roundedIndex: \(roundedIndex)")
        print("layout.itemSize: \(layout.itemSize)")
        print("scrollView.contentOffset: \(scrollView.contentOffset.x)")
        print("targetContentOffset.pointee.x: \(targetContentOffset.pointee.x)")
        
        // 마지막 item일 경우에는 이 부분을 지나가야 함.
        if screenshotUrls.count != Int(roundedIndex) + 1 {
            
            // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
            // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
            // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
            if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                roundedIndex = floor(index)
            } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
                roundedIndex = ceil(index)
            } else {
                roundedIndex = round(index)
            }
        }
        
        if isOneStepPaging {
            if currentIndex > roundedIndex {
                currentIndex -= 1
                roundedIndex = currentIndex
            } else if currentIndex < roundedIndex {
                currentIndex += 1
                roundedIndex = currentIndex
            }
        }
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left - 20, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
