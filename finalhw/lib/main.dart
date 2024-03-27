import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({required this.question, required this.options, required this.correctAnswer});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedIntroScreen(),
    );
  }
}

class AnimatedIntroScreen extends StatefulWidget {
  @override
  _AnimatedIntroScreenState createState() => _AnimatedIntroScreenState();
}

class _AnimatedIntroScreenState extends State<AnimatedIntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeInAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeInAnimation.value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                    width: 5,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage('image/home.png'), // 替換成實際的圖片資源
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "我的答題程式",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "kai",
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
                child: Text('進入答題'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<Question> questions = [
    Question(
      question: '1.下列何者為 OpenGL 自行定義之輸出?',
      options: ['(A) gl_Position', '(B) gl_PointSize', '(C) gl_ClipDistance', '(D) 以上皆是'],
      correctAnswer: '(D) 以上皆是',
    ),
    Question(
      question: '2.GL_UNSIGNED_BYTE 之數值範圍為下列何者?',
      options: ['(A) [0, 255]', '(B) [0, 127]', '(C) [0, 65535]', '(D) [0, 256]'],
      correctAnswer: '(A) [0, 255]',
    ),
    Question(
      question: '3.下列指令中何者只需輸入四次頂點即可形成一四邊形?',
      options: ['(A) GL_LINES', '(B) GL_LINE_STRIP', '(C) GL_LINE_LOOP', '(D) GL_POINTS'],
      correctAnswer: '(C) GL_LINE_LOOP',
    ),
    Question(
      question: '4.利用 GL_TRIANGLES 繪製兩個三角形需要輸入幾個頂點?',
      options: ['(A) 4', '(B) 5', '(C) 6', '(D) 7'],
      correctAnswer: '(C) 6',
    ),
    Question(
      question: '5.利用 GL_TRIANGLE_FAN 輸入四個點順序為 1234，下列何者為形成之兩個三角形?',
      options: ['(A) 123、234', '(B) 123、134', '(C) 124、123', '(D) 234、134'],
      correctAnswer: '(B) 123、134',
    ),
    Question(
      question: '6.下列何者可做為 glDrawElements 之引數在緩衝器中的資料型態?',
      options: ['(A) GL_UNSIGNED_BYTE', '(B) GL_UNSIGNED_SHORT', '(C) GL_UNSIGNED_INT', '(D) 以上皆是'],
      correctAnswer: '(D) 以上皆是',
    ),
    Question(
      question: '7.下列指令中何者可將指定的緩衝器綁定為指定的點的頂點緩衝器?',
      options: ['(A) glVertexAttribBinding', '(B) glBindVertexBuffer', '(C) glVertexAttribFormat', '(D) glVertexAttribPointer'],
      correctAnswer: '(B) glBindVertexBuffer',
    ),
    Question(
      question: '8.在頂點渲染器執行流程中，下列何者為非頂點渲染器之輸入?',
      options: ['(A) gl_VertexID', '(B) 使用者定義屬性', '(C) gl_PerVertex', '(D) gl_Instance'],
      correctAnswer: '(C) gl_PerVertex',
    ),
    Question(
      question: '9.下列何種情況可使用實例化來達成?',
      options: ['(A) 使用者需要繪製大量相同的幾何圖形', '(B) 繪製一複雜網格模型', '(C) 生成多種幾何圖形', '(D) 以上皆是'],
      correctAnswer: '(A) 使用者需要繪製大量相同的幾何圖形',
    ),
    Question(
      question: '10.下列指令中何者無法將頂點資訊傳入頂點渲染器中?',
      options: ['(A) glDrawElements', '(B) glDrawArrays', '(C) glGenBuffers', '(D) 以上皆非'],
      correctAnswer: '(C) glGenBuffers',
    ),
  ];
  List<Question> selectedQuestions = [];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Random random = Random();
    List<int> selectedIndices = [];

    while (selectedIndices.length < 5) {
      int randomIndex = random.nextInt(questions.length);
      if (!selectedIndices.contains(randomIndex)) {
        selectedIndices.add(randomIndex);
      }
    }

    setState(() {
      currentQuestionIndex = 0;
      correctAnswers = 0;
      selectedQuestions = selectedIndices.map((index) => questions[index]).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white, // 背景顏色設為白色
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '第 ${currentQuestionIndex + 1}/${selectedQuestions.length} 題',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            if (currentQuestionIndex < selectedQuestions.length)
              Text(
                selectedQuestions[currentQuestionIndex].question,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // 問題敘述文字顏色設為黑色
                ),
              ),
            SizedBox(height: 20.0),
            if (currentQuestionIndex < selectedQuestions.length)
              Column(
                children: selectedQuestions[currentQuestionIndex].options.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      checkAnswer(option);
                    },
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 20.0),
            if (currentQuestionIndex == selectedQuestions.length && currentQuestionIndex > 0)
              Text(
                '答對了 ${correctAnswers} 道題目中的 ${selectedQuestions.length} 道。',
                style: TextStyle(fontSize: 20.0),
              ),
          ],
        ),
      ),
    );
  }


  void checkAnswer(String selectedAnswer) {
    String correctAnswer = selectedQuestions[currentQuestionIndex].correctAnswer;
    bool isCorrect = selectedAnswer == correctAnswer || selectedAnswer == correctAnswer.substring(1, correctAnswer.length - 1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCorrect ? '答對了!' : '答錯了...',
            style: TextStyle(
              fontSize: 22.0,
              color: isCorrect ? Colors.green : Colors.red,
            ),
          ),
          content: Text(
            isCorrect
                ? '很好，繼續保持'
                : '正確答案是: ${selectedQuestions[currentQuestionIndex].correctAnswer}\n',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                updateGameState(isCorrect);
              },
              child: Text(
                '下一題',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateGameState(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        correctAnswers++;
      }
      currentQuestionIndex++;

      if (currentQuestionIndex == selectedQuestions.length) {
        showResultScreen();
      }
    });
  }

  void showResultScreen() {
    int totalQuestions = selectedQuestions.length;
    int score = correctAnswers;
    String rating = calculateScoreRating(score, totalQuestions);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('結算'),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Text(
                    '總共 $totalQuestions 題目',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                FittedBox(
                  child: Text(
                    '答對了 $score 題',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10.0),
                FittedBox(
                  child: Text(
                    '評價: $rating',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startGame();
                  },
                  child: Text('重新開始', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String calculateScoreRating(int score, int totalQuestions) {
    double percentage = (score / totalQuestions) * 100;

    if (percentage == 0) {
      return '太糟糕了，加油！';
    } else if (percentage < 40) {
      return '有進步的空間，繼續加油！';
    } else if (percentage < 70) {
      return '不錯，還可以更好！';
    } else if (percentage < 90) {
      return '太棒了，繼續保持!';
    } else {
      return '太棒了，全對!';
    }
  }
}
