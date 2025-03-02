import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/logo.gif',
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'وزارة التعليم العالي والبحث العلمي',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'جامعة الموصل',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'كلية الهندسة',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'قسم هندسة الحاسوب',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'حول المشروع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "مشروع خاص بمادة الأنظمة المطمورة لقياس درجة الحرارة والرطوبة من الحساسات وحفضها في قاعدة البيانات ثم عرضها عن طريق تطبيق على الهاتف او على الحاسوب",
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'اعداد الطلاب',
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                      _buildFeatureText(' ضياء عبد مجيد '),
                      _buildFeatureText('اسماعيل رياض اسماعيل '),
                      _buildFeatureText(' عبدالرحمن هاشم عبدالواحد'),
                      _buildFeatureText("نهى عبدالعال عباس"),
                      _buildFeatureText("بهية هشام عبدالصمد"),
                      const SizedBox(height: 10),
                      const Text(
                        'يوفر التطبيق وسيلة فعّالة لمراقبة وتحليل البيانات التي جمعها من الحساسات. يساهم التطبيق في تحسين أداء الأنظمة من خلال توفير واجهة تفاعلية تُظهر البيانات بشكل دقيق وفي الوقت الفعلي، مما يُمكن المهندسين من اتخاذ قرارات مبنية على معطيات واقعية. علاوة على ذلك، يُعتبر المشروع أداة تعليمية قيمة تُسهم في تطوير مهارات الدمج بين البرمجيات والأجهزة، ويدعم البحث والابتكار في مجالات هندسة الحاسوب والأنظمة المضمنة',
                        style: TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Text(
            ' • ',
            style: TextStyle(fontSize: 30, height: 0.5),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 229, 91, 4)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
