import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';

class inicio_page extends StatefulWidget {
  @override
  _inicio_pageState createState() => _inicio_pageState();
}

class _inicio_pageState extends State<inicio_page>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> descriptions = [
    "Bem-vindo ao nosso consultório médico! Estamos felizes em tê-lo(a) aqui. Nossa equipe dedicada de profissionais de saúde está pronta para cuidar de você com atenção, compreensão e cuidado. Com o nosso aplicativo de consulta médica, você pode marcar consultas de forma conveniente, acessar informações importantes sobre o seu tratamento e até mesmo se comunicar com os nossos médicos e equipe. Esperamos proporcionar uma experiência positiva e satisfatória para você. Obrigado por escolher o nosso consultório médico e confiar em nós para cuidar da sua saúde!",
    "Aqui você terá acesso a um atendimento rápido, eficiente e personalizado. Agende suas consultas com praticidade, receba lembretes, e tenha o cuidado com a sua saúde ao alcance das suas mãos. Faça parte dessa experiência única conosco!",
    "Aqui, você encontrará um ambiente acolhedor, com profissionais dedicados e uma experiência de atendimento diferenciada. Faça parte do nosso time e desfrute dos benefícios de um serviço de saúde de qualidade, focado no cuidado e bem-estar dos nossos pacientes",
  ];
  List<IconData> icons = [
    Icons.favorite,
    Icons.star,
    Icons.shopping_cart,
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Image.asset(
            'assets/fundo.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animação do coração

              SizedBox(height: 50),
              // Cards com traço indicando o card atual
              Expanded(
                child: PageView.builder(
                  itemCount: descriptions.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(255, 65, 139, 243),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[
                                index], // Ícone correspondente ao índice do card
                            size: 80,
                            color: Colors.black,
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "  ${descriptions[index]}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black, // Define a cor do texto como preto
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Traço indicando o card atual
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < descriptions.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentPage ? Colors.blue : Colors.grey,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              // Botão "Começar"
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => chegar_page()));
                },
                child: Text("Começar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
