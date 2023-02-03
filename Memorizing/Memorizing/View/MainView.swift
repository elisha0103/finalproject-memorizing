//
//  TabView.swift
//  Memorizing
//
//  Created by 진준호 on 2023/01/05.
//

import SwiftUI
import FirebaseAuth

// MARK: 암기장, 마켓, 마이페이지를 Tab으로 보여주는 View
struct MainView: View {
    @State private var tabSelection = 1
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var marketStore: MarketStore
    @EnvironmentObject var myNoteStore: MyNoteStore
    @State var isFirstLogin: Bool = false
    
    var body: some View {
        // TODO: - 로그인 처음 화면에서 이름 바꿔주는 창 띄우기
        TabView(selection: $tabSelection) {
            NavigationStack {
                WordNotesView()
            }.tabItem {
                VStack {
                    Image(systemName: "note.text")
                    Text("암기장")
                }
            }.tag(1)
                .fullScreenCover(isPresented: $isFirstLogin) {
                    FirstLoginView(isFirstLogin: $isFirstLogin)
                }
            
            NavigationStack {
                MarketView()
            }.tabItem {
                VStack {
                    Image(systemName: "basket")
                    Text("마켓")
                }
            }.tag(2)
            
            NavigationStack {
                MyPageView()
            }.tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("마이페이지")
                }
            }.tag(3)
        }
        .onChange(of: authStore.state, perform: { newValue in
            if newValue == .firstIn {
                isFirstLogin.toggle()
            }
        })
        .task {
            await authStore.userInfoWillFetchDB()
                // MARK: coreData가 정상작동하면 이제 매번 페치 안해줘도됨 ( 정상 작동 시 코드 삭제)
//                myNoteStore.myNotesWillBeFetchedFromDB()

                    print("fetch marketnotes")
                    await marketStore.marketNotesWillFetchDB()
                    print("fetch filtermyNoteWillFetchDB")
                    await marketStore.filterMyNoteWillFetchDB()
                    print("fetch myNotesArrayWillfetchDB")
                    await marketStore.myNotesArrayWillFetchDB()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthStore())
            .environmentObject(MyNoteStore())
            .environmentObject(MarketStore())
    }
}
