//
//  Detail.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/14/21.
//

import SwiftUI
import MapKit

extension Font {
    static func avenirNext(size: Int) -> Font {
        return Font.custom("Avenir Next", size: CGFloat(size))
    }
    
    static func avenirNextRegular(size: Int) -> Font {
        return Font.custom("AvenirNext-Regular", size: CGFloat(size))
    }
}

struct DetailView: View {
    
    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 75
    
    @ObservedObject private var articleContent: ViewFrame = ViewFrame()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero
    @State private (set) var region : MKCoordinateRegion
    @Binding var isShowingDetail: Bool
    
    let festival: Festival
    
    init(festival: Festival, isShowingDetail: Binding<Bool>) {
        self.festival = festival
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: festival.details[0].lat,
                                                                            longitude: festival.details[0].long),
                                                              span: .init(latitudeDelta: 0.01,
                                                                          longitudeDelta: 0.01)))
        self._isShowingDetail = isShowingDetail
    }
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)).ignoresSafeArea()
            ScrollView {
                VStack {
                    ArtistInfoView(titleRect: $titleRect, festival: festival)
                    
                    Map(coordinateRegion: $region, annotationItems: MockData.festivals) { festival in
                        MapAnnotation(coordinate: .init(latitude: festival.details[0].lat,
                                                        longitude: festival.details[0].long)) {
                            ZStack{
                                Image(festival.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 55, height: 55)
                                    .clipShape(Circle())
                                    .shadow(color: Color.white.opacity(0.1), radius: 10)
                                    .overlay( Text("Tomorrowland")
                                                .frame(width: 150, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                                .background(Color(#colorLiteral(red: 0.5608644485, green: 0.4099974632, blue: 0.828809917, alpha: 1)))
                                                .allCornersRadius(corners: [.topLeft, .topRight, .bottomRight], 20)
                                                .padding(49)
                                              , alignment: .bottomLeading
                                    )
                            }
                        }
                    }.frame(height: 300)
                    .cornerRadius(20)
                    .padding()
                    .padding(.bottom, 20)
                    .colorScheme(.dark)
                    .shadow(color: Color.white.opacity(0.3), radius: 10)
                    
                    VStack {
                        HStack{
                            Text("Interested")
                            Spacer()
                        }.padding()
                        HStack {
                            HStack(spacing: -8){
                                ForEach(0 ..< 5) { item in
                                    Image(festival.details.first?.people.first?.imageName ?? "")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .overlay(Circle().stroke(Color.white,lineWidth: 0.8))
                                        .clipShape(Circle())
                                        .padding(.bottom, 26)
                                }
                            }.padding(.horizontal)
                            Spacer()
                        }
                    }
                    
                    Button(action: {}, label: {
                        Text("Buy Ticket")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .frame(width: 290, height: 50)
                            .padding(6)
                            .background(Color(#colorLiteral(red: 0.5608644485, green: 0.4099974632, blue: 0.828809917, alpha: 1)))
                            .cornerRadius(24)
                    })
                    .padding(.bottom, 86)
                }
                
                .offset(y: imageHeight + 40)
                .background(GeometryGetter(rect: $articleContent.frame))
                
                GeometryReader { geometry in
                    // 3
                    ZStack(alignment: .bottom) {
                        TabView{
                            ForEach(MockData.festivals) { festival in
                                ZStack {
                                    Image(festival.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry) + 30)
                                        .clipped()
                                        .blur(radius: self.getBlurRadiusForImage(geometry))
                                        .background(GeometryGetter(rect: self.$headerImageRect))
                                }
                            }
                        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry) + 30)
                        
                        // 4
                        Text("How to build a parallax scroll view")
                            .font(.avenirNext(size: 17))
                            .foregroundColor(.white)
                            .offset(x: 0, y: self.getHeaderTitleOffset() - 30)
                    }
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                }.frame(height: imageHeight)
                .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
            }.edgesIgnoringSafeArea(.all)
            .overlay(
                DismissAndLikeView(isShowingDetail: $isShowingDetail),
                alignment: .topLeading
            )
        }.foregroundColor(.white)
        .navigationBarHidden(true)
    }
    
    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight
        
        // if our offset is roughly less than -225 (the amount scrolled / amount off screen)
        if offset < -sizeOffScreen {
            // Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
            let imageOffset = abs(min(-sizeOffScreen, offset))
            
            // Now we can the amount of offset above our size off screen. So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
            return imageOffset - sizeOffScreen
        }
        
        // Image was pulled down
        if offset > 0 {
            return -offset
            
        }
        
        return 0
    }
    
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        
        return blur * 6 // Values will range from 0 - 6
    }
    
    // 1
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY
        
        // (x - min) / (max - min) -> Normalize our values between 0 and 1
        
        // If our Title has surpassed the bottom of our image at the top
        // Current Y POS will start at 75 in the beginning. We essentially only want to offset our 'Title' about 30px.
        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
            let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
            let currentYValue = currentYPos
            
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
            let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
            
            // We will start at 20 pixels from the bottom (under our sticky header)
            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.
            print(20 - (percentage * finalOffset))
            return 20 - (percentage * finalOffset)
        }
        
        return .infinity
    }
    
}

struct DismissAndLikeView: View {
    @Binding var isShowingDetail: Bool
    var body: some View{
        HStack{
            Button(action: {
                withAnimation{
                    isShowingDetail.toggle()
                }
            }, label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .padding()
            })
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "heart")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .padding()
            })
        }
    }
}

let loremIpsum = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula
"""

class ViewFrame: ObservableObject {
    var startingRect: CGRect?
    
    @Published var frame: CGRect {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
    
    init() {
        self.frame = .zero
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(festival: MockData.festivals[0], isShowingDetail: .constant(false))
    }
}

struct ArtistInfoView: View {
    @Binding var titleRect: CGRect
    let festival: Festival
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("person")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                
                VStack(alignment: .leading) {
                    Text("Guest Show")
                        .font(.avenirNext(size: 12))
                        .foregroundColor(.gray)
                    Text("Brandon Baars")
                        .font(.avenirNext(size: 17))
                        .foregroundColor(.white)
                }
            }
            
            Text(festival.title)
                .font(.avenirNext(size: 28))
                .background(GeometryGetter(rect: self.$titleRect)) // 2
            
            Text(loremIpsum)
                .lineLimit(nil)
                .font(.avenirNextRegular(size: 17))
        }
        .padding(.horizontal)
        .padding(.vertical, 16.0)
    }
}
