//
//  ContentView.swift
//  Shared
//
//  Created by Tariq Almazyad on 1/13/21.
//

import SwiftUI


enum TabBarButtons: String, CaseIterable {
    case House
    case Ticket
    case MapMarker
    case Profile
    
    var selectedImageName: String {
        switch self {
        case .House: return "house.fill"
        case .Ticket: return "ticket.fill"
        case .MapMarker: return "mappin.circle.fill"
        case .Profile: return "person.fill"
        }
    }
    
    var unSelectedImageName: String {
        switch self {
        case .House: return "house"
        case .Ticket: return "ticket"
        case .MapMarker: return "mappin.circle"
        case .Profile: return "person"
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .House: return 4
        case .Ticket: return 6
        case .MapMarker: return 3
        case .Profile: return 4
        }
    }
}

struct MainTabView: View {
    @State private (set) var selectedTabIndex: TabBarButtons = .House
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)), Color(#colorLiteral(red: 0.09998283535, green: 0.1434168518, blue: 0.1889503896, alpha: 1))]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack{
                TabView(selection: $selectedTabIndex) {
                    HomeView()
                        .tag(TabBarButtons.House)
                    Text("Ticket")
                        .tag(TabBarButtons.Ticket)
                    Text("Mapmarker")
                        .tag(TabBarButtons.MapMarker)
                    Text("Profile")
                        .tag(TabBarButtons.Profile)
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .foregroundColor(.white)
                Spacer()
                ButtonsTabView(selectedTabIndex: $selectedTabIndex)
                    .padding()
            }
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


struct ButtonsTabView: View {
    @Binding var selectedTabIndex: TabBarButtons
    var body: some View {
        HStack(alignment: .bottom){
            ForEach(TabBarButtons.allCases, id:\.self) { tabBarButton in
                Spacer()
                Button(action: {
                    withAnimation(.linear){
                        selectedTabIndex = tabBarButton
                    }
                }, label: {
                    VStack(spacing: 18){
                        Spacer()
                        Image(systemName: selectedTabIndex == tabBarButton ? tabBarButton.selectedImageName : tabBarButton.unSelectedImageName)
                            .shadow(color: selectedTabIndex == tabBarButton ? .white : .clear, radius: 10, x: 0.0, y: 0.0)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .light, design: .rounded))
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTabIndex == tabBarButton ? Color.white : Color.clear)
                            .frame(width: 40, height: 3)
                    }.padding(.bottom, tabBarButton.padding)
                    .offset( y: selectedTabIndex == tabBarButton ? -10 : 0)
                    
                })
                Spacer()
            }
            
        }.frame(width: UIScreen.main.bounds.width - 50, height: 80)
        .background(Color(#colorLiteral(red: 0.2077952027, green: 0.2640034556, blue: 0.3278865218, alpha: 1)))
        .clipShape(Capsule())
    }
}
