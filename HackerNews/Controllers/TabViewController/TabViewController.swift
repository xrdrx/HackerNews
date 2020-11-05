//
//  TabViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController {

    private var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad() 

        self.dataSource = self

        createAndConfigureTabBar()
        
        createAndConfigureVCForTabs()
        
        self.reloadData()
    }
    
    private func createAndConfigureTabBar() {
        let bar = TMBar.ButtonBar()
        let color = UIColor(named: C.Colors.hnOrange)
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        
        bar.backgroundColor = color
        bar.backgroundView.style = .clear
        bar.backgroundView.tintColor = color
        
        bar.buttons.customize {
            $0.backgroundColor = color
            $0.selectedTintColor = UIColor.white
            $0.tintColor = UIColor.black
        }
        
        bar.indicator.tintColor = UIColor.white
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func createAndConfigureVCForTabs() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: C.Storyboards.front)
        let vc2 = storyboard.instantiateViewController(withIdentifier: C.Storyboards.latest)
        let vc3 = storyboard.instantiateViewController(withIdentifier: "topStories")
        self.viewControllers = [vc1, vc2, vc3]
    }
}

//MARK: - Pageboy view controller data source

extension TabViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil
    }
}

//MARK: - TMBar data source

extension TabViewController: TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        guard let title = viewControllers[index].title else { return TMBarItem(title: "none") }
        return TMBarItem(title: title)
    }
}
