//
//  SwiftUIView.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/14/21.
//

import SwiftUI

enum FestivalCategory: String, CaseIterable {
    case Musical
    case Book
    case Dance
    case Outdoor
    case Indoor
    case Club
    case VIPs
    
    var title: String{
        switch self {
        case .Musical: return "Musical Festival"
        case .Book: return "Book Festival"
        case .Dance: return "Dance Festival"
        case .Outdoor: return "Outdoor Festival"
        case .Indoor: return "Indoor Festival"
        case .Club: return "Club Festival"
        case .VIPs: return "VIPs Festival"
        }
    }
}

struct HomeView: View {
    @State private (set) var searchedText: String = ""
    @State private (set) var selectedCategory: FestivalCategory = .Musical
    var body: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .light, design: .rounded))
                })
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .light, design: .rounded))
                })
            }.padding()
            SearchBar(searchedText: $searchedText)
            CategoriesScrollView(selectedCategory: $selectedCategory)
            HStack{
                Text("Music Festivals")
                    .font(.system(size: 26, weight: .bold))
                Spacer()
                Button(action: {}, label: {
                    Text("See all")
                        .foregroundColor(Color(#colorLiteral(red: 0.5221560001, green: 0.5044791698, blue: 0.6503388286, alpha: 1)))
                })
            }.padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 240) {
                    ForEach(0..<20) { num in
                        GeometryReader { proxy in
                            ZStack {
                                Image("festival2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300)
                                    .clipped()
                                    .cornerRadius(5)
                                    .shadow(radius: 5)
                                    .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                                        height: .getScale(proxy: proxy, scalerView: .leftView)))
                                    .animation(.easeOut(duration: 0.5))
                                
                            }
                        }.frame(width: 125, height: 360)
                    }
                }.padding(32)
                .padding(.horizontal, 34)
                
            }
            
            Spacer()
        }.ignoresSafeArea()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct CategoriesScrollView: View {
    @Binding var selectedCategory: FestivalCategory
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(FestivalCategory.allCases, id:\.self) { category in
                    Button(action: {
                        withAnimation{
                            selectedCategory = category
                        }
                    }, label: {
                        Text(category.title)
                            .foregroundColor( selectedCategory == category ? .white : .gray)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding()
                            .background(selectedCategory == category ? Color(#colorLiteral(red: 0.5644914508, green: 0.406172514, blue: 0.8325149417, alpha: 1)) : Color(#colorLiteral(red: 0.207616061, green: 0.2596839666, blue: 0.3324835896, alpha: 1)))
                            .cornerRadius(20)
                            .shadow(color: selectedCategory == category ? Color.white.opacity(0.2) : Color.clear, radius: 8, x: 0.0, y: 0.0)
                        
                    }).padding(.horizontal, 6)
                }
            }.padding(12)
        }
    }
}
