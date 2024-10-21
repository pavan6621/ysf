import 'package:flutter/material.dart';
import 'package:ysf/const/constdata.dart';



class FAQ extends StatelessWidget {
  // List of FAQs related to sustainable food and business
  final List<Map<String, String>> faqs = [
    {
      "question": "What does Yannis Sustainable Food mean?",
      "answer": "Yannis Sustainable Food means that we focus on providing healthy, eco-friendly, and ethically sourced food that has a low environmental impact."
    },
    {
      "question": "How do you ensure the sustainability of your ingredients?",
      "answer": "We work with local farmers and suppliers who use sustainable farming methods, including organic practices and minimal waste packaging."
    },
    {
      "question": "Do you offer vegan or vegetarian options?",
      "answer": "Yes! We have a wide range of plant-based meals that are vegan and vegetarian-friendly, made from locally sourced ingredients."
    },
    {
      "question": "What are your delivery options?",
      "answer": "We offer eco-friendly delivery options using electric bikes and sustainable packaging that is either recyclable or compostable."
    },
    {
      "question": "Can I track my delivery in real-time?",
      "answer": "Yes, you can track your delivery in real-time through our app's 'Track Order' feature."
    },
    {
      "question": "How do I contact customer support?",
      "answer": "You can reach our customer support through the 'Help' section in the app or by emailing us at support@yannisfood.com."
    },
    {
      "question": "What is your return/refund policy?",
      "answer": "If you're not satisfied with your order, we offer a full refund or replacement within 24 hours of delivery. Please contact our support team for assistance."
    },
    {
      "question": "How can I reduce my carbon footprint when ordering from Yannis?",
      "answer": "You can help reduce your carbon footprint by opting for plant-based meals, reusing or recycling our packaging, and selecting bike delivery where available."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        title: Text(
          'FAQ - Yannis Sustainable Food',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () {
            Navigator.pushReplacementNamed(context, navigate_Bottomnavigation);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return FAQItem(faqs[index]["question"]!, faqs[index]["answer"]!);
        },
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: TextStyle(fontWeight: FontWeight.bold, ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.answer,
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
