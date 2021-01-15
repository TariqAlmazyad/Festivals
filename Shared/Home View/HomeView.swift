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
    @State private (set) var isShowingDetail: Bool = false
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
                            
                            NavigationLink(
                                destination: DetailView(festival: festival, isShowingDetail: $isShowingDetail),
                                isActive: $isShowingDetail,
                                label: {
                                    MusicFestivalCellView(proxy: proxy, festival: festival)
                                })
                            
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
