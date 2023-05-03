//
//  HomeViewController.swift
//  Pixels News
//
//  Created by Alief Azies on 15/10/21.
//

import UIKit
import Kingfisher

enum HomeItemGroup {
    case covid
    case topNews
    case news
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var pageControl: UIPageControl?
    weak var topNewsCollectionView: UICollectionView?
    
    var itemGroups: [HomeItemGroup] = [.covid, .topNews, .news]
    var covidNews: String = "See the latest coverage about Covid-19"
    var topNews: [News] = []
    var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.addTarget(self, action: #selector(self.profileButtonTapped(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barItem
        loadTopNews()
        loadNews()
    }
    
    //    MARK: - Helper
    func loadTopNews(){
        NewsProvider.shared.loadTopNews { response in
            switch response{
            case .success(let news):
                self.topNews = news
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Error load top news: \(error.localizedDescription)")
            }
        }
        
    }
    
    func loadNews(){
        NewsProvider.shared.loadNews { response in
            switch response{
            case .success(let news):
                self.news = news
                self.tableView.reloadData()
            case.failure(let error):
                print("Error load news: \(error.localizedDescription)")
            }
        }
        
    }
    
    func addToReadingList(_ news: News){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.viewContext
        
        NewsData.insert(news: news, context: context)
        appDelegate.saveContext()
    }
    
    //    MARK: - Actions
    @IBAction func profileButtonTapped(_ sender: Any) {
        print("Profile Button Tapped")
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        switch group{
        case .covid:
            return 1
        case .topNews:
            return 1
        case .news:
            return news.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = itemGroups[indexPath.section]
        
        if group == .covid{
            let cell = tableView.dequeueReusableCell(withIdentifier: "covid_cell", for: indexPath) as! CovidTableViewCell
            let attText = NSMutableAttributedString(
                string: "Covid-19 News : ",
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold),
                    NSAttributedString.Key.foregroundColor : UIColor(hex: "0077B6")
                ])
            attText.append(NSAttributedString(
                string: covidNews,
                attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular),
                    NSAttributedString.Key.foregroundColor : UIColor(hex: "7F7F7F")
                ]))
            cell.titleLabel.attributedText = attText
            cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
            cell.bottomConstraint.constant = indexPath.row == covidNews.count - 1 ? 20 : 10
            return cell
        }else if group == .topNews{
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_news_cell", for: indexPath) as! TopNewsTableViewCell
            cell.titleLabel.text = "News for you"
            cell.subTitleLabel.text = "Top \(topNews.count) News of the day"
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            self.topNewsCollectionView = cell.collectionView
            
            cell.pageControl.currentPage = 0
            cell.pageControl.numberOfPages = topNews.count
            self.pageControl = cell.pageControl
            
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsTableViewCell
            
            let berita = news[indexPath.row]
            cell.titleLabel.text = berita.title
            cell.descLabel.text = ["\(berita.published_date.string(format: "MMM d, yyyy"))", berita.section].joined(separator: " • ")
            let urlString = berita.media.last?.mediaMetaData.last?.url ?? ""
            cell.thumbImageLabel.kf.setImage(with: URL(string: urlString))
            //            if let urlString = berita.media.last?.mediaMetaData.last?.url,
            //               let url = URL(string: urlString){
            //                DispatchQueue.global().async {
            //                    if let data = try? Data(contentsOf: url){
            //                        let image = UIImage(data: data)
            //                        DispatchQueue.main.async {
            //                            cell.thumbImageLabel?.image = image
            //                        }
            //                    }
            //                }
            //            }
            
            cell.bookmarkButton.isHidden = false
            cell.bookmarkButton.isEnabled = true
            
            cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
            cell.bottomConstraint.constant = indexPath.row == news.count - 1 ? 20 : 10
            //            cell.delegate = self
            cell.setOnBookmarkButtonTapped { cell in
                if let indexPath = self.tableView.indexPath(for: cell){
                    let news = self.news[indexPath.row]
                    self.addToReadingList(news)
                    cell.bookmarkButton.isEnabled = false
                }
            }
            
            return cell
        }
    }
}

//extension HomeViewController: NewsTableViewCellDelegate {
//    func newsTableViewCellBookmarkButtonTapped(_ cell: NewsTableViewCell) {
//        if let indexPath = tableView.indexPath(for: cell){
//            let news = self.news[indexPath.row]
//            addToReadingList(news)
//            cell.bookmarkButton.isEnabled = false
//        }
//    }
//}

extension HomeViewController: UITableViewDelegate{
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return itemGroups[indexPath.section] == .news
    //    }
    //    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    //        return "Add to reading List"
    //    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        let news = self.news[indexPath.row]
    //        addToReadingList(news)
    //    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_collection_cell", for: indexPath) as! TopNewsCollectionViewCell
        
        let news = topNews[indexPath.item]
        let stringUrl = news.media.last?.mediaMetaData.last?.url ?? ""
        cell.loadingView.startAnimating()
        cell.imageView.kf.setImage(with: URL(string: stringUrl)) { _ in
            cell.loadingView.stopAnimating()
        }
        //        if let imageUrl = news.media.last?.mediaMetaData.last?.url,
        //           let url = URL(string: imageUrl){
        //            cell.loadingView.startAnimating()
        //            DispatchQueue.global().async {
        //                if let data = try? Data(contentsOf: url) {
        //                    let image = UIImage(data: data)
        //                    DispatchQueue.main.async {
        //                        cell.imageView.image = image
        //                        cell.loadingView.stopAnimating()
        //                    }
        //                }
        //            }
        //        }
        cell.titleLabel.text = news.title
        cell.textLabel.text = ["\(news.published_date.string(format: "MMM d, yyyy"))", news.section].joined(separator: " • ")
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 265)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.topNewsCollectionView{
            let page = scrollView.contentOffset.x / scrollView.frame.width
            pageControl?.currentPage = Int(page)
        }
    }
}


