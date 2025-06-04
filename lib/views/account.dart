import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedButton = 0; // 0: Follow, 1: Message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFDBA600)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trang cá nhân',
          style: TextStyle(
            color: Color(0xFFDBA600),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFDBA600)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Accont.jpg'),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hoàng Văn Hải',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStat('Bài viết', '100'),
                    _buildStat('Người theo dõi', '100'),
                    _buildStat('Theo dõi', '100'),
                  ],
                ),
                const SizedBox(height: 12),
                // Nút chọn 1 trong 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedButton == 0
                                ? const Color(0xFFDBA600)
                                : Colors.white,
                        foregroundColor:
                            selectedButton == 0
                                ? Colors.white
                                : const Color(0xFFDBA600),
                        side: const BorderSide(color: Color(0xFFDBA600)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        minimumSize: const Size(100, 36),
                        elevation: 0,
                      ),
                      child: const Text('Follow'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedButton == 1
                                ? const Color(0xFFDBA600)
                                : Colors.white,
                        foregroundColor:
                            selectedButton == 1
                                ? Colors.white
                                : const Color(0xFFDBA600),
                        side: const BorderSide(color: Color(0xFFDBA600)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        minimumSize: const Size(100, 36),
                        elevation: 0,
                      ),
                      child: const Text('Message'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Danh sách yêu thích
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Danh sách yêu thích',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemCount: 9, // Số lượng món yêu thích
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/Salad.jpg', // Thay bằng ảnh món ăn thực tế
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        // Nút thêm
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: FloatingActionButton(
                              backgroundColor: const Color(0xFFDBA600),
                              onPressed: () {},
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  static Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
