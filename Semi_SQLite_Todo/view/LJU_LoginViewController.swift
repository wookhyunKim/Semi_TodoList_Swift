//
//  LJU_LoginViewController.swift
//  Semi_SQLite_Todo
//
//  Created by 이종욱 on 2023/08/31.
//

import UIKit
import KakaoSDKUser
class LJU_LoginViewController: UIViewController {

    
    
    @IBOutlet var tfId: UITextField!
    @IBOutlet var tfPw: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
    }
    
   
    
    
    
    
    //  참고사이트 https://seungchan.tistory.com/entry/Swift-%EC%B9%B4%EC%B9%B4%EC%98%A4-%EC%86%8C%EC%85%9C-%EB%A1%9C%EA%B7%B8%EC%9D%B8
    // 카카오 로그인버튼
    @IBAction func btnKaKao(_ sender: UIButton) {
        // 카카오웹으로 로그인
        UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    _ = oauthToken
                    // 로그인성공시 이메일,닉네임,토큰가져오기
                    UserApi.shared.me { [self] user, error in
                        if let error = error {
                            print(error)
                        } else {
                            // 이메일, 토큰, 닉네임 제대로 들어오는지 확인
                            guard let token = oauthToken?.accessToken, let email = user?.kakaoAccount?.email,
                                  let name = user?.kakaoAccount?.profile?.nickname else{
                                      print("token/email/name is nil")
                                      return
                                  }
                            // 이메일, 토큰, 닉네임확인하기
                            print(email)
                            print(token)
                            print(name)
                            // 일단 메인으로 가자...
                            self.performSegue(withIdentifier: "goMain", sender: self)
                            //서버에 이메일/토큰/이름 보내주기
                        }
                    }
                }
            }
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
