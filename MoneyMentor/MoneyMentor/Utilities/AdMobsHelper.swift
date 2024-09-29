//
//  AdMobsHelper.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 10.10.2024.
//

//import UIKit
//import GoogleMobileAds
//
//class AdMobsHelper: NSObject {
//    enum FullsreenType: CaseIterable {
//        case interstitial
//        case appOpen
//        case reward
//        
//        var admobIds: [String] {
//            switch self {
//            case .interstitial:
//                return SNSAdsManager.interstiliatIds
//            case .appOpen:
//                return SNSAdsManager.openAppIds
//            case .reward:
//                return SNSAdsManager.rewardIds
//            }
//        }
//        
//        var analyticId: String {
//            switch self {
//            case .interstitial:
//                return "inter_general"
//            case .appOpen:
//                return "open"
//            case .reward:
//                return "reward"
//            }
//        }
//    }
//    
//    //MARK: -
//    static let shared = SNSAdsManager()
//    private override init() { }
//    //MARK: -
//    private var typeStringsInLoading: Set<(String)> = []
//    private var loadedAdsDict: [FullsreenType: [Int: GADFullScreenPresentingAd]] = [:]
//    private var presentFullscreenAdCompletionHandler: ((Bool)->())?
//    private var strongAdItem: GADFullScreenPresentingAd?
//    
//    //MARK: -
//    func setup(isPremium: Bool) {
//        guard !isPremium else { return }
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
//        loadFullscreenAds()
//    }
//    
//    func bannerView(vc: UIViewController) -> UIView {
//        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
//        bannerView.adUnitID = Self.bannerId
//        bannerView.rootViewController = vc
//        bannerView.delegate = self
//        bannerView.load(GADRequest())
//        
//        return bannerView
//    }
//    
//    func presentFullscreenAdIfNeeded(type: FullsreenType,
//                                     on vc: ViewController,
//                                     completion completionHandler: @escaping (Bool)->() = { _ in }) {
//        guard !SNSProManager().isPremium else {
//            completionHandler(true)
//            return
//        }
//        
//        SNSAnalManager().send(event: .trying_present,
//                              eventTailStrings: [type.analyticId],
//                              source: vc.screenTitle)
//        guard let adItem = removeBestAd(type: type) else {
//            let errorString = "No \(type) ad to show"
//            SNSAnalManager().send(event: .present_error,
//                                  eventTailStrings: [type.analyticId],
//                                  source: vc.screenTitle,
//                                  error: errorString)
//            print(errorString)
//            completionHandler(false)
//            return
//        }
//        if let interItem = adItem as? GADInterstitialAd {
//            do {
//                try interItem.canPresent(fromRootViewController: vc)
//                presentFullscreenAdCompletionHandler = completionHandler
//                strongAdItem = interItem
//                interItem.fullScreenContentDelegate = self
//                interItem.present(fromRootViewController: vc)
//                SNSAnalManager().send(event: .presented,
//                                      eventTailStrings: [type.analyticId],
//                                      source: vc.screenTitle)
//                loadFullscreenAds(type: type)
//            } catch(let error) {
//                SNSAnalManager().send(event: .present_error,
//                                      eventTailStrings: [type.analyticId],
//                                      source: vc.screenTitle,
//                                      error: error)
//                print("Show \(type) ad error: \(error)")
//                completionHandler(false)
//            }
//        } else {
//            print("Unknown \(type) ad")
//            completionHandler(false)
//        }
//    }
//}
//
////MARK: - Private
//private extension AdMobsHelper {
//    static var bannerId: String = {
//        return SNSEnviromentManager.shared.isProd ? SNSConstants().adMobBannerProdId : SNSConstants().adMobBannerTestId
//    }()
//    
//    static var interstiliatIds: [String] = {
//        return SNSEnviromentManager.shared.isProd ? SNSConstants().adMobInterProdIds : SNSConstants().adMobInterTestIds
//    }()
//    
//    static var openAppIds: [String] = {
//        return SNSEnviromentManager.shared.isProd ? SNSConstants().adMobOpenAppProdIds : SNSConstants().adMobOpenAppTestIds
//    }()
//    
//    static var rewardIds: [String] = {
//        return SNSEnviromentManager.shared.isProd ? SNSConstants().adMobRewardProdIds : SNSConstants().adMobRewardTestIds
//    }()
//    
//    func loadFullscreenAds() {
//        FullsreenType.allCases.forEach({
//            loadFullscreenAds(type: $0)
//        })
//    }
//    
//    func loadFullscreenAds(type: FullsreenType) {
//        if useAsyncLogic() {
//            loadFullscreenAdAsync(type: type)
//        } else {
//            loadFullscreenAdSync(type: type)
//        }
//    }
//    
//    func loadFullscreenAdAsync(type: FullsreenType) {
//        for i in 0..<type.admobIds.count {
//            loadFullscreenAdIfNeeded(type: type,
//                                     level: i) {}
//        }
//    }
//    
//    func loadFullscreenAdSync(type: FullsreenType,
//                              level: Int = 0,
//                              completionHandler: (()->())? = nil) {
//        //TODO
//        //    self?.repeatLoading {
//        //      self?.loadFullscreenAdIfNeeded(type: type,
//        //                                     level: level)
//        //    }
//        guard type.admobIds.count > level else {
//            completionHandler?()
//            return
//        }
//        loadFullscreenAdIfNeeded(type: type,
//                                 level: level) { [weak self] in
//            guard let _ = self?.loadedAdsDict[type]?[level] else {
//                self?.loadFullscreenAdSync(type: type,
//                                           level: level + 1,
//                                           completionHandler: completionHandler)
//                return
//            }
//            completionHandler?()
//        }
//    }
//    
//    func loadFullscreenAdIfNeeded(type: FullsreenType,
//                                  level: Int,
//                                  completion completionHandler: (()->())? = nil) {
//        let typeLevelString = typeLevelString(fullScreentype: type,
//                                              level: level)
//        guard
//            !typeStringsInLoading.contains(typeLevelString),
//            loadedAdsDict[type]?[level] == nil
//        else {
//            completionHandler?()
//            return
//        }
//        
//        typeStringsInLoading.insert(typeLevelString)
//        loadRawFullscreenAd(type: type,
//                            level: level) { [weak self] adItem in
//            self?.typeStringsInLoading.remove(typeLevelString)
//            if self?.loadedAdsDict[type] == nil {
//                self?.loadedAdsDict[type] = [level: adItem]
//            } else {
//                self?.loadedAdsDict[type]?[level] = adItem
//            }
//            completionHandler?()
//        } error: { [weak self] errorString in
//            self?.typeStringsInLoading.remove(typeLevelString)
//            print("Failed to load \(type) level \(level) ad with error: \(errorString)")
//            completionHandler?()
//            //      self?.repeatLoading {
//            //        self?.loadFullscreenAdIfNeeded(type: type,
//            //                                       level: level)
//            //      }
//        }
//    }
//    
//    func loadRawFullscreenAd(type: FullsreenType,
//                             level: Int,
//                             success successHandler: @escaping (GADFullScreenPresentingAd)->(),
//                             error errorHandler: @escaping (String)->()) {
//        let request = GADRequest()
//        switch type {
//        case .interstitial:
//            guard let admobId = type.admobIds.count > level ? type.admobIds[level] : nil else {
//                let errorString = "No admob id for requested level"
//                SNSAnalManager().send(event: .loading_error,
//                                      eventTailStrings: [type.analyticId],
//                                      error: errorString)
//                errorHandler(errorString)
//                return
//            }
//            GADInterstitialAd.load(withAdUnitID: admobId,
//                                   request: request) { ad, error in
//                if let error = error {
//                    let errorString = error.localizedDescription
//                    SNSAnalManager().send(event: .loading_error,
//                                          eventTailStrings: [type.analyticId],
//                                          error: errorString)
//                    errorHandler(errorString)
//                    return
//                }
//                guard let adItem = ad else {
//                    let errorString = "empty ad \(type)"
//                    SNSAnalManager().send(event: .loading_error,
//                                          eventTailStrings: [type.analyticId],
//                                          error: errorString)
//                    errorHandler(errorString)
//                    return
//                }
//                successHandler(adItem)
//                SNSAnalManager().send(event: .loading_success,
//                                      eventTailStrings: [type.analyticId])
//            }
//        case .appOpen:
//            errorHandler("undefined ad type")
//        case .reward:
//            errorHandler("undefined ad type")
//        }
//    }
//    
//    func repeatLoading(handler: @escaping ()->()) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//            handler()
//        }
//    }
//    
//    func typeLevelString(fullScreentype: FullsreenType,
//                         level: Int) -> String {
//        return "\(fullScreentype)-\(level)"
//    }
//    
//    func removeBestAd(type: FullsreenType) -> GADFullScreenPresentingAd? {
//        guard let adItemsLevelDict = loadedAdsDict[type],
//              let bestLevel = adItemsLevelDict.keys.sorted(by: >).first else {
//            return nil
//        }
//        
//        return loadedAdsDict[type]?.removeValue(forKey: bestLevel)
//    }
//    
//    func useAsyncLogic() -> Bool {
//        return true
//    }
//}
//
////MARK: - GADBannerViewDelegate
//extension AdMobsHelper: GADBannerViewDelegate {
//    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//        SNSAnalManager().send(event: .loading_success,
//                              eventTails: [.banner])
//    }
//    
//    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        SNSAnalManager().send(event: .loading_error,
//                              eventTails: [.banner],
//                              error: error.localizedDescription)
//    }
//}
//
////MARK: - GADFullScreenContentDelegate
//extension SNSAdsManager: GADFullScreenContentDelegate {
//    func ad(_ ad: GADFullScreenPresentingAd,
//            didFailToPresentFullScreenContentWithError error: Error) {
//        presentFullscreenAdCompletionHandler?(false)
//        presentFullscreenAdCompletionHandler = nil
//    }
//    
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        presentFullscreenAdCompletionHandler?(true)
//        presentFullscreenAdCompletionHandler = nil
//    }
//}
