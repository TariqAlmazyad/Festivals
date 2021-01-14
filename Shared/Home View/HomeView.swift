//
//  SwiftUIView.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/14/21.
//

import SwiftUI

struct HomeView: View {
    @State private (set) var searchedText: String = ""
    @State private (set) var selectedCategory: FestivalCategory = .Musical
    var body: some View {
        VStack(spacing: 0){
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
            // category
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
                HStack(spacing: 180) {
                    ForEach(MockData.festivals) { festival in
                        GeometryReader { proxy in
                            
                            MusicFestivalCellView(proxy: proxy, festival: festival)
                            
                        }.frame(width: 125, height: 360)
                        
                        
                    }
                }.padding(32)
                .padding(.horizontal, 34)
                .padding(.vertical)
                
                
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


struct MusicFestivalCellView: View {
    let proxy: GeometryProxy
    let festival: Festival
    var body: some View {
        ZStack {
            Image(festival.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 250)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
                .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                    height: .getScale(proxy: proxy, scalerView: .leftView)))
                .animation(.easeOut(duration: 0.5))
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]),
                           startPoint: .center, endPoint: .bottom)
                .frame(width: 250)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
                .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                    height: .getScale(proxy: proxy, scalerView: .leftView)))
                .animation(.easeOut(duration: 0.5))
            VStack{
                HStack{
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "heart")
                            .font(.title)
                            .padding(6)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(20)
                    })
                }.padding()
                Spacer()
                Group{
                    HStack{
                        Text("28 - 9 June, 2021")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    HStack{
                        Text(festival.title)
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        Spacer()
                    }.padding(.bottom)
                }.padding(.horizontal)
                
            }.frame(width: 250)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)
            .scaleEffect(CGSize(width: .getScale(proxy: proxy, scalerView: .leftView),
                                height: .getScale(proxy: proxy, scalerView: .leftView)))
            .animation(.easeOut(duration: 0.5))
            
        }
    }
}
