//
//  ScreenshotViewController.swift
//  AppStore_SearchDemo
//
//  Created by 태우 on 2020/09/13.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit

class ScreenshotViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.register(ScreenshotCell.self, forCellWithReuseIdentifier: "ScreenshotCell")
        return view
    }()
    
    var currentIndex: CGFloat = 0
    
    let lineSpacing: CGFloat = 20
    
    let cellRatio: CGFloat = 0.8
    
    var isOneStepPaging = false
    
    let imageUrls: [String]
    
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let closeButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButtonItem
        
        layout()
        initCell()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func initCell() {
        
        // width, height 설정
        let cellWidth = floor(view.frame.width * cellRatio)
        let cellHeight = floor(view.frame.height * cellRatio)
        
        // 상하, 좌우 inset value 설정
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

}


extension ScreenshotViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as! ScreenshotCell
        cell.imageUrl = imageUrls[indexPath.row]
        return cell
    }
}

extension ScreenshotViewController : UIScrollViewDelegate {
    
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
        
        // 마지막 item일 경우에는 이 부분을 통과해야 함.
        if imageUrls.count != Int(roundedIndex) + 1 {
            
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
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
