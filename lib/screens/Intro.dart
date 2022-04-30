import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'auth_screen.dart';
import 'variable.dart';

class Intro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.black87,
      pages: [
        PageViewModel(
          title: 'Welcome',
          body: 'Welcome to our Market,the best shopping app',
          image: Center(
            child: Image.asset('assets/images/log.jpg',height: 200,),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(25,Colors.white,FontWeight.w700),
            titleTextStyle: mystyle(27,Colors.white,FontWeight.w900),
          ),
        ),
        PageViewModel(
          title: 'buy or sale your product',
          body: 'you can buy your favorite product and you can sale your own product',
          image: Center(
            child: Image.asset('assets/images/log.jpg',height: 200,),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(25,Colors.white,FontWeight.w700),
            titleTextStyle: mystyle(27,Colors.white,FontWeight.w900),
          ),
        ),
        PageViewModel(
          title: 'Security',
          body: 'your security is important for us. our servers are secure and reliable',
          image: Center(
            child: Image.asset('assets/images/secure.png',height: 200,),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(25,Colors.white,FontWeight.w700),
            titleTextStyle: mystyle(27,Colors.white,FontWeight.w900),
          ),
        ),
      ],
      onDone: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen(authType: AuthType.register,)));
      },
      onSkip: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthScreen(authType: AuthType.register,)));
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next,size: 45,color: Colors.white,),
      next: const Icon(Icons.arrow_forward_ios),
      done: Text('Done',style: mystyle(20,Colors.white),),
    );
  }
}
