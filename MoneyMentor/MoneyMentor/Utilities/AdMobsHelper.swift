//
//  AdMobsHelper.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 10.10.2024.
//

import AdSupport
import AppTrackingTransparency
import Foundation

// AdUnit
enum AdUnit {
    case homeRewarded
    case homeInterstitial
    case homeBanner
    case homeOpenAd
    // You should return your ad unit IDs here
    var unitID: String {
        switch self {
#if DEBUG
            // Admob Test ID
        case .homeRewarded: return "ca-app-pub-3940256099942544/1712485313"
        case .homeInterstitial: return "ca-app-pub-3940256099942544/5135589807"
        case .homeBanner: return "ca-app-pub-3940256099942544/2934735716"
        case .homeOpenAd: return "ca-app-pub-3940256099942544/5662855259"
#else
            // Admob ID
        case .homeRewarded: return Configuration.admobRewarded
        case .homeInterstitial: return Configuration.admobInterstitial
        case .homeBanner: return Configuration.admobBanner
        case .homeOpenAd: return Configuration.admobAppOpen
#endif
        }
    }
}

import SwiftUI
import AdSupport
import AppTrackingTransparency

// NEWLY ADDED PERMISSIONS FOR iOS 14
func requestPermission() {
    @AppStorage("isPurchased") var isPurchased = false
    @AppStorage("requestAds") var requestAds = false
    if !isPurchased {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    requestAds = true
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                    requestAds = true
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                    requestAds = true
                case .restricted:
                    print("Restricted")
                    requestAds = true
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.blue)
            Text("Hello, world!")
            Spacer()
            BannerAdView(adFormat: .standartBanner, onShow: { print("Show Banner") })
        }
        .padding()
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                requestPermission()
            }
        })
    }
}

#Preview {
    ContentView()
}


// MARK: – BannerAdView
// ----------------------------------------------------------------------------------------------------------------
import SwiftUI
import GoogleMobileAds

enum AdFormat {
    case standartBanner
    case largeBanner
    case mediumRectangle
    case fullBanner
    case leaderboard
    case skyscraper
    case fluid
    case adaptiveBanner
    var adSize: GADAdSize {
        switch self {
        case .standartBanner: return GADAdSizeBanner // iPhone and iPod Touch ad size. Typically 320x50.
        case .largeBanner: return GADAdSizeLargeBanner // Taller version of GADAdSizeBanner. Typically 320x100.
        case .mediumRectangle: return GADAdSizeMediumRectangle // Medium Rectangle size for the iPad (especially in a UISplitView's left pane). Typically 300x250.
        case .fullBanner: return GADAdSizeFullBanner // Full Banner size for the iPad (especially in a UIPopoverController or in UIModalPresentationFormSheet). Typically 468x60.
        case .leaderboard: return GADAdSizeLeaderboard // Leaderboard size for the iPad. Typically 728x90.
        case .skyscraper: return GADAdSizeSkyscraper // Skyscraper size for the iPad. Mediation only. AdMob/Google does not offer this size. Typically 120x600.
        case .fluid: return GADAdSizeFluid // An ad size that spans the full width of its container, with a height dynamically determined by the ad.
        case .adaptiveBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        }
    }
    var size: CGSize {
        adSize.size
    }
}
// ------------
enum AdStatus {
    case loading
    case success
    case failure
}
// -------------
struct BannerAdView: View {
    var adUnit: AdUnit = AdUnit.homeBanner
    let adFormat: AdFormat
    @State var adStatus: AdStatus = .loading
    var onShow: () -> Void
    @AppStorage("isPurchased") var isPurchased = false
    var body: some View {
        if !isPurchased {
            HStack {
                if adStatus != .failure {
                    BannerView(adUnitID: adUnit.unitID, adSize: adFormat.adSize, adStatus: $adStatus)
                        .frame(width: adFormat.size.width, height: adFormat.size.height)
                        .onChange(of: adStatus) { status in
                            if status == .success {
                                onShow()
                            }
                        }
                }
            }.frame(maxWidth: .infinity)
        }
        else {
            EmptyView()
        }
    }
}
// ----------------------
struct BannerView: UIViewControllerRepresentable {
    let adUnitID: String
    let adSize: GADAdSize
    @Binding var adStatus: AdStatus
    init(adUnitID: String, adSize: GADAdSize, adStatus: Binding<AdStatus>) {
        self.adUnitID = adUnitID
        self.adSize = adSize
        _adStatus = adStatus
    }
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    // private let adUnitID = "ca-app-pub-3940256099942544/2435281174"
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.delegate = context.coordinator
        return bannerViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // guard viewWidth != .zero else { return }
        bannerView.adSize = adSize // GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    internal class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
        let parent: BannerView
        init(_ parent: BannerView) {
            self.parent = parent
        }
        // MARK: - BannerViewControllerWidthDelegate methods
        func bannerViewController(
            _ bannerViewController: BannerViewController, didUpdate width: CGFloat
        ) {
            parent.viewWidth = width
        }
        // MARK: - GADBannerViewDelegate methods
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("bannerViewDidReceiveAd")
            parent.adStatus = .success
        }
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("didFailToReceiveAdWithError: \(error.localizedDescription)")
            parent.adStatus = .failure
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("bannerViewDidRecordImpression")
        }
        
        func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
            print("bannerViewDidRecordClick")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillPresentScreen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillDismissScreen")
        }
    }
}

protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // do nothing
        } completion: { _ in
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}

// MARK: – BANNER VIEW
// ----------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------

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
