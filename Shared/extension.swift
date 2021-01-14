//
//  SwiftUIExtension.swift
//  Created by Tariq Almazyad on 12/25/20.
//

import SwiftUI
import SystemConfiguration
import MapKit
import Photos
import MessageUI
import UserNotifications
import CoreLocation
import CoreImage.CIFilterBuiltins


// MARK:- statusBarStyle Dark / Light
class HostingController<Content: View>: UIHostingController<Content> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.statusBarStyle
    }
}


/* how to use HostingController + RootView
 
 var body: some Scene {
 WindowGroup {
 RootView {
 ContentView()
 }
 }
 
 then -: ->
 
 struct ContentView: View {
 var previews: some View {
 Text("")
 .setStatusBarStyle(.light or dark)
 }
 }
 
 
 
 */
///By wrapping views in a RootView, they will become the app's main / primary view. This will enable setting the statusBarStyle.
struct RootView<Content: View> : View {
    var content: Content
    
    init(@ViewBuilder content: () -> (Content)) {
        self.content = content()
    }
    
    var body:some View {
        EmptyView()
            .onAppear {
                UIApplication.shared.setHostingController(rootView: AnyView(content))
            }
    }
}

extension UIApplication {
    static var hostingController: HostingController<AnyView>? = nil
    
    static var statusBarStyleHierarchy: [UIStatusBarStyle] = []
    static var statusBarStyle: UIStatusBarStyle = .darkContent
    
    ///Sets the App to start at rootView
    func setHostingController(rootView: AnyView) {
        let hostingController = HostingController(rootView: AnyView(rootView))
        windows.first?.rootViewController = hostingController
        UIApplication.hostingController = hostingController
    }
    
    static func setStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        hostingController?.setNeedsStatusBarAppearanceUpdate()
    }
}




/* How to use EmailView
 struct ContentView: View {
 var previews: some View {
 Text("")
 EmailView(result: <#T##Binding<Result<MFMailComposeResult, Error>?>#>,
 recipients: <#T##[String]#>,
 subject: <#T##String#>,
 body: <#T##String#>,
 attachements: <#T##[(Data, String)]#>)
 }
 }
 
 */
// MARK:- EmailView
public struct EmailView: UIViewControllerRepresentable {
    public init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        recipients: [String],
        subject: String,
        body: String,
        attachements: [(Data, String)]
    ) {
        self._result = result
        self.recipients = recipients
        self.subject = subject
        self.body = body
        self.attachements = attachements
    }
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    var recipients: [String]
    var subject: String
    var body: String
    var attachements: [(Data, String)]
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        public init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }
    
    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        attachements.forEach { (data, filename) in
            vc.addAttachmentData(data, mimeType: "utf8", fileName: filename)
        }
        vc.setMessageBody(body, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}


// MARK:- Int
extension Int {
    /// to convert Int value to Double
    func toDouble() -> Double {
        Double(self)
    }
    /// to convert Int value to String
    func toString() -> String {
        "\(self)"
    }
}



/* HOW TO USE   doubleToDateInString()
 67.443.doubleToDateInString(YOUR STYLE) --> 1 minutes and 7 seconds
 */

// MARK:- Double
extension Double {
    func doubleToDateInString(formattedType: DateFormattedType) -> String {
        return Date(timeIntervalSince1970: self).convertDate(formattedString: formattedType)
    }
    /// to convert Double value to Int
    func toInt() -> Int {
        Int(self)
    }
    /// to convert Double  value to String
    func toString() -> String {
        String(format: "%.02f", self)
    }
    
    /// let dPrice = 16.50  -->  let strPrice = dPrice.toPrice(currency: "€")
    func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}


// MARK:- Date
extension Date {
    /// To convert a date to specific type
    func convertDate(formattedString: DateFormattedType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formattedString.rawValue
        return formatter.string(from: self)
    }
    
    
    ///
    /// - Parameters:
    ///   - style: abbreviated =  1m 59s ,  full = 1 minute, 59 seconds , brief =  1min 59sec , positional =  00:1:59 as ( h:m:ss) ,  short = 1 min, 59 sec, spellOut = one minute, fifty-nine seconds
    ///   - maximumUnitCount: allowed maximum unit time to show [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
    /// - Returns: String
    func convertToTimeAgo(style: DateComponentsFormatter.UnitsStyle, maximumUnitCount: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: self, to: now) ?? ""
    }
    ///
    /// - Parameters:
    ///   - style: abbreviated =  1m 59s ,  full = 1 minute, 59 seconds , brief =  1min 59sec , positional =  00:1:59 as ( h:m:ss) ,  short = 1 min, 59 sec, spellOut = one minute, fifty-nine seconds
    ///   - maximumUnitCount: allowed maximum unit time to show [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
    /// - Returns: String
    func convertToTimeWill(style: DateComponentsFormatter.UnitsStyle, maximumUnitCount: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = maximumUnitCount
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: now, to: self) ?? ""
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0.0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0.0 }
        return Float(start - end)
    }
    
}

enum DateFormattedType: String, CaseIterable {
    /// Date sample  Sunday, Sep 6, 2020
    case formattedType1 = "EEEE, MMM d, yyyy"
    /// Date sample  09/24/2020
    case formattedType2 = "MM/dd/yyyy"
    /// Date sample  09-06-2020 02:45 AM
    case formattedType3 = "MM-dd-yyyy h:mm a"
    /// Date sample  Sep 6, 2:45 AM
    case formattedType4 = "MMM d, h:mm a"
    /// Date sample  02:45:07.397
    case formattedType5 = "HH:mm:ss.SSS"
    /// Date sample  02:45:07.397
    case formattedType6 = "dd.MM.yy"
    /// Date sample  Sep 6, 2020
    case formattedType7 = "MMM d, yyyy"
    /// Time sample  24/05/2020 ● 9:24:22 PM
    case formattedType8 = "dd/MM/yyyy ● h:mm:ss a"
    /// Time sample  Fri23/Oct/2020
    case formattedType9 = "E d/MMM/yyy"
    /// Thu, 22 Oct 2020 5:56:22 pm
    case formattedType10 = "E, d MMM yyyy h:mm:ss a"
    /// Date sample for Month only JUNE
    case formattedType11 = "MMMM"
    /// Date sample for Day in Number only 04
    case formattedType12 = "dd"
    /// to get seconds only
    case formattedType13 = "ss"
    /// time only 9:24:22 PM
    case timeOnly = "h:mm a"
}


// MARK:- String
extension String {
    
    /// Check for text Validation
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    /// to check if email is valid
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    /// to check if phone number has 10 digits , e.g !phoneNumber.isValidPhoneNumber
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    /// remove white spaces
    var trimWhiteSpace: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    mutating func trim(){
        self = self.trimWhiteSpace
    }
    /// to convert string to URL
    var asURL: URL? {
        URL(string: self)
    }
    
    /// to get the width of textField based on the font
    func widthOfText(_ text: String, font: UIFont) -> CGFloat {
        return text.widthOfString(usingFont: font)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    /// to convet string to Double
    func toDouble() -> Double {
        Double(self)!
    }
    
}

// MARK:- Dictionaries
extension Array where Element: Hashable {
    /// userful extension to remove any duplicated items in gived array with O(n) time complexity
    var removeDuplicatedItems: [Element] {
        var allowed = Set(self)
        return compactMap { allowed.remove($0) }
    }
}
extension RangeReplaceableCollection where Element: Hashable {
    /// userful extension to remove any duplicated items in dictionaries
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}


/* How to use NetworkManager
 
 if NetworkManager.shared.isConnectedToNetwork() { }
 
 */
// MARK:- NetworkManager
public class NetworkManager {
    
    static let shared = NetworkManager()
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}

/*YOU CAN USE ANY VIEW MODIFIER BELOW BY SIMPLY
 
 struct ContentView: View {
 var previews: some View {
 Text("")
 .yourModifier
 }
 }
 
 */


// MARK:-CGFloat

extension CGFloat {
    
    enum ScalerView: CGFloat  {
        case leftView = 32
        case middleView = 140
        case rightView = 200
    }
    /// Usage ony for HStack scrollView to scale images up and down based in their location in Screen , left, middle or right
    static func getScale(proxy: GeometryProxy, scalerView: ScalerView) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x - scalerView.rawValue)
        scale = diff < 100 ? 1 + (100 - diff) / 500 : 1
        return scale
    }
}



// MARK:- View Modifiers
fileprivate var context = CIContext()
fileprivate var filter = CIFilter.qrCodeGenerator()

extension View {
    /// to generate QRCode by passing any object that confirms to Codable protocol
    func generateQRCode<T: Codable>(from anyObject: T) -> UIImage {
        do {
            let data = try JSONEncoder().encode(anyObject)
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    /// Check new user , if yes ? then do X
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    func tabViewPagingModifier(currentPageIndicatorTintColor: Color, pageIndicatorTintColor: Color) -> some View{
        return self.onAppear{
            UIPageControl.appearance().currentPageIndicatorTintColor = currentPageIndicatorTintColor.uiColor()
            UIPageControl.appearance().pageIndicatorTintColor = pageIndicatorTintColor.uiColor().withAlphaComponent(0.4)
        }
    }
    
    /// change the keyboard appearnce to Dark / light mode -- usage ? --> .keyboardAppeance(.dark)
    func keyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) -> some View{
        return self.onAppear{
            UITextField.appearance().keyboardAppearance = keyboardAppearance
        }
    }
    
    ///Sets the status bar style color for this view. usage ? --> .statusBarStyle(.dark)
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        UIApplication.statusBarStyleHierarchy.append(style)
        //Once this view appears, set the style to the new style. Once it disappears, set it to the previous style.
        return self.onAppear {
            UIApplication.setStatusBarStyle(style)
        }.onDisappear {
            guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
            let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(style)
        }
    }
    /// hide keyboard when touch outside of textField. usage ? --> .hideKeyboardWhenTouchOutsideTextField()
    func hideKeyboardWhenTouchOutsideTextField() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    /// Add ability to dismiss keyboard when adding ScrollView to View --- usage ? --> .hideKeyboardWhenScroll(. drag)
    func hideKeyboardWhenScroll(interactionType:  UIScrollView.KeyboardDismissMode) -> some View {
        return self.onAppear{
            UIScrollView.appearance().keyboardDismissMode = interactionType
        }
    }
    
    /// to modify  the navBar attributes , title , bar color , and Translucent
    func navBarModifier(largeTitleColor: Color, smallTitleColor: Color,
                        isTranslucent: Bool, barStyle:  UIBarStyle,
                        navBackgroundColor: Color = .clear, tintColor: Color = .clear,
                        userInterfaceStyile: UIUserInterfaceStyle = .unspecified) -> some View {
        
        return self.onAppear{
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: largeTitleColor.uiColor()]
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: smallTitleColor.uiColor()]
            UINavigationBar.appearance().isTranslucent = isTranslucent
            UINavigationBar.appearance().barStyle = barStyle
            UINavigationBar.appearance().backgroundColor = navBackgroundColor.uiColor()
            UINavigationBar.appearance().tintColor = tintColor.uiColor()
            UINavigationBar.appearance().overrideUserInterfaceStyle = userInterfaceStyile
        }
    }
    
    /// manage cell background color and List View color
    func listBackgroundModifier(backgroundColor: Color) -> some View {
        return self.onAppear{
            UITableView.appearance().backgroundColor = backgroundColor.uiColor()
        }
    }
    
    /// custom function for cornerRadius to give specific value in how to curve the corner
    func allCornersRadius(corners: UIRectCorner, _ radius: CGFloat) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    /// simple print fuction
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
    /// to alow the pushed View to pop , NOTE: only use it on mainViews
    func lazyPop(isEnabled: (Binding<Bool>)? = nil) -> some View {
        return LazyPop(self, isEnabled: isEnabled)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/* How to use
 
 NavigationView{
 
 NavigationLink(
 destination: NavigationLazyView(/*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/),
 isActive: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/,
 label: {
 /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/
 })
 }
 
 */

// MARK:- NavigationLazyView
/// to load the destination lazily without making unnecessary API request
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}


// MARK:- Color -> uiColor()
extension Color {
    func uiColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }
        
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

enum SmallDevices: String, CaseIterable {
    case iPhone7 = "iPhone 7"
    case iPhone8 = "iPhone 8"
    case iPhoneSE = "iPhone SE"
    case iPhoneX = "iPhone X"
    case iPhoneXs = "iPhone Xs"
    
    var currentDevice: String {
        switch self {
        case .iPhone7: return  "iPhone 7"
        case .iPhone8: return  "iPhone 8"
        case .iPhoneSE: return  "iPhone SE"
        case .iPhoneX: return  "iPhone X"
        case .iPhoneXs: return  "iPhone Xs"
        }
    }
}

enum LargeDevices: String, CaseIterable {
    case iPhone7Plus = "iPhone 7 Plus"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhoneXsMax = "iPhone Xs Max"
    
    var currentDevice: String {
        switch self {
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneXsMax: return "iPhone Xs Max"
        }
    }
}


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

/*How to use
 
 NavigationView{
 NavigationLink(
 destination: NavigationLazyView(/*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/)
 .lazyPop(),
 isActive: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/,
 label: {
 
 })
 }
 
 */

//MARK:- SwipeRightToPopViewController
class SwipeRightToPopViewController<Content>: UIHostingController<Content>, UINavigationControllerDelegate where Content : View {
    
    fileprivate var lazyPopContent: LazyPop<Content>?
    private var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition?
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var parentNavigationControllerToUse: UINavigationController?
    private var gestureAdded = false
    
    override func viewDidLayoutSubviews() {
        // You need to add gesture events after every subview layout to protect against weird edge cases
        //    One notable edgecase is if you are in a splitview in landscape. In this case, there will be
        //    no nav controller with 2 vcs, so our addGesture will fail. After rotating back to portrait,
        //    the splitview will combine into one view with the details pushed on top. So only then would
        //    would the addGesture find a parent nav controller with 2 view controllers. I don't know if
        //    there are other edge cases, but running addGesture on every viewDidLayoutSubviews seems safe.
        addGesture()
    }
    
    public func addGesture() {
        if !gestureAdded {
            // attempt to find a parent navigationController
            var currentVc: UIViewController = self
            while true {
                if (currentVc.navigationController != nil) &&
                    currentVc.navigationController?.viewControllers.count > 1
                {
                    parentNavigationControllerToUse = currentVc.navigationController
                    break
                }
                guard let parent = currentVc.parent else {
                    return
                }
                currentVc = parent
            }
            guard parentNavigationControllerToUse?.viewControllers.count > 1 else {
                return
            }
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeRightToPopViewController.handlePanGesture(_:)))
            self.view.addGestureRecognizer(panGestureRecognizer)
            gestureAdded = true
        }
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        // if the parentNavigationControllerToUse has a width value, use that because it's more accurate. Otherwise use this view's width as a backup
        let total = parentNavigationControllerToUse?.view.frame.width ?? view.frame.width
        let percent = max(panGesture.translation(in: view).x, 0) / total
        
        switch panGesture.state {
        
        case .began:
            if lazyPopContent?.isEnabled == true {
                parentNavigationControllerToUse?.delegate = self
                _ = parentNavigationControllerToUse?.popViewController(animated: true)
            }
            
        case .changed:
            if let percentDrivenInteractiveTransition = percentDrivenInteractiveTransition {
                percentDrivenInteractiveTransition.update(percent)
            }
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x
            
            // Continue if drag more than 50% of screen width or velocity is higher than 100
            if percent > 0.5 || velocity > 100 {
                percentDrivenInteractiveTransition?.finish()
            } else {
                percentDrivenInteractiveTransition?.cancel()
            }
            
        case .cancelled, .failed:
            percentDrivenInteractiveTransition?.cancel()
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlideAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        parentNavigationControllerToUse?.delegate = nil
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition?.completionCurve = .easeOut
        } else {
            percentDrivenInteractiveTransition = nil
        }
        
        return percentDrivenInteractiveTransition
    }
}


fileprivate struct LazyPop<Content: View>: UIViewControllerRepresentable {
    let rootView: Content
    @Binding var isEnabled: Bool
    
    init(_ rootView: Content, isEnabled: (Binding<Bool>)? = nil) {
        self.rootView = rootView
        self._isEnabled = isEnabled ?? Binding<Bool>(get: { return true }, set: { _ in })
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = SwipeRightToPopViewController(rootView: rootView)
        vc.lazyPopContent = self
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let host = uiViewController as? UIHostingController<Content> {
            host.rootView = rootView
        }
    }
}


class SlideAnimatedTransitioning: NSObject ,UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        
        let width = containerView.frame.width
        
        var offsetLeft = fromView?.frame
        offsetLeft?.origin.x = width
        
        var offscreenRight = toView?.frame
        offscreenRight?.origin.x = -width / 3.33;
        
        toView?.frame = offscreenRight!;
        
        fromView?.layer.shadowRadius = 5.0
        fromView?.layer.shadowOpacity = 1.0
        toView?.layer.opacity = 0.9
        
        containerView.insertSubview(toView!, belowSubview: fromView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, options:.curveLinear, animations:{
            
            toView?.frame = (fromView?.frame)!
            fromView?.frame = offsetLeft!
            
            toView?.layer.opacity = 1.0
            fromView?.layer.shadowOpacity = 0.1
            
        }, completion: { finished in
            toView?.layer.opacity = 1.0
            toView?.layer.shadowOpacity = 0
            fromView?.layer.opacity = 1.0
            fromView?.layer.shadowOpacity = 0
            
            // when cancelling or completing the animation, ios simulator seems to sometimes flash black backgrounds during the animation. on devices, this doesn't seem to happen though.
            // containerView.backgroundColor = [UIColor whiteColor];
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
}


// MARK:- PHAsset
extension PHAsset {
    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            guard let image = image else {return}
            thumbnail = image
        })
        return thumbnail
    }
}

// MARK:- UIDevice
extension UIDevice {
    /// example UIDevice.vibrate()
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}


// MARK:- Bundle
extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    /// to get the app version   ---> let appVersion = Bundle.mainAppVersion
    
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}

// MARK:- MKPlacemark
extension MKPlacemark {
    var address: String? {
        get {
            guard let subThroughFare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            return "\(subThroughFare) \(thoroughfare) , \(locality), \(adminArea)"
        }
    }
}

// MARK:- MKMapView
extension MKMapView {
    
    func zoomeToFit(annotations: [MKAnnotation]) {
        var zoomRec = MKMapRect.null
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRec = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.05, height: 0.05)
            zoomRec = zoomRec.union(pointRec)
            
        }
        let insets = UIEdgeInsets(top: 75, left: 75, bottom: 200, right: 75)
        setVisibleMapRect(zoomRec, edgePadding: insets, animated: true)
    }
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel){
            setCenterCoordinate(coordinate:self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }
    
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }
    
}

/*
 Hoe to use NotificationManager
 
 NotificationManager.shared.requestPushNotification { (success, error) in
 
 } settings: { settings in
 switch settings.authorizationStatus {
 
 case .notDetermined:
 <#code#>
 case .denied:
 <#code#>
 case .authorized:
 <#code#>
 case .provisional:
 <#code#>
 case .ephemeral:
 <#code#>
 @unknown default:
 <#code#>
 }
 }
 
 */

// MARK:- NotificationManager

/// class object to request user permission for notification
class NotificationManager: NSObject, UNUserNotificationCenterDelegate  {
    /// class signlton of NotificationManager
    
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
    }
    
    /// request notification
    func requestPushNotification(completion: @escaping((Bool, Error?) -> Void), settings: @escaping((UNNotificationSettings) -> Void)){
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completion)
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: settings)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}



// place this propertyList in p.list
//<key>NSLocationAlwaysUsageDescription</key>
//<string>$(PRODUCT_NAME) would like to access to your location</string>
//<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
//<string>$(PRODUCT_NAME) would like to access to your location</string>
//<key>NSLocationWhenInUseUsageDescription</key>
//<string>$(PRODUCT_NAME) would like to access to your location</string>

/* How to use
 LocationManager.shared.requestLocationAccess { locationManager in
 switch locationManager.authorizationStatus{
 
 case .notDetermined:
 <#code#>
 case .restricted:
 <#code#>
 case .denied:
 <#code#>
 case .authorizedAlways:
 <#code#>
 case .authorizedWhenInUse:
 <#code#>
 @unknown default:
 <#code#>
 }
 }
 
 */

// MARK:-LocationManager

/// You use instances of this class to configure, start, and stop the Core Location services,\n
/// 1- LocationManager.shared.requestLocationAccess to request user location\n
/// 2- LocationManager.shared.startUpdating start updating user location to get location result\n
/// 3- LocationManager.shared.stopUpdating to stop update location when user quit or leave the app\n
/// 4- get current user location anywhere in the app by typing LocationManager.currentLocation.lat LocationManager.currentLocation.lon\n
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var completion:((CLLocationManager) -> Void)?
    
    static var currentLocation: CLLocationCoordinate2D {
        guard let location = LocationManager.shared.location else { return .init(latitude: 0.0, longitude: 0.0)}
        return location
    }
    
    private override init() {
        super.init()
    }
    
    /// request user permission to get current location with optional completion
    func requestLocationAccess(completion: ((CLLocationManager) -> Void)?){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating(){
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        location = currentLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: fail with  error ", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            completion?(manager)
            switch manager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                break
            case .authorizedAlways:
                locationManager.requestAlwaysAuthorization()
            case .authorizedWhenInUse:
                locationManager.requestAlwaysAuthorization()
            @unknown default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

/*How to use CustomModelView
 
 ZStack {
 CustomModelView(isModalShowing: <#T##Binding<Bool>#>, backgroundColor: <#T##Binding<Color>#>,
 modalHeight: <#T##CGFloat#>, content: <#T##() -> _#>)
 }
 
 */

// MARK:- CustomModelView
struct CustomModelView<Content: View> : View {
    @GestureState private var dragState = DragState.inactive
    @Binding var isModalShowing:Bool
    @Binding var backgroundColor: Color
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = modalHeight * (2/3)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold{
            isModalShowing = false
        }
    }
    
    var modalHeight: CGFloat = 400
    
    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        return Group {
            ZStack {
                //Background
                Spacer()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    .background(isModalShowing ? Color.black.opacity( 0.5 * fraction_progress(lowerLimit: 0, upperLimit: Double(modalHeight), current: Double(dragState.translation.height), inverted: true)) : Color.clear)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .offset(y: -40)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                self.isModalShowing = false
                            }
                    )
                
                //Foreground
                VStack{
                    Spacer()
                    ZStack{
                        backgroundColor
                            .frame(width: UIScreen.main.bounds.size.width, height:modalHeight)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        self.content()
                            .padding()
                            .padding(.bottom, 65)
                            .frame(width: UIScreen.main.bounds.size.width, height:modalHeight)
                            .clipped()
                    }
                    .offset(y: isModalShowing ? ((self.dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(drag)
                    
                    
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
    
    
    
    func fraction_progress(lowerLimit: Double = 0, upperLimit:Double, current:Double, inverted:Bool = false) -> Double{
        var val:Double = 0
        if current >= upperLimit {
            val = 1
        } else if current <= lowerLimit {
            val = 0
        } else {
            val = (current - lowerLimit)/(upperLimit - lowerLimit)
        }
        
        if inverted {
            return (1 - val)
            
        } else {
            return val
        }
        
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
}


/* How to use
 
 It works 100% in Forms and Sections .
 
 DynamicTextField(<#T##title: String##String#>,
 text: <#T##Binding<String>#>,
 isFocused: <#T##Binding<Bool>?#>,
 returnKeyType: <#T##DynamicTextField.ReturnKeyType#>,
 onEditingChanged: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>,
 onCommit: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
 
 */
// MARK:- DynamicTextField
public struct DynamicTextField: View {
    var title: String
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @State var height: CGFloat = 0
    var returnKeyType: ReturnKeyType
    var onCommit: (() -> Void)?
    var onEditingChanged: ((Bool) -> Void)?
    
    
    /// Creates a multiline text field with a text label.
    ///
    /// - Parameters:
    ///   - title: The title of the text field.
    ///   - text: The text to display and edit.
    ///   - isFocused: Whether or not the field should be focused.
    ///   - returnKeyType: The type of return key to be used on iOS.
    ///   - onEditingChanged: Detects when user is typing
    ///   - onCommit: An action to perform when the user presses the
    ///     Return key) while the text field has focus. If `nil`, a newline
    ///     will be inserted.
    public init(
        _ title: String,
        text: Binding<String>,
        isFocused: Binding<Bool>? = nil,
        returnKeyType: ReturnKeyType = .default,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.title = title
        _text = text
        self.isFocused = isFocused
        self.returnKeyType = returnKeyType
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(title).foregroundColor(.secondary).opacity(0.5)
            }
            DynamicTextFieldRep(
                text: $text,
                isFocused: isFocused,
                height: $height,
                returnKeyType: returnKeyType,
                onEditingChanged: onEditingChanged,
                onCommit: onCommit
            )
            .frame(height: height)
        }
    }
}

public extension DynamicTextField {
    enum ReturnKeyType {
        case done
        case next
        case `default`
        case `continue`
        
        #if os(iOS)
        var uiReturnKey: UIReturnKeyType {
            switch self {
            case .done:
                return .done
            case .next:
                return .next
            case .default:
                return .default
            case .continue:
                return .continue
            }
        }
        #endif
    }
}


#if os(macOS)
struct DynamicTextFieldRep: NSViewRepresentable {
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @Binding var height: CGFloat
    
    // Unused in macOS, but retained for API parity.
    var returnKeyType: DynamicTextField.ReturnKeyType
    var onEditingChanged: ((Bool) -> Void)?
    var onCommit: (() -> Void)?
    
    func makeNSView(context: Context) -> NSTextView {
        let view = OmenNSTextView()
        view.onFocusChange = { self.isFocused?.wrappedValue = $0 }
        view.font = NSFont.preferredFont(forTextStyle: .body)
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.textContainerInset = .zero
        view.textContainer?.lineFragmentPadding = 0
        view.string = text
        DispatchQueue.main.async {
            height = view.textHeight()
        }
        return view
    }
    
    func updateNSView(_ view: NSTextView, context _: Context) {
        if view.string != text {
            view.string = text
            DispatchQueue.main.async {
                height = view.textHeight()
            }
        }
        
        if let isFocused = isFocused?.wrappedValue {
            DispatchQueue.main.async {
                let isFirstResponder = view.window?.firstResponder == view
                if isFocused, !isFirstResponder {
                    view.window?.makeFirstResponder(view)
                } else if !isFocused, isFirstResponder {
                    view.window?.makeFirstResponder(nil)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(rep: self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        let rep: DynamicTextFieldRep
        
        internal init(rep: DynamicTextFieldRep) {
            self.rep = rep
        }
        
        func textDidChange(_ notification: Notification) {
            guard let view = notification.object as? NSTextView else { return }
            
            rep.text = view.string
            DispatchQueue.main.async {
                self.rep.height = view.textHeight()
            }
        }
        
        func textDidEndEditing(_: Notification) {
            rep.isFocused?.wrappedValue = false
        }
        
        func textView(_: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            // Call `onCommit` when the Return key is pressed without Shift.
            // If Shift-Return is pressed, a newline will be inserted.
            if commandSelector == #selector(NSResponder.insertNewline(_:)),
               let event = NSApp.currentEvent,
               !event.modifierFlags.contains(.shift)
            {
                rep.onCommit?()
                return true
            }
            
            return false
        }
    }
}

/// This is necessary because `textDidBeginEditing` on `NSTextViewDelegate` only triggers once the user types.
class OmenNSTextView: NSTextView {
    var onFocusChange: (Bool) -> Void = { _ in }
    
    override func becomeFirstResponder() -> Bool {
        onFocusChange(true)
        return super.becomeFirstResponder()
    }
}

extension NSTextView {
    func textHeight() -> CGFloat {
        if let layoutManager = layoutManager, let container = layoutManager.textContainers.first {
            return layoutManager.usedRect(for: container).height
        } else {
            return frame.height
        }
    }
}
#endif


#if os(iOS)
struct DynamicTextFieldRep: UIViewRepresentable {
    @Binding var text: String
    var isFocused: Binding<Bool>?
    @Binding var height: CGFloat
    var returnKeyType: DynamicTextField.ReturnKeyType
    var onEditingChanged: ((Bool) -> Void)?
    var onCommit: (() -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
        uiView.backgroundColor = .clear
        uiView.delegate = context.coordinator
        uiView.textContainerInset = .zero
        uiView.textContainer.lineFragmentPadding = 0
        uiView.text = text
        uiView.returnKeyType = returnKeyType.uiReturnKey
        height = uiView.textHeight()
        return uiView
    }
    
    func updateUIView(_ uiView: UITextView, context _: Context) {
        if uiView.text != text {
            uiView.text = text
            height = uiView.textHeight()
        }
        
        if let isFocused = isFocused?.wrappedValue {
            if isFocused, !uiView.isFirstResponder {
                uiView.becomeFirstResponder()
            } else if !isFocused, uiView.isFirstResponder {
                uiView.resignFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(rep: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let rep: DynamicTextFieldRep
        
        internal init(rep: DynamicTextFieldRep) {
            self.rep = rep
        }
        
        func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
            guard let onCommit = rep.onCommit, text == "\n" else { return true }
            onCommit()
            return false
        }
        
        func textViewDidChange(_ textView: UITextView) {
            rep.text = textView.text
            rep.height = textView.textHeight()
        }
        
        func textViewDidBeginEditing(_: UITextView) {
            rep.isFocused?.wrappedValue = true
        }
        
        func textViewDidEndEditing(_: UITextView) {
            rep.isFocused?.wrappedValue = false
        }
    }
}

extension UITextView {
    func textHeight() -> CGFloat {
        sizeThatFits(
            CGSize(
                width: frame.size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        .height
    }
}
#endif

